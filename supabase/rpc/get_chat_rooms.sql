-- 현재 로그인한 사용자의 채팅방 목록 조회
-- Usage: select * from get_chat_rooms();
CREATE OR REPLACE FUNCTION get_chat_rooms()
RETURNS SETOF chat_rooms AS $$
BEGIN
    RETURN QUERY 
    SELECT * FROM chat_rooms 
    WHERE user_id = auth.uid() 
    ORDER BY last_message_at DESC;
END;
$$ LANGUAGE plpgsql SECURITY INVOKER;

COMMENT ON FUNCTION get_chat_rooms IS '현재 로그인한 사용자의 모든 채팅방 목록을 반환합니다.';
