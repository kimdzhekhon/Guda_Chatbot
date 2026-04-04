-- ==========================================
-- History Access RPC Functions
-- ==========================================

-- 1. 구매 내역 테이블 생성 (기존에 없다면 생성)
CREATE TABLE IF NOT EXISTS public.transaction_logs (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES auth.users ON DELETE CASCADE NOT NULL,
    product_name TEXT NOT NULL,
    amount INTEGER NOT NULL,
    status TEXT NOT NULL, -- 'success', 'fail', 'cancelled'
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- RLS 활성화 및 권한 설정
ALTER TABLE public.transaction_logs ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Users can view own transactions" ON public.transaction_logs;
CREATE POLICY "Users can view own transactions" ON public.transaction_logs
    FOR SELECT USING (auth.uid() = user_id);

-- 2. 사용 내역 조회 RPC 함수 생성 (현재 로그인 유저 대상)
-- Usage: select * from get_chat_usage_logs();
CREATE OR REPLACE FUNCTION public.get_chat_usage_logs()
RETURNS TABLE (
    id BIGINT,
    action TEXT,
    amount INTEGER,
    remaining INTEGER,
    created_at TIMESTAMPTZ,
    chat_room_title TEXT
) LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
DECLARE
    v_user_id UUID := auth.uid();
BEGIN
    IF v_user_id IS NULL THEN
        RAISE EXCEPTION 'NOT_AUTHENTICATED' USING HINT = '로그인이 필요합니다.';
    END IF;

    RETURN QUERY
    SELECT
        l.id,
        l.action,
        l.amount,
        l.remaining,
        l.created_at,
        r.title as chat_room_title
    FROM public.chat_usage_logs l
    LEFT JOIN public.chat_rooms r ON l.chat_room_id = r.id
    WHERE l.user_id = v_user_id
    ORDER BY l.created_at DESC;
END;
$$;

-- 3. 구매 내역 조회 RPC 함수 생성 (현재 로그인 유저 대상)
-- Usage: select * from get_transaction_logs();
CREATE OR REPLACE FUNCTION public.get_transaction_logs()
RETURNS TABLE (
    id UUID,
    product_name TEXT,
    amount INTEGER,
    status TEXT,
    created_at TIMESTAMPTZ
) LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
DECLARE
    v_user_id UUID := auth.uid();
BEGIN
    IF v_user_id IS NULL THEN
        RAISE EXCEPTION 'NOT_AUTHENTICATED' USING HINT = '로그인이 필요합니다.';
    END IF;

    RETURN QUERY
    SELECT
        t.id,
        t.product_name,
        t.amount,
        t.status,
        t.created_at
    FROM public.transaction_logs t
    WHERE t.user_id = v_user_id
    ORDER BY t.created_at DESC;
END;
$$;
