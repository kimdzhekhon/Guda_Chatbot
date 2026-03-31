-- 3. 새 채팅방 생성
-- Usage: select * from create_chat_room('제목', '토픽코드', '유저아이디');
CREATE OR REPLACE FUNCTION create_chat_room(p_title TEXT, p_topic_code TEXT, p_user_id UUID)
RETURNS chat_rooms AS $$
DECLARE
    v_room chat_rooms;
BEGIN
    INSERT INTO chat_rooms (title, topic_code, user_id)
    VALUES (p_title, p_topic_code, p_user_id)
    RETURNING * INTO v_room;
    RETURN v_room;
END;
$$ LANGUAGE plpgsql SECURITY INVOKER;

COMMENT ON FUNCTION create_chat_room IS '새로운 채팅방을 생성합니다.';
