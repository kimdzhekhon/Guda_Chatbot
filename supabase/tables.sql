-- ==========================================
-- Guda Chatbot Database Tables
-- ==========================================

-- 1. Profiles (사용자 정보)
-- CREATE TABLE IF NOT EXISTS public.profiles (
--     id UUID REFERENCES auth.users ON DELETE CASCADE PRIMARY KEY,
--     nickname TEXT,
--     birth_date TEXT,
--     persona TEXT,
--     terms_agreed_at TIMESTAMPTZ,
--     updated_at TIMESTAMPTZ DEFAULT NOW(),
--     avatar_url TEXT
-- );
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- 2. Chat Rooms (채팅방)
-- CREATE TABLE IF NOT EXISTS public.chat_rooms (
--     id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
--     user_id UUID REFERENCES auth.users ON DELETE CASCADE NOT NULL,
--     title TEXT NOT NULL,
--     topic_code TEXT NOT NULL,
--     last_message_at TIMESTAMPTZ DEFAULT NOW(),
--     last_message_preview TEXT,
--     created_at TIMESTAMPTZ DEFAULT NOW()
-- );
ALTER TABLE public.chat_rooms ENABLE ROW LEVEL SECURITY;

-- 3. Messages (메시지)
-- CREATE TABLE IF NOT EXISTS public.messages (
--     id BIGSERIAL PRIMARY KEY,
--     chat_rooms_id UUID REFERENCES public.chat_rooms ON DELETE CASCADE NOT NULL,
--     content TEXT NOT NULL,
--     sender_role TEXT NOT NULL, -- 'user', 'assistant'
--     created_at TIMESTAMPTZ DEFAULT NOW()
-- );
ALTER TABLE public.messages ENABLE ROW LEVEL SECURITY;
