-- user_subscriptions INSERT 시 transaction_logs에 자동 기록하는 트리거
CREATE OR REPLACE FUNCTION public.log_transaction_on_subscription()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO public.transaction_logs (user_id, product_name, amount, status)
    VALUES (
        NEW.user_id,
        COALESCE(NULLIF(NEW.plan_name, ''), 'Unknown'),
        (SELECT COALESCE(price, 0) FROM public.products WHERE id = NEW.product_id),
        NEW.status
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trg_log_transaction ON public.user_subscriptions;

CREATE TRIGGER trg_log_transaction
    AFTER INSERT ON public.user_subscriptions
    FOR EACH ROW
    EXECUTE FUNCTION public.log_transaction_on_subscription();
