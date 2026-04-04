-- 구매/결제 내역 조회 (본인 기록만)
-- Usage: select * from get_transaction_logs();
CREATE OR REPLACE FUNCTION get_transaction_logs()
RETURNS SETOF transaction_logs AS $$
BEGIN
    RETURN QUERY
    SELECT * FROM transaction_logs
    WHERE user_id = auth.uid()
    ORDER BY created_at DESC;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;
