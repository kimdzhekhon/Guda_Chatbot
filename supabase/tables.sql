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
-- CREATE TYPE public.persona_type AS ENUM ('basic', 'friendly', 'strict');
-- CREATE TABLE IF NOT EXISTS public.chat_rooms (
--     id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
--     user_id UUID REFERENCES auth.users ON DELETE CASCADE NOT NULL,
--     title TEXT NOT NULL,
--     topic_code TEXT NOT NULL,
--     persona_id public.persona_type NOT NULL DEFAULT 'basic', -- 페르소나 매칭 (ENUM)
--     last_message_at TIMESTAMPTZ DEFAULT NOW(),
--     last_message_preview TEXT,
--     created_at TIMESTAMPTZ DEFAULT NOW()
-- );
ALTER TABLE public.chat_rooms ENABLE ROW LEVEL SECURITY;

-- ==== 페르소나 ENUM 설정 및 컬럼 반영 (실행 가능) ====
DO $$ BEGIN
    CREATE TYPE public.persona_type AS ENUM ('basic', 'friendly', 'strict');
EXCEPTION
    WHEN duplicate_object THEN NULL;
END $$;

DO $$
DECLARE
    col_type TEXT;
BEGIN
    SELECT data_type INTO col_type FROM information_schema.columns 
    WHERE table_schema = 'public' AND table_name = 'chat_rooms' AND column_name = 'persona_id';

    IF col_type IS NULL THEN
        EXECUTE 'ALTER TABLE public.chat_rooms ADD COLUMN persona_id public.persona_type NOT NULL DEFAULT ''basic''::public.persona_type';
    ELSIF col_type = 'text' THEN
        UPDATE public.chat_rooms SET persona_id = 'basic' WHERE persona_id IS NULL OR persona_id NOT IN ('basic', 'friendly', 'strict');
        ALTER TABLE public.chat_rooms ALTER COLUMN persona_id DROP DEFAULT;
        ALTER TABLE public.chat_rooms ALTER COLUMN persona_id TYPE public.persona_type USING persona_id::public.persona_type;
        ALTER TABLE public.chat_rooms ALTER COLUMN persona_id SET NOT NULL;
        ALTER TABLE public.chat_rooms ALTER COLUMN persona_id SET DEFAULT 'basic'::public.persona_type;
    END IF;
END $$;
-- =====================================================

-- 3. Messages (메시지)
-- CREATE TABLE IF NOT EXISTS public.messages (
--     id BIGSERIAL PRIMARY KEY,
--     chat_rooms_id UUID REFERENCES public.chat_rooms ON DELETE CASCADE NOT NULL,
--     content TEXT NOT NULL,
--     sender_role TEXT NOT NULL, -- 'user', 'assistant'
--     created_at TIMESTAMPTZ DEFAULT NOW()
-- );
ALTER TABLE public.messages ENABLE ROW LEVEL SECURITY;
