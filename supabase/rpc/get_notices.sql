-- 활성 공지사항 목록 조회
-- Usage: select * from get_notices();
CREATE OR REPLACE FUNCTION public.get_notices()
RETURNS SETOF public.system_config AS $$
BEGIN
    RETURN QUERY
    SELECT * FROM public.system_config
    WHERE notice_title IS NOT NULL
    ORDER BY updated_at DESC;
END;
$$ LANGUAGE plpgsql SECURITY INVOKER;

COMMENT ON FUNCTION get_notices IS '공지사항이 있는 system_config 목록을 반환합니다.';
