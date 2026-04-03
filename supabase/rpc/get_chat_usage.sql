-- 현재 로그인 사용자의 대화 사용량 조회
-- Usage: select * from get_chat_usage();
CREATE OR REPLACE FUNCTION get_chat_usage()
RETURNS JSON AS $$
DECLARE
    v_user_id UUID := auth.uid();
    v_row user_subscriptions;
BEGIN
    IF v_user_id IS NULL THEN
        RAISE EXCEPTION 'NOT_AUTHENTICATED' USING HINT = '로그인이 필요합니다.';
    END IF;

    SELECT *
    INTO v_row
    FROM user_subscriptions
    WHERE user_id = v_user_id
      AND status = 'active'
    ORDER BY updated_at DESC
    LIMIT 1;

    IF NOT FOUND THEN
        RETURN json_build_object(
            'remaining_count', 0,
            'total_limit', 0,
            'plan_name', 'None',
            'product_id', NULL
        );
    END IF;

    RETURN json_build_object(
        'remaining_count', v_row.remaining_count,
        'total_limit', v_row.total_limit,
        'plan_name', v_row.plan_name,
        'product_id', v_row.product_id
    );
END;
$$ LANGUAGE plpgsql SECURITY INVOKER;

COMMENT ON FUNCTION get_chat_usage IS '현재 로그인한 사용자의 대화 사용량(남은 횟수, 총 횟수, 플랜명, 상품ID)을 조회합니다.';
