-- ==========================================
-- Guda Chatbot Database Security Policies (RLS)
-- ==========================================

-- 1. Profiles
DROP POLICY IF EXISTS "Users can only view their own profile." ON profiles;
DROP POLICY IF EXISTS "Users can only update their own profile." ON profiles;
DROP POLICY IF EXISTS "Users can only delete their own profile." ON profiles;
DROP POLICY IF EXISTS "Users can view own profile" ON profiles;
DROP POLICY IF EXISTS "Users can insert own profile" ON profiles;
DROP POLICY IF EXISTS "Users can update own profile" ON profiles;

CREATE POLICY "Users can view own profile"
  ON profiles FOR SELECT
  USING (auth.uid() = id);

CREATE POLICY "Users can insert own profile"
  ON profiles FOR INSERT
  WITH CHECK (auth.uid() = id);

CREATE POLICY "Users can update own profile"
  ON profiles FOR UPDATE
  USING (auth.uid() = id);

-- 2. Products (공개 조회 허용)
DROP POLICY IF EXISTS "Anyone can view products" ON products;
CREATE POLICY "Anyone can view products"
  ON products FOR SELECT
  USING (true);

CREATE POLICY "Users can view own subscriptions"
  ON user_subscriptions FOR SELECT
  USING (auth.uid() = user_id);

-- INSERT/UPDATE 정책 제거: 크레딧 조작 방지를 위해 RPC를 통해서만 수정 가능하도록 제한

-- 4. Chat Rooms (SELECT/INSERT/DELETE만 허용, UPDATE는 RPC 전용)
DROP POLICY IF EXISTS "Users can manage their own chat rooms." ON chat_rooms;
DROP POLICY IF EXISTS "chat_rooms_select" ON chat_rooms;
DROP POLICY IF EXISTS "chat_rooms_insert" ON chat_rooms;
DROP POLICY IF EXISTS "chat_rooms_delete" ON chat_rooms;

CREATE POLICY "chat_rooms_select"
  ON chat_rooms FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "chat_rooms_insert"
  ON chat_rooms FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "chat_rooms_delete"
  ON chat_rooms FOR DELETE
  USING (auth.uid() = user_id);

-- UPDATE 정책 없음: last_message_at/preview 등은 SECURITY DEFINER RPC(save_chat_message)를 통해서만 갱신

-- 5. Messages (SELECT/INSERT/DELETE만 허용, UPDATE 불가 — 메시지 변조 방지)
DROP POLICY IF EXISTS "Users can manage messages in their own rooms." ON messages;
DROP POLICY IF EXISTS "messages_select" ON messages;
DROP POLICY IF EXISTS "messages_insert" ON messages;
DROP POLICY IF EXISTS "messages_delete" ON messages;

CREATE POLICY "messages_select"
  ON messages FOR SELECT
  USING (
    EXISTS (
        SELECT 1 FROM chat_rooms
        WHERE chat_rooms.id = messages.chat_rooms_id
        AND chat_rooms.user_id = auth.uid()
    )
);

CREATE POLICY "messages_insert"
  ON messages FOR INSERT
  WITH CHECK (
    EXISTS (
        SELECT 1 FROM chat_rooms
        WHERE chat_rooms.id = messages.chat_rooms_id
        AND chat_rooms.user_id = auth.uid()
    )
);

CREATE POLICY "messages_delete"
  ON messages FOR DELETE
  USING (
    EXISTS (
        SELECT 1 FROM chat_rooms
        WHERE chat_rooms.id = messages.chat_rooms_id
        AND chat_rooms.user_id = auth.uid()
    )
);

CREATE POLICY "Users can view own usage logs"
  ON chat_usage_logs FOR SELECT
  USING (auth.uid() = user_id);

-- INSERT 정책 제거: 로그 조작 방지를 위해 RPC를 통해서만 기록 가능하도록 제한

-- 7. Transaction Logs
DROP POLICY IF EXISTS "Users can view own transaction logs" ON transaction_logs;
CREATE POLICY "Users can view own transaction logs"
  ON transaction_logs FOR SELECT
  USING (auth.uid() = user_id);

-- 8. System Config (인증 전 앱 버전/점검 체크를 위해 모든 사용자 조회 허용)
DROP POLICY IF EXISTS "Anyone can view system config" ON system_config;
CREATE POLICY "Anyone can view system config"
  ON system_config FOR SELECT
  USING (true);
