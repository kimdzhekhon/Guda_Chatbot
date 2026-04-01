-- ==========================================
-- Guda Chatbot Database Tables
-- ==========================================

-- 0. 페르소나 ENUM 설정
DO $$ BEGIN
    CREATE TYPE public.persona_type AS ENUM ('basic', 'friendly', 'strict');
EXCEPTION
    WHEN duplicate_object THEN NULL;
END $$;

-- 1. Profiles (사용자 정보)
CREATE TABLE IF NOT EXISTS public.profiles (
    id UUID REFERENCES auth.users ON DELETE CASCADE PRIMARY KEY,
    persona public.persona_type DEFAULT 'basic'::public.persona_type,
    terms_agreed_at TIMESTAMPTZ,
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    avatar_url TEXT
);
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- 2. Products (상품/플랜 정보)
CREATE TABLE IF NOT EXISTS public.products (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name TEXT NOT NULL,
    type TEXT NOT NULL, -- 'free', 'subscription', 'charge'
    price INTEGER NOT NULL,
    usage_limit INTEGER,
    description TEXT,
    icon_name TEXT,
    price_per_chat DOUBLE PRECISION DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE public.products ENABLE ROW LEVEL SECURITY;

-- 3. User Subscriptions (사용자 구독/구매 내역)
CREATE TABLE IF NOT EXISTS public.user_subscriptions (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES auth.users ON DELETE CASCADE NOT NULL,
    product_id UUID REFERENCES public.products ON DELETE CASCADE NOT NULL,
    status TEXT NOT NULL DEFAULT 'active', -- 'active', 'expired', 'cancelled'
    remaining_count INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(user_id, product_id)
);
ALTER TABLE public.user_subscriptions ENABLE ROW LEVEL SECURITY;

-- 4. Chat Rooms (채팅방)
CREATE TABLE IF NOT EXISTS public.chat_rooms (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES auth.users ON DELETE CASCADE NOT NULL,
    title TEXT NOT NULL,
    topic_code TEXT NOT NULL,
    persona_id public.persona_type NOT NULL DEFAULT 'basic'::public.persona_type,
    last_message_at TIMESTAMPTZ DEFAULT NOW(),
    last_message_preview TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE public.chat_rooms ENABLE ROW LEVEL SECURITY;

-- 5. Messages (메시지)
CREATE TABLE IF NOT EXISTS public.messages (
    id BIGSERIAL PRIMARY KEY,
    chat_rooms_id UUID REFERENCES public.chat_rooms ON DELETE CASCADE NOT NULL,
    content TEXT NOT NULL,
    sender_role TEXT NOT NULL, -- 'user', 'assistant'
    created_at TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE public.messages ENABLE ROW LEVEL SECURITY;
