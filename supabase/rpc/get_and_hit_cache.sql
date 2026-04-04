-- 캐시 조회 + 히트카운트 증가를 단일 쿼리로 수행
-- DB 라운드트립 2회 → 1회 최적화
CREATE OR REPLACE FUNCTION get_and_hit_cache(p_query_hash TEXT)
RETURNS TEXT
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_interpretation TEXT;
BEGIN
  UPDATE i_ching_cache
  SET hit_count = hit_count + 1
  WHERE query_hash = p_query_hash
  RETURNING interpretation INTO v_interpretation;

  RETURN v_interpretation;
END;
$$;

GRANT EXECUTE ON FUNCTION get_and_hit_cache(TEXT) TO service_role;
