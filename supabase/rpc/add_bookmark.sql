-- 북마크 추가 (중복 시 기존 북마크 반환)
-- Usage: select * from add_bookmark('제목', '내용', 'message', 'ref-123', null, 'tripitaka');
CREATE OR REPLACE FUNCTION add_bookmark(
    p_title TEXT,
    p_content TEXT,
    p_type TEXT,
    p_reference_id TEXT,
    p_chat_room_id UUID DEFAULT NULL,
    p_topic_code TEXT DEFAULT NULL
)
RETURNS bookmarks AS $$
DECLARE
    v_result bookmarks;
BEGIN
    INSERT INTO bookmarks (user_id, title, content, type, reference_id, chat_room_id, topic_code)
    VALUES (auth.uid(), p_title, p_content, p_type, p_reference_id, p_chat_room_id, p_topic_code)
    ON CONFLICT (user_id, reference_id) DO NOTHING
    RETURNING * INTO v_result;

    IF v_result IS NULL THEN
        SELECT * INTO v_result FROM bookmarks
        WHERE user_id = auth.uid() AND reference_id = p_reference_id;
    END IF;

    RETURN v_result;
END;
$$ LANGUAGE plpgsql SECURITY INVOKER;

COMMENT ON FUNCTION add_bookmark IS '북마크를 추가합니다. 이미 존재하면 기존 북마크를 반환합니다.';
