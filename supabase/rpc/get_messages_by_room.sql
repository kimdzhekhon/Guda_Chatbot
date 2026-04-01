-- 2. 특정 채팅방의 메시지 목록 조회
-- Usage: select * from get_messages_by_room('room-uuid');
CREATE OR REPLACE FUNCTION get_messages_by_room(p_chat_room_id UUID)
RETURNS SETOF messages AS $$
BEGIN
    RETURN QUERY 
    SELECT * FROM messages 
    WHERE chat_rooms_id = p_chat_room_id 
    ORDER BY created_at ASC;
END;
$$ LANGUAGE plpgsql SECURITY INVOKER;

COMMENT ON FUNCTION get_messages_by_room IS '특정 채팅방의 모든 메시지 목록을 생성 순으로 반환합니다.';
