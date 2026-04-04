-- 팔만대장경 + 구사론 키워드 검색 (다국어 가중치 적용)
-- 가중치: ko=5, zh=2, en=2, sa=1
-- Usage: select * from search_tripitaka_documents('반야심경', 10);
CREATE OR REPLACE FUNCTION search_tripitaka_documents(
  query_text TEXT,
  match_count INT DEFAULT 10
)
RETURNS TABLE (
  id BIGINT,
  content TEXT,
  source TEXT,
  source_lang TEXT,
  metadata JSONB,
  weighted_rank FLOAT
)
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY
  SELECT
    td.id,
    td.content,
    td.source,
    td.source_lang,
    td.metadata,
    (
      ts_rank(to_tsvector('simple', td.content), plainto_tsquery('simple', query_text))
      * CASE td.source_lang
          WHEN 'ko' THEN 5.0
          WHEN 'zh' THEN 2.0
          WHEN 'en' THEN 2.0
          WHEN 'sa' THEN 1.0
          ELSE 1.0
        END
    )::FLOAT AS weighted_rank
  FROM tripitaka_documents td
  WHERE to_tsvector('simple', td.content) @@ plainto_tsquery('simple', query_text)
  ORDER BY weighted_rank DESC
  LIMIT match_count;
END;
$$;
