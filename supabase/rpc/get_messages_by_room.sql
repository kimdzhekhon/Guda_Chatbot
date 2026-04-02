-- 특정 채팅방의 메시지 목록 조회 (소유권 검증 포함)
-- Usage: select * from get_messages_by_room('방ID');
CREATE OR REPLACE FUNCTION get_messages_by_room(p_chat_room_id UUID)
RETURNS SETOF messages AS $$
DECLARE
    v_user_id UUID := auth.uid();
    v_owner_id UUID;
BEGIN
    -- 채팅방 소유자 확인
    SELECT user_id INTO v_owner_id
    FROM chat_rooms WHERE id = p_chat_room_id;

    IF v_owner_id IS NULL OR v_owner_id != v_user_id THEN
        RAISE EXCEPTION 'ACCESS_DENIED' USING HINT = '해당 채팅방에 대한 권한이 없습니다.';
    END IF;

    RETURN QUERY 
    SELECT * FROM messages 
    WHERE chat_rooms_id = p_chat_room_id 
    ORDER BY created_at ASC;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;

COMMENT ON FUNCTION get_messages_by_room IS '특정 채팅방의 모든 메시지를 시간순으로 반환합니다. (소유권 검증 포함)';
