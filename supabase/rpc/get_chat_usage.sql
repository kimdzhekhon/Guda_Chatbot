-- 대화 사용량 조회 (user_subscriptions 단일 테이블)
-- Usage: select * from get_chat_usage('유저ID');
CREATE OR REPLACE FUNCTION get_chat_usage(p_user_id UUID)
RETURNS JSON AS $$
DECLARE
    v_row user_subscriptions;
BEGIN
    SELECT *
    INTO v_row
    FROM user_subscriptions
    WHERE user_id = p_user_id
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

COMMENT ON FUNCTION get_chat_usage IS '사용자의 현재 대화 사용량(남은 횟수, 총 횟수, 플랜명, 상품ID)을 조회합니다.';
