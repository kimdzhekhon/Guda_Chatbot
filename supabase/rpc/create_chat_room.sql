-- 새 채팅방 생성
-- Usage: select * from create_chat_room('제목', '토픽코드', '유저UUID', 'basic');

-- 이전 파라미터(TEXT 4개)와의 오버로딩 중복을 피하기 위해 제거
DROP FUNCTION IF EXISTS public.create_chat_room(TEXT, TEXT, UUID);
DROP FUNCTION IF EXISTS public.create_chat_room(TEXT, TEXT, UUID, TEXT);

CREATE OR REPLACE FUNCTION public.create_chat_room(
    p_title      TEXT,
    p_topic_code TEXT,
    p_user_id    UUID,
    p_persona_id public.persona_type
)
RETURNS public.chat_rooms AS $$
DECLARE
    v_room public.chat_rooms;
BEGIN
    INSERT INTO public.chat_rooms (title, topic_code, user_id, persona_id)
    VALUES (p_title, p_topic_code, p_user_id, p_persona_id)
    RETURNING * INTO v_room;
    RETURN v_room;
END;
$$ LANGUAGE plpgsql SECURITY INVOKER;

COMMENT ON FUNCTION public.create_chat_room(TEXT, TEXT, UUID, public.persona_type)
    IS '채팅방을 생성합니다. persona_id는 persona_type ENUM 값(basic/friendly/strict)을 사용합니다.';
