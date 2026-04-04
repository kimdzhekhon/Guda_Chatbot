-- ==========================================
-- History Access RPC Functions (Paginated)
-- ==========================================

CREATE TABLE IF NOT EXISTS public.transaction_logs (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES auth.users ON DELETE CASCADE NOT NULL,
    product_name TEXT NOT NULL,
    amount INTEGER NOT NULL,
    status TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE public.transaction_logs ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Users can view own transactions" ON public.transaction_logs;
CREATE POLICY "Users can view own transactions" ON public.transaction_logs
    FOR SELECT USING (auth.uid() = user_id);

-- 사용 내역 조회 (페이지네이션, 기본 100건, 최대 500건)
CREATE OR REPLACE FUNCTION public.get_chat_usage_logs(
    p_limit INT DEFAULT 100,
    p_offset INT DEFAULT 0
)
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
    IF p_limit > 500 THEN p_limit := 500; END IF;

    RETURN QUERY
    SELECT l.id, l.action, l.amount, l.remaining, l.created_at,
           r.title as chat_room_title
    FROM public.chat_usage_logs l
    LEFT JOIN public.chat_rooms r ON l.chat_room_id = r.id
    WHERE l.user_id = v_user_id
    ORDER BY l.created_at DESC
    LIMIT p_limit OFFSET p_offset;
END;
$$;

-- 구매 내역 조회 (페이지네이션)
CREATE OR REPLACE FUNCTION public.get_transaction_logs(
    p_limit INT DEFAULT 100,
    p_offset INT DEFAULT 0
)
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
    IF p_limit > 500 THEN p_limit := 500; END IF;

    RETURN QUERY
    SELECT t.id, t.product_name, t.amount, t.status, t.created_at
    FROM public.transaction_logs t
    WHERE t.user_id = v_user_id
    ORDER BY t.created_at DESC
    LIMIT p_limit OFFSET p_offset;
END;
$$;
