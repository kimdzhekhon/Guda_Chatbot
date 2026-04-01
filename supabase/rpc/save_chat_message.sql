-- 메시지 저장 + 크레딧 차감 + 사용 로그 기록 (Atomic 작업)
-- user 메시지일 때만 크레딧을 차감하고 로그를 남김
-- Usage: select * from save_chat_message('방ID', '내용', 'user/assistant');
CREATE OR REPLACE FUNCTION save_chat_message(
    p_chat_room_id UUID,
    p_content TEXT,
    p_sender_role TEXT
)
RETURNS JSON AS $$
DECLARE
    v_msg messages;
    v_user_id UUID;
    v_remaining INT;
    v_limit INT;
    v_name TEXT;
    v_product_id UUID;
BEGIN
    -- 1. 메시지 테이블 삽입
    INSERT INTO messages (chat_rooms_id, content, sender_role)
    VALUES (p_chat_room_id, p_content, p_sender_role)
    RETURNING * INTO v_msg;

    -- 2. 채팅방 테이블 최신 상태 업데이트
    UPDATE chat_rooms
    SET last_message_at = v_msg.created_at,
        last_message_preview = p_content
    WHERE id = p_chat_room_id;

    -- 3. user 메시지인 경우에만 크레딧 차감 + 로그 기록
    IF p_sender_role = 'user' THEN
        -- 채팅방 소유자 조회
        SELECT user_id INTO v_user_id
        FROM chat_rooms WHERE id = p_chat_room_id;

        -- 활성 구독에서 크레딧 1 차감 (user_subscriptions 단일 테이블)
        UPDATE user_subscriptions
        SET remaining_count = remaining_count - 1,
            updated_at = NOW()
        WHERE user_id = v_user_id
          AND status = 'active'
          AND remaining_count > 0
          AND product_id = (
              SELECT product_id
              FROM user_subscriptions
              WHERE user_id = v_user_id
                AND status = 'active'
                AND remaining_count > 0
              ORDER BY updated_at DESC
              LIMIT 1
          )
        RETURNING remaining_count, total_limit, plan_name, product_id
        INTO v_remaining, v_limit, v_name, v_product_id;

        IF NOT FOUND THEN
            RAISE EXCEPTION 'NO_CREDITS_REMAINING'
                USING HINT = '남은 대화 횟수가 없습니다.';
        END IF;

        -- 사용 로그 기록
        INSERT INTO chat_usage_logs (user_id, chat_room_id, action, amount, remaining)
        VALUES (v_user_id, p_chat_room_id, 'credit_used', 1, v_remaining);

        RETURN json_build_object(
            'message', json_build_object(
                'id', v_msg.id,
                'chat_rooms_id', v_msg.chat_rooms_id,
                'content', v_msg.content,
                'sender_role', v_msg.sender_role,
                'created_at', v_msg.created_at
            ),
            'usage', json_build_object(
                'remaining_count', v_remaining,
                'total_limit', v_limit,
                'plan_name', v_name,
                'product_id', v_product_id
            )
        );
    END IF;

    -- assistant 메시지는 usage 없이 반환
    RETURN json_build_object(
        'message', json_build_object(
            'id', v_msg.id,
            'chat_rooms_id', v_msg.chat_rooms_id,
            'content', v_msg.content,
            'sender_role', v_msg.sender_role,
            'created_at', v_msg.created_at
        ),
        'usage', NULL
    );
END;
$$ LANGUAGE plpgsql SECURITY INVOKER;

COMMENT ON FUNCTION save_chat_message IS '메시지를 저장하고, user 메시지인 경우 크레딧 차감 및 사용 로그를 기록합니다.';
