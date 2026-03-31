-- 1. 특정 사용자의 채팅방 목록 조회
-- Usage: select * from get_chat_rooms('user-uuid');
CREATE OR REPLACE FUNCTION get_chat_rooms(p_user_id UUID)
RETURNS SETOF chat_rooms AS $$
BEGIN
    RETURN QUERY 
    SELECT * FROM chat_rooms 
    WHERE user_id = p_user_id 
    ORDER BY last_message_at DESC;
END;
$$ LANGUAGE plpgsql SECURITY INVOKER;

COMMENT ON FUNCTION get_chat_rooms IS '특정 사용자의 모든 채팅방 목록을 반환합니다.';
