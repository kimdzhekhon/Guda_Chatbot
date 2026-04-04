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
    type TEXT NOT NULL CHECK (type IN ('free', 'subscription', 'charge')),
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
    plan_name TEXT NOT NULL DEFAULT '',           -- 구독 플랜명 (비정규화)
    status TEXT NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'expired', 'cancelled')),
    total_limit INTEGER NOT NULL DEFAULT 0,       -- 총 제공 횟수
    remaining_count INTEGER NOT NULL DEFAULT 0,   -- 남은 횟수
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
    sender_role TEXT NOT NULL CHECK (sender_role IN ('user', 'assistant')),
    created_at TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE public.messages ENABLE ROW LEVEL SECURITY;

-- 6. Chat Usage Logs (채팅 사용 로그 — 크레딧 차감/충전 이력)
CREATE TABLE IF NOT EXISTS public.chat_usage_logs (
    id BIGSERIAL PRIMARY KEY,
    user_id UUID REFERENCES auth.users ON DELETE CASCADE NOT NULL,
    chat_room_id UUID REFERENCES public.chat_rooms ON DELETE SET NULL,
    action TEXT NOT NULL CHECK (action IN ('credit_used', 'credit_charged', 'credit_expired')),
    amount INTEGER NOT NULL DEFAULT 1,
    remaining INTEGER NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE public.chat_usage_logs ENABLE ROW LEVEL SECURITY;

-- 7. Transaction Logs (구매/결제 내역)
CREATE TABLE IF NOT EXISTS public.transaction_logs (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES auth.users ON DELETE CASCADE NOT NULL,
    product_name TEXT NOT NULL,
    amount INTEGER NOT NULL,
    status TEXT NOT NULL DEFAULT 'success' CHECK (status IN ('success', 'fail', 'cancelled')),
    created_at TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE public.transaction_logs ENABLE ROW LEVEL SECURITY;

-- 8. System Config (시스템 설정 — 앱 공지 및 점검 정보)
CREATE TABLE IF NOT EXISTS public.system_config (
    id SERIAL PRIMARY KEY,
    min_version TEXT,
    is_maintenance BOOLEAN DEFAULT false,
    notice_title TEXT,
    notice_content TEXT,
    updated_at TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE public.system_config ENABLE ROW LEVEL SECURITY;

-- ==========================================
-- RAG 파이프라인 테이블
-- ==========================================

-- pgvector 확장
CREATE EXTENSION IF NOT EXISTS vector;

-- 9. I Ching Documents (주역 문서 — 벡터 임베딩 포함)
CREATE TABLE IF NOT EXISTS public.i_ching_documents (
    id SERIAL PRIMARY KEY,
    content TEXT NOT NULL,
    metadata JSONB,
    embedding vector(768),
    created_at TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE public.i_ching_documents ENABLE ROW LEVEL SECURITY;

CREATE INDEX IF NOT EXISTS idx_i_ching_content_gin
  ON i_ching_documents USING gin (to_tsvector('simple', content));

-- 10. Tripitaka Documents (팔만대장경 + 구사론)
CREATE TABLE IF NOT EXISTS public.tripitaka_documents (
    id BIGSERIAL PRIMARY KEY,
    content TEXT NOT NULL,
    source TEXT,
    source_lang TEXT DEFAULT 'ko',
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE public.tripitaka_documents ENABLE ROW LEVEL SECURITY;

CREATE INDEX IF NOT EXISTS idx_tripitaka_source ON tripitaka_documents (source);
CREATE INDEX IF NOT EXISTS idx_tripitaka_lang ON tripitaka_documents (source_lang);
CREATE INDEX IF NOT EXISTS idx_tripitaka_content_gin
  ON tripitaka_documents USING gin (to_tsvector('simple', content));

-- 11. I Ching Cache (주역 응답 캐시)
CREATE TABLE IF NOT EXISTS public.i_ching_cache (
    id SERIAL PRIMARY KEY,
    hexagram_number INTEGER NOT NULL,
    line_number INTEGER,
    query_hash VARCHAR(64) NOT NULL,
    interpretation TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    hit_count INTEGER DEFAULT 0,
    UNIQUE(query_hash)
);
ALTER TABLE public.i_ching_cache ENABLE ROW LEVEL SECURITY;

-- 12. Deleted Accounts (탈퇴 계정 기록 — 30일 재가입 방지)
CREATE TABLE IF NOT EXISTS public.deleted_accounts (
    id BIGSERIAL PRIMARY KEY,
    email TEXT NOT NULL,
    provider TEXT NOT NULL DEFAULT 'unknown',
    user_id UUID NOT NULL,
    deleted_at TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE public.deleted_accounts ENABLE ROW LEVEL SECURITY;

CREATE INDEX IF NOT EXISTS idx_deleted_accounts_email ON deleted_accounts (email);
CREATE INDEX IF NOT EXISTS idx_deleted_accounts_deleted_at ON deleted_accounts (deleted_at);

-- 13. Bookmarks (북마크)
CREATE TABLE IF NOT EXISTS public.bookmarks (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES auth.users ON DELETE CASCADE NOT NULL,
    title TEXT NOT NULL,
    content TEXT NOT NULL,
    type TEXT NOT NULL DEFAULT 'message' CHECK (type IN ('message', 'hexagram')),
    reference_id TEXT NOT NULL,
    chat_room_id UUID REFERENCES public.chat_rooms ON DELETE SET NULL,
    topic_code TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE public.bookmarks ENABLE ROW LEVEL SECURITY;

CREATE UNIQUE INDEX IF NOT EXISTS idx_bookmarks_user_reference
    ON bookmarks (user_id, reference_id);
CREATE INDEX IF NOT EXISTS idx_bookmarks_user_id
    ON bookmarks (user_id, created_at DESC);
