-- 주역 키워드 검색 (벡터 검색 폴백용)
-- Usage: select * from search_i_ching_by_keyword('건괘', 10);
CREATE OR REPLACE FUNCTION search_i_ching_by_keyword(
  query_text TEXT,
  match_count INT DEFAULT 10
)
RETURNS TABLE (
  id INT,
  content TEXT,
  metadata JSONB,
  rank FLOAT
)
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY
  SELECT
    d.id,
    d.content,
    d.metadata,
    ts_rank(to_tsvector('simple', d.content), plainto_tsquery('simple', query_text))::FLOAT AS rank
  FROM i_ching_documents d
  WHERE to_tsvector('simple', d.content) @@ plainto_tsquery('simple', query_text)
  ORDER BY rank DESC
  LIMIT match_count;
END;
$$;
