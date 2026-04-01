-- user_subscriptions 변경 시 transaction_logs에 자동 기록하는 트리거
CREATE OR REPLACE FUNCTION public.log_transaction_on_subscription()
RETURNS TRIGGER AS $$
DECLARE
    v_product_name TEXT;
BEGIN
    -- 상품명 조회
    SELECT name INTO v_product_name
    FROM public.products
    WHERE id = NEW.product_id;

    INSERT INTO public.transaction_logs (user_id, product_name, amount, status)
    VALUES (
        NEW.user_id,
        COALESCE(v_product_name, 'Unknown'),
        (SELECT COALESCE(price, 0) FROM public.products WHERE id = NEW.product_id),
        NEW.status
    );

    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 기존 트리거 제거 후 재생성
DROP TRIGGER IF EXISTS trg_log_transaction ON public.user_subscriptions;

CREATE TRIGGER trg_log_transaction
    AFTER INSERT ON public.user_subscriptions
    FOR EACH ROW
    EXECUTE FUNCTION public.log_transaction_on_subscription();
