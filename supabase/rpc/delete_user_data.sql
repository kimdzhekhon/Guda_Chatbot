-- 회원 탈퇴 시 사용자 데이터 일괄 삭제 (service_role 전용)
-- transaction_logs는 결제 이력으로 보존
CREATE OR REPLACE FUNCTION delete_user_data(target_user_id UUID)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  -- 자식 → 부모 순서로 삭제 (FK 제약 충돌 방지)

  -- 1. messages (chat_rooms FK 참조)
  DELETE FROM messages
  WHERE chat_rooms_id IN (
    SELECT id FROM chat_rooms WHERE user_id = target_user_id
  );

  -- 2. chat_usage_logs
  DELETE FROM chat_usage_logs WHERE user_id = target_user_id;

  -- 3. chat_rooms
  DELETE FROM chat_rooms WHERE user_id = target_user_id;

  -- 4. user_subscriptions
  DELETE FROM user_subscriptions WHERE user_id = target_user_id;

  -- 5. profiles
  DELETE FROM profiles WHERE id = target_user_id;

  -- transaction_logs는 보존 (결제/환불 감사 이력)
END;
$$;
