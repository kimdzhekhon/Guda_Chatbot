-- 무료 플랜 상품 등록 (1회만 실행)
-- Supabase SQL Editor에서 실행하세요.
INSERT INTO products (name, type, price, usage_limit, description, icon_name, price_per_chat)
VALUES ('Guda Free', 'free', 0, 10, '무료 체험 플랜 (10회)', 'card_giftcard', 0)
ON CONFLICT DO NOTHING;
