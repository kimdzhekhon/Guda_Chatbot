-- 대화 크레딧 1회 차감 (현재 로그인 유저 대상)
-- Usage: select * from use_chat_credit();
CREATE OR REPLACE FUNCTION use_chat_credit()
RETURNS JSON AS $$
DECLARE
    v_user_id UUID := auth.uid();
    v_product_id UUID;
    v_remaining INT;
    v_limit INT;
    v_name TEXT;
BEGIN
    if v_user_id IS NULL THEN
        RAISE EXCEPTION 'NOT_AUTHENTICATED'
            USING HINT = '로그인이 필요합니다.';
    END IF;

    -- CTE로 대상 행 1회 조회 + 잠금 → UPDATE (이중 스캔 방지)
    WITH target AS (
        SELECT product_id
        FROM user_subscriptions
        WHERE user_id = v_user_id
          AND status = 'active'
          AND remaining_count > 0
        ORDER BY updated_at DESC
        LIMIT 1
        FOR UPDATE SKIP LOCKED
    )
    UPDATE user_subscriptions us
    SET remaining_count = us.remaining_count - 1,
        updated_at = NOW()
    FROM products p
    WHERE us.user_id = v_user_id
      AND us.product_id = p.id
      AND us.product_id = (SELECT product_id FROM target)
    RETURNING us.remaining_count, p.usage_limit, p.name
    INTO v_remaining, v_limit, v_name;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'NO_CREDITS_REMAINING'
            USING HINT = '남은 대화 횟수가 없습니다.';
    END IF;

    RETURN json_build_object(
        'remaining_count', v_remaining,
        'total_limit', v_limit,
        'plan_name', v_name
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;

COMMENT ON FUNCTION use_chat_credit IS '현재 로그인한 사용자의 대화 크레딧을 1회 차감하고 갱신된 사용량을 반환합니다. (SECURITY DEFINER로 RLS 우회)';
