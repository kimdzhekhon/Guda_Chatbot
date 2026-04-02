-- 채팅방 삭제 (소유권 검증 포함)
-- Usage: select delete_chat_room('방ID');
CREATE OR REPLACE FUNCTION delete_chat_room(p_chat_room_id UUID)
RETURNS VOID AS $$
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

    DELETE FROM chat_rooms WHERE id = p_chat_room_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;

COMMENT ON FUNCTION delete_chat_room IS '지정한 채팅방을 삭제합니다. (소유권 검증 포함)';
