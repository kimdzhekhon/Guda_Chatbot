-- 대화 크레딧 1회 차감
-- Usage: select * from use_chat_credit('유저ID');
CREATE OR REPLACE FUNCTION use_chat_credit(p_user_id UUID)
RETURNS JSON AS $$
DECLARE
    v_product_id UUID;
    v_remaining INT;
    v_limit INT;
    v_name TEXT;
BEGIN
    -- 활성 구독 중 남은 횟수가 있는 건을 찾아 1 차감
    UPDATE user_subscriptions us
    SET remaining_count = us.remaining_count - 1,
        updated_at = NOW()
    FROM products p
    WHERE us.user_id = p_user_id
      AND us.product_id = p.id
      AND us.status = 'active'
      AND us.remaining_count > 0
      AND us.product_id = (
          SELECT us2.product_id
          FROM user_subscriptions us2
          WHERE us2.user_id = p_user_id
            AND us2.status = 'active'
            AND us2.remaining_count > 0
          ORDER BY us2.updated_at DESC
          LIMIT 1
      )
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
$$ LANGUAGE plpgsql SECURITY INVOKER;

COMMENT ON FUNCTION use_chat_credit IS '대화 크레딧을 1회 차감하고 갱신된 사용량을 반환합니다.';
