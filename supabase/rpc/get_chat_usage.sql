-- 대화 사용량 조회
-- Usage: select * from get_chat_usage('유저ID');
CREATE OR REPLACE FUNCTION get_chat_usage(p_user_id UUID)
RETURNS JSON AS $$
DECLARE
    v_remaining INT;
    v_limit INT;
    v_name TEXT;
BEGIN
    SELECT us.remaining_count, p.usage_limit, p.name
    INTO v_remaining, v_limit, v_name
    FROM user_subscriptions us
    JOIN products p ON us.product_id = p.id
    WHERE us.user_id = p_user_id
      AND us.status = 'active'
    ORDER BY us.updated_at DESC
    LIMIT 1;

    IF NOT FOUND THEN
        RETURN json_build_object(
            'remaining_count', 0,
            'total_limit', 0,
            'plan_name', 'None'
        );
    END IF;

    RETURN json_build_object(
        'remaining_count', v_remaining,
        'total_limit', v_limit,
        'plan_name', v_name
    );
END;
$$ LANGUAGE plpgsql SECURITY INVOKER;

COMMENT ON FUNCTION get_chat_usage IS '사용자의 현재 대화 사용량(남은 횟수, 총 횟수, 플랜명)을 조회합니다.';
