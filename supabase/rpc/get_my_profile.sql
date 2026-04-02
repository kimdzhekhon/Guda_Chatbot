-- 내 프로필 정보 조회
-- Usage: select * from get_my_profile();
CREATE OR REPLACE FUNCTION get_my_profile()
RETURNS SETOF profiles AS $$
BEGIN
    RETURN QUERY
    SELECT * FROM profiles
    WHERE id = auth.uid();
END;
$$ LANGUAGE plpgsql SECURITY INVOKER;

COMMENT ON FUNCTION get_my_profile IS '현재 로그인한 사용자의 프로필 정보를 반환합니다. (RLS 보안 준수)';
