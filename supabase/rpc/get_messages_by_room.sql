-- 특정 채팅방의 메시지 목록 조회 (소유권 검증 + 페이지네이션)
-- Usage: select * from get_messages_by_room('방ID');
-- Usage: select * from get_messages_by_room('방ID', 50, 0);
CREATE OR REPLACE FUNCTION get_messages_by_room(
    p_chat_room_id UUID,
    p_limit INT DEFAULT 50,
    p_offset INT DEFAULT 0
)
RETURNS SETOF messages AS $$
DECLARE
    v_user_id UUID := auth.uid();
    v_owner_id UUID;
BEGIN
    -- 최대 조회 수 제한
    IF p_limit > 500 THEN
        p_limit := 500;
    END IF;

    -- 채팅방 소유자 확인
    SELECT user_id INTO v_owner_id
    FROM chat_rooms WHERE id = p_chat_room_id;

    IF v_owner_id IS NULL OR v_owner_id != v_user_id THEN
        RAISE EXCEPTION 'ACCESS_DENIED' USING HINT = '해당 채팅방에 대한 권한이 없습니다.';
    END IF;

    RETURN QUERY
    SELECT * FROM messages
    WHERE chat_rooms_id = p_chat_room_id
    ORDER BY created_at ASC
    LIMIT p_limit OFFSET p_offset;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;

COMMENT ON FUNCTION get_messages_by_room IS '특정 채팅방의 메시지를 시간순으로 반환합니다. (소유권 검증 + 페이지네이션)';
