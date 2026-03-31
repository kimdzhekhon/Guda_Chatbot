-- ==========================================
-- Guda Chatbot Database Security Policies (RLS)
-- ==========================================

-- 1. Profiles
DROP POLICY IF EXISTS "Users can only view their own profile." ON profiles;
CREATE POLICY "Users can only view their own profile." ON profiles FOR SELECT USING (auth.uid() = id);

DROP POLICY IF EXISTS "Users can only update their own profile." ON profiles;
CREATE POLICY "Users can only update their own profile." ON profiles FOR UPDATE USING (auth.uid() = id);

-- 2. Chat Rooms
DROP POLICY IF EXISTS "Users can manage their own chat rooms." ON chat_rooms;
CREATE POLICY "Users can manage their own chat rooms." ON chat_rooms FOR ALL USING (auth.uid() = user_id);

-- 3. Messages
DROP POLICY IF EXISTS "Users can manage messages in their own rooms." ON messages;
CREATE POLICY "Users can manage messages in their own rooms." ON messages FOR ALL USING (
    EXISTS (
        SELECT 1 FROM chat_rooms 
        WHERE chat_rooms.id = messages.chat_rooms_id 
        AND chat_rooms.user_id = auth.uid()
    )
);
