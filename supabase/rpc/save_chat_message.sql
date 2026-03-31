-- 4. 메시지 저장 및 상태 업데이트 (Atomic 작업)
-- Usage: select * from save_chat_message('방ID', '내용', 'user/assistant');
CREATE OR REPLACE FUNCTION save_chat_message(
    p_chat_room_id UUID, 
    p_content TEXT, 
    p_sender_role TEXT
)
RETURNS messages AS $$
DECLARE
    v_msg messages;
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

    RETURN v_msg;
END;
$$ LANGUAGE plpgsql SECURITY INVOKER;

COMMENT ON FUNCTION save_chat_message IS '메시지를 저장하고 해당 채팅방의 최신 정보를 갱신합니다.';
