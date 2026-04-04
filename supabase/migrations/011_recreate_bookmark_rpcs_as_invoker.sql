-- ==========================================
-- 011: 기존 SECURITY DEFINER 북마크 RPC 제거 후 INVOKER로 재생성
-- ==========================================

-- 기존 함수 제거
DROP FUNCTION IF EXISTS get_bookmarks();
DROP FUNCTION IF EXISTS add_bookmark(TEXT, TEXT, TEXT, TEXT, UUID, TEXT);
DROP FUNCTION IF EXISTS remove_bookmark(UUID);
DROP FUNCTION IF EXISTS remove_bookmark_by_reference(TEXT);

-- 기존 테이블 제거 (인덱스, RLS 정책 포함 자동 삭제)
DROP TABLE IF EXISTS public.bookmarks CASCADE;

-- 테이블 재생성
CREATE TABLE public.bookmarks (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES auth.users ON DELETE CASCADE NOT NULL,
    title TEXT NOT NULL,
    content TEXT NOT NULL,
    type TEXT NOT NULL DEFAULT 'message' CHECK (type IN ('message', 'hexagram')),
    reference_id TEXT NOT NULL,
    chat_room_id UUID REFERENCES public.chat_rooms ON DELETE SET NULL,
    topic_code TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE public.bookmarks ENABLE ROW LEVEL SECURITY;

-- RLS 정책
CREATE POLICY "Users can view own bookmarks"
    ON public.bookmarks FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own bookmarks"
    ON public.bookmarks FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete own bookmarks"
    ON public.bookmarks FOR DELETE
    USING (auth.uid() = user_id);

-- 인덱스
CREATE UNIQUE INDEX idx_bookmarks_user_reference
    ON public.bookmarks (user_id, reference_id);

CREATE INDEX idx_bookmarks_user_id
    ON public.bookmarks (user_id, created_at DESC);

-- RPC 함수 (SECURITY INVOKER)
CREATE OR REPLACE FUNCTION get_bookmarks()
RETURNS SETOF bookmarks AS $$
BEGIN
    RETURN QUERY
    SELECT * FROM bookmarks
    WHERE user_id = auth.uid()
    ORDER BY created_at DESC;
END;
$$ LANGUAGE plpgsql SECURITY INVOKER;

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

CREATE OR REPLACE FUNCTION remove_bookmark(p_bookmark_id UUID)
RETURNS void AS $$
BEGIN
    DELETE FROM bookmarks
    WHERE id = p_bookmark_id AND user_id = auth.uid();
END;
$$ LANGUAGE plpgsql SECURITY INVOKER;

CREATE OR REPLACE FUNCTION remove_bookmark_by_reference(p_reference_id TEXT)
RETURNS void AS $$
BEGIN
    DELETE FROM bookmarks
    WHERE reference_id = p_reference_id AND user_id = auth.uid();
END;
$$ LANGUAGE plpgsql SECURITY INVOKER;
