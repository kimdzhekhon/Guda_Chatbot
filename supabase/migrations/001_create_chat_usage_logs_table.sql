-- chat_usage_logs 테이블 생성 (크레딧 차감/충전 이력)
CREATE TABLE IF NOT EXISTS public.chat_usage_logs (
    id BIGSERIAL PRIMARY KEY,
    user_id UUID REFERENCES auth.users ON DELETE CASCADE NOT NULL,
    chat_room_id UUID REFERENCES public.chat_rooms ON DELETE SET NULL,
    action TEXT NOT NULL,        -- 'credit_used', 'credit_charged', 'credit_expired'
    amount INTEGER NOT NULL DEFAULT 1,
    remaining INTEGER NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE public.chat_usage_logs ENABLE ROW LEVEL SECURITY;
