-- 5. 프로필 업서트 + 신규 유저 무료 크레딧 지급
-- Usage: select upsert_profile('유저ID', '페르소나', '약관동의시각');
CREATE OR REPLACE FUNCTION upsert_profile(
    p_user_id UUID,
    p_persona TEXT,
    p_terms_agreed_at TIMESTAMPTZ
)
RETURNS VOID AS $$
DECLARE
    v_is_new BOOLEAN;
    v_free_product_id UUID;
    v_free_product_name TEXT;
    v_free_product_limit INT;
BEGIN
    -- 신규 유저인지 확인
    SELECT NOT EXISTS (
        SELECT 1 FROM profiles WHERE id = p_user_id
    ) INTO v_is_new;

    -- 프로필 업서트
    INSERT INTO profiles (
        id,
        persona,
        terms_agreed_at,
        updated_at
    )
    VALUES (
        p_user_id,
        p_persona::persona_type,
        p_terms_agreed_at,
        NOW()
    )
    ON CONFLICT (id) DO UPDATE
    SET persona = EXCLUDED.persona,
        terms_agreed_at = EXCLUDED.terms_agreed_at,
        updated_at = NOW();

    -- 신규 유저인 경우 무료 크레딧 지급
    IF v_is_new THEN
        -- 무료 플랜 상품 조회
        SELECT id, name, COALESCE(usage_limit, 10)
        INTO v_free_product_id, v_free_product_name, v_free_product_limit
        FROM products
        WHERE type = 'free'
        LIMIT 1;

        -- 무료 상품이 존재하면 구독 생성
        IF v_free_product_id IS NOT NULL THEN
            INSERT INTO user_subscriptions (
                user_id, product_id, plan_name, status,
                total_limit, remaining_count
            )
            VALUES (
                p_user_id, v_free_product_id, v_free_product_name, 'active',
                v_free_product_limit, v_free_product_limit
            )
            ON CONFLICT (user_id, product_id) DO NOTHING;
        END IF;
    END IF;
END;
$$ LANGUAGE plpgsql SECURITY INVOKER;

COMMENT ON FUNCTION upsert_profile IS '사용자 프로필 정보를 생성하거나 갱신합니다. 신규 유저에게는 무료 대화 10회를 지급합니다.';
