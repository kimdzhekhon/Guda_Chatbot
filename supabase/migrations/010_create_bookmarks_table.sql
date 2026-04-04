-- ==========================================
-- 010: Bookmarks (메시지 보관) 테이블 생성
-- ==========================================

CREATE TABLE IF NOT EXISTS public.bookmarks (
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

-- RLS 정책: 본인 데이터만 접근
CREATE POLICY "Users can view own bookmarks"
    ON public.bookmarks FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own bookmarks"
    ON public.bookmarks FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete own bookmarks"
    ON public.bookmarks FOR DELETE
    USING (auth.uid() = user_id);

-- 중복 북마크 방지 (같은 유저가 같은 reference_id를 두 번 저장 불가)
CREATE UNIQUE INDEX IF NOT EXISTS idx_bookmarks_user_reference
    ON public.bookmarks (user_id, reference_id);

-- 조회 성능을 위한 인덱스
CREATE INDEX IF NOT EXISTS idx_bookmarks_user_id
    ON public.bookmarks (user_id, created_at DESC);

-- RPC 함수는 supabase/rpc/ 디렉토리 참조:
-- get_bookmarks.sql, add_bookmark.sql, remove_bookmark.sql
