-- user_subscriptions 테이블에 plan_name, total_limit 컬럼 추가
-- 기존 구독 데이터는 products 테이블에서 역채움

ALTER TABLE public.user_subscriptions
    ADD COLUMN IF NOT EXISTS plan_name TEXT NOT NULL DEFAULT '',
    ADD COLUMN IF NOT EXISTS total_limit INTEGER NOT NULL DEFAULT 0;

-- 기존 데이터 역채움: products 테이블에서 plan_name, total_limit 복사
UPDATE public.user_subscriptions us
SET plan_name   = p.name,
    total_limit = COALESCE(p.usage_limit, 0)
FROM public.products p
WHERE us.product_id = p.id
  AND (us.plan_name = '' OR us.total_limit = 0);
