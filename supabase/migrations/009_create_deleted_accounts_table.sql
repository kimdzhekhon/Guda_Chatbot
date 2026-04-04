-- ============================================================
-- 009: 탈퇴 계정 기록 테이블 + 삭제 RPC (30일 재가입 방지)
-- ============================================================

CREATE TABLE IF NOT EXISTS public.deleted_accounts (
  id BIGSERIAL PRIMARY KEY,
  email TEXT NOT NULL,
  provider TEXT NOT NULL DEFAULT 'unknown',
  user_id UUID NOT NULL,
  deleted_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_deleted_accounts_email ON deleted_accounts (email);
CREATE INDEX IF NOT EXISTS idx_deleted_accounts_deleted_at ON deleted_accounts (deleted_at);

ALTER TABLE public.deleted_accounts ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "deleted_accounts_service_insert" ON deleted_accounts;
CREATE POLICY "deleted_accounts_service_insert"
  ON deleted_accounts FOR INSERT TO service_role WITH CHECK (true);

DROP POLICY IF EXISTS "deleted_accounts_service_select" ON deleted_accounts;
CREATE POLICY "deleted_accounts_service_select"
  ON deleted_accounts FOR SELECT TO service_role USING (true);

DROP POLICY IF EXISTS "deleted_accounts_service_delete" ON deleted_accounts;
CREATE POLICY "deleted_accounts_service_delete"
  ON deleted_accounts FOR DELETE TO service_role USING (true);

-- ============================================================
-- 재가입 차단 확인 함수
-- ============================================================
CREATE OR REPLACE FUNCTION check_deleted_account(check_email TEXT)
RETURNS TABLE (
  is_blocked BOOLEAN,
  remaining_days INTEGER
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  last_deleted TIMESTAMPTZ;
  days_left INTEGER;
BEGIN
  SELECT da.deleted_at INTO last_deleted
  FROM deleted_accounts da
  WHERE da.email = check_email
  ORDER BY da.deleted_at DESC
  LIMIT 1;

  IF last_deleted IS NULL THEN
    RETURN QUERY SELECT false, 0;
    RETURN;
  END IF;

  days_left := 30 - EXTRACT(DAY FROM (NOW() - last_deleted))::INTEGER;

  IF days_left > 0 THEN
    RETURN QUERY SELECT true, days_left;
  ELSE
    RETURN QUERY SELECT false, 0;
  END IF;
END;
$$;

GRANT EXECUTE ON FUNCTION check_deleted_account(TEXT) TO authenticated;

-- ============================================================
-- 사용자 데이터 일괄 삭제 함수 (Edge Function에서 호출)
-- SECURITY DEFINER로 RLS를 완전히 우회
-- transaction_logs는 결제 감사 이력으로 보존
-- ============================================================
CREATE OR REPLACE FUNCTION delete_user_data(target_user_id UUID)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  -- 1. messages (chat_rooms FK 참조 → 자식 먼저)
  DELETE FROM public.messages
  WHERE chat_rooms_id IN (
    SELECT id FROM public.chat_rooms WHERE user_id = target_user_id
  );

  -- 2. chat_usage_logs
  DELETE FROM public.chat_usage_logs
  WHERE user_id = target_user_id;

  -- 3. chat_rooms
  DELETE FROM public.chat_rooms
  WHERE user_id = target_user_id;

  -- 4. user_subscriptions
  DELETE FROM public.user_subscriptions
  WHERE user_id = target_user_id;

  -- 5. profiles
  DELETE FROM public.profiles
  WHERE id = target_user_id;
END;
$$;

-- service_role만 호출 가능
REVOKE EXECUTE ON FUNCTION delete_user_data(UUID) FROM public;
REVOKE EXECUTE ON FUNCTION delete_user_data(UUID) FROM authenticated;
GRANT EXECUTE ON FUNCTION delete_user_data(UUID) TO service_role;
