-- 탈퇴 계정 재가입 차단 확인 (30일 이내 재가입 방지)
-- Usage: select * from check_deleted_account('user@email.com');
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
