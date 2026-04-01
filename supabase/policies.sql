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

-- 3. User Subscriptions
DROP POLICY IF EXISTS "Users can manage their own subscriptions." ON user_subscriptions;
DROP POLICY IF EXISTS "Users can view own subscriptions" ON user_subscriptions;
DROP POLICY IF EXISTS "Users can insert own subscriptions" ON user_subscriptions;
DROP POLICY IF EXISTS "Users can update own subscriptions" ON user_subscriptions;

CREATE POLICY "Users can view own subscriptions"
  ON user_subscriptions FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own subscriptions"
  ON user_subscriptions FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own subscriptions"
  ON user_subscriptions FOR UPDATE
  USING (auth.uid() = user_id);

-- 4. Chat Rooms
DROP POLICY IF EXISTS "Users can manage their own chat rooms." ON chat_rooms;
CREATE POLICY "Users can manage their own chat rooms." 
  ON chat_rooms FOR ALL 
  USING (auth.uid() = user_id);

-- 5. Messages
DROP POLICY IF EXISTS "Users can manage messages in their own rooms." ON messages;
CREATE POLICY "Users can manage messages in their own rooms."
  ON messages FOR ALL
  USING (
    EXISTS (
        SELECT 1 FROM chat_rooms
        WHERE chat_rooms.id = messages.chat_rooms_id
        AND chat_rooms.user_id = auth.uid()
    )
);

-- 6. System Config (인증 전 앱 버전/점검 체크를 위해 모든 사용자 조회 허용)
DROP POLICY IF EXISTS "Anyone can view system config" ON system_config;
CREATE POLICY "Anyone can view system config"
  ON system_config FOR SELECT
  USING (true);
