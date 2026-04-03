-- 특정 채팅방 정보 단건 조회
-- Usage: select * from get_chat_room_by_id('방ID');
CREATE OR REPLACE FUNCTION get_chat_room_by_id(p_chat_room_id UUID)
RETURNS SETOF chat_rooms AS $$
DECLARE
    v_user_id UUID := auth.uid();
BEGIN
    RETURN QUERY
    SELECT * FROM chat_rooms
    WHERE id = p_chat_room_id
      AND user_id = v_user_id;
END;
$$ LANGUAGE plpgsql SECURITY INVOKER;

COMMENT ON FUNCTION get_chat_room_by_id IS '현재 로그인 사용자의 특정 채팅방 정보를 조회합니다. (본인 소유 여부 검증)';
