-- 북마크 삭제 (ID로)
-- Usage: select remove_bookmark('uuid-here');
CREATE OR REPLACE FUNCTION remove_bookmark(p_bookmark_id UUID)
RETURNS void AS $$
BEGIN
    DELETE FROM bookmarks
    WHERE id = p_bookmark_id AND user_id = auth.uid();
END;
$$ LANGUAGE plpgsql SECURITY INVOKER;

COMMENT ON FUNCTION remove_bookmark IS 'ID로 북마크를 삭제합니다.';

-- 북마크 삭제 (reference_id로)
-- Usage: select remove_bookmark_by_reference('ref-123');
CREATE OR REPLACE FUNCTION remove_bookmark_by_reference(p_reference_id TEXT)
RETURNS void AS $$
BEGIN
    DELETE FROM bookmarks
    WHERE reference_id = p_reference_id AND user_id = auth.uid();
END;
$$ LANGUAGE plpgsql SECURITY INVOKER;

COMMENT ON FUNCTION remove_bookmark_by_reference IS 'reference_id로 북마크를 삭제합니다.';
