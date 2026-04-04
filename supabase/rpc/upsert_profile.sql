-- 프로필 업서트 + 신규 유저 무료 크레딧 지급 (현재 로그인 유저 대상)
-- Usage: select upsert_profile('basic', '2024-01-01T00:00:00Z');
CREATE OR REPLACE FUNCTION upsert_profile(
    p_persona TEXT,
    p_terms_agreed_at TIMESTAMPTZ
)
RETURNS VOID AS $$
DECLARE
    v_user_id UUID := auth.uid();
    v_is_new BOOLEAN;
    v_free_product_id UUID;
    v_free_product_name TEXT;
    v_free_product_limit INT;
BEGIN
    IF v_user_id IS NULL THEN
        RAISE EXCEPTION 'NOT_AUTHENTICATED'
            USING HINT = '로그인이 필요합니다.';
    END IF;

    IF p_persona NOT IN ('basic', 'friendly', 'strict') THEN
        RAISE EXCEPTION 'INVALID_PERSONA'
            USING HINT = '유효하지 않은 페르소나입니다. (basic, friendly, strict)';
    END IF;

    -- 무료 구독이 없는 유저인지 확인 (handle_new_user trigger가 profiles를 먼저 생성하므로)
    SELECT NOT EXISTS (
        SELECT 1 FROM user_subscriptions WHERE user_id = v_user_id
    ) INTO v_is_new;

    -- 프로필 업서트
    INSERT INTO profiles (
        id,
        persona,
        terms_agreed_at,
        updated_at
    )
    VALUES (
        v_user_id,
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
                v_user_id, v_free_product_id, v_free_product_name, 'active',
                v_free_product_limit, v_free_product_limit
            )
            ON CONFLICT (user_id, product_id) DO NOTHING;
        END IF;
    END IF;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;

COMMENT ON FUNCTION upsert_profile IS '현재 로그인한 사용자의 프로필 정보를 생성하거나 갱신하며, 신규 유저에게 무료 크레딧을 지급합니다. (SECURITY DEFINER 적용)';
