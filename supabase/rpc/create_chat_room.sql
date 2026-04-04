-- 새 채팅방 생성 (현재 로그인 유저 대상)
-- Usage: select * from create_chat_room('제목', '토픽코드', 'basic');
CREATE OR REPLACE FUNCTION public.create_chat_room(
    p_title        TEXT,
    p_topic_code   TEXT,
    p_persona_id   public.persona_type,
    p_hexagram_id  INTEGER DEFAULT NULL
)
RETURNS public.chat_rooms AS $$
DECLARE
    v_user_id UUID := auth.uid();
    v_room public.chat_rooms;
BEGIN
    IF v_user_id IS NULL THEN
        RAISE EXCEPTION 'NOT_AUTHENTICATED' USING HINT = '로그인이 필요합니다.';
    END IF;

    -- 입력값 검증
    IF p_title IS NULL OR LENGTH(TRIM(p_title)) = 0 OR LENGTH(p_title) > 255 THEN
        RAISE EXCEPTION 'INVALID_TITLE' USING HINT = '제목은 1~255자여야 합니다.';
    END IF;

    IF p_topic_code IS NULL OR p_topic_code NOT IN ('iching', 'tripitaka') THEN
        RAISE EXCEPTION 'INVALID_TOPIC_CODE' USING HINT = '유효하지 않은 토픽 코드입니다.';
    END IF;

    IF p_hexagram_id IS NOT NULL AND (p_hexagram_id < 1 OR p_hexagram_id > 64) THEN
        RAISE EXCEPTION 'INVALID_HEXAGRAM_ID' USING HINT = '유효한 괘 ID는 1~64입니다.';
    END IF;

    INSERT INTO public.chat_rooms (title, topic_code, user_id, persona_id, hexagram_id)
    VALUES (p_title, p_topic_code, v_user_id, p_persona_id, p_hexagram_id)
    RETURNING * INTO v_room;

    RETURN v_room;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;

COMMENT ON FUNCTION public.create_chat_room(TEXT, TEXT, public.persona_type, INTEGER)
    IS '현재 로그인 사용자의 채팅방을 생성합니다. (SECURITY DEFINER 적용)';
