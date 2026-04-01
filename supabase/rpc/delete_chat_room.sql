-- 7. 채팅방 삭제
-- Usage: select delete_chat_room('방ID');
CREATE OR REPLACE FUNCTION delete_chat_room(p_chat_room_id UUID)
RETURNS VOID AS $$
BEGIN
    DELETE FROM chat_rooms WHERE id = p_chat_room_id;
END;
$$ LANGUAGE plpgsql SECURITY INVOKER;

COMMENT ON FUNCTION delete_chat_room IS '지정한 채팅방을 삭제합니다.';
