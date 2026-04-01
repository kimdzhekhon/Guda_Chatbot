-- chat_usage_logs RLS 정책
DROP POLICY IF EXISTS "Users can view own usage logs" ON chat_usage_logs;
CREATE POLICY "Users can view own usage logs"
  ON chat_usage_logs FOR SELECT
  USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can insert own usage logs" ON chat_usage_logs;
CREATE POLICY "Users can insert own usage logs"
  ON chat_usage_logs FOR INSERT
  WITH CHECK (auth.uid() = user_id);
