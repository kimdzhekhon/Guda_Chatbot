-- transaction_logs 테이블을 올바른 스키마로 재생성
-- 기존 테이블에 필요한 컬럼이 누락되어 있으므로 DROP 후 재생성
DROP TABLE IF EXISTS public.transaction_logs CASCADE;

CREATE TABLE public.transaction_logs (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES auth.users ON DELETE CASCADE NOT NULL,
    product_name TEXT NOT NULL DEFAULT '',
    amount INTEGER NOT NULL DEFAULT 0,
    status TEXT NOT NULL DEFAULT 'success', -- 'success', 'fail', 'cancelled'
    created_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE public.transaction_logs ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own transactions" ON public.transaction_logs
    FOR SELECT USING (auth.uid() = user_id);

-- get_transaction_logs RPC 함수 재생성
CREATE OR REPLACE FUNCTION public.get_transaction_logs(p_user_id UUID)
RETURNS TABLE (
    id UUID,
    product_name TEXT,
    amount INTEGER,
    status TEXT,
    created_at TIMESTAMPTZ
) LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
    RETURN QUERY
    SELECT
        t.id,
        t.product_name,
        t.amount,
        t.status,
        t.created_at
    FROM public.transaction_logs t
    WHERE t.user_id = p_user_id
    ORDER BY t.created_at DESC;
END;
$$;
