-- 현재 로그인한 사용자의 북마크 목록 조회
-- Usage: select * from get_bookmarks();
CREATE OR REPLACE FUNCTION get_bookmarks()
RETURNS SETOF bookmarks AS $$
BEGIN
    RETURN QUERY
    SELECT * FROM bookmarks
    WHERE user_id = auth.uid()
    ORDER BY created_at DESC
    LIMIT 200;
END;
$$ LANGUAGE plpgsql SECURITY INVOKER;

COMMENT ON FUNCTION get_bookmarks IS '현재 로그인한 사용자의 모든 북마크 목록을 반환합니다.';
