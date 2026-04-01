-- ============================================================
-- 007: RAG 파이프라인용 문서 테이블 및 검색 함수 생성
-- 기존 zhouyi 스키마 기준으로 i_ching 테이블 생성
-- ============================================================

-- ============================================================
-- 0. 신규 테이블 초기화 (재실행 안전)
-- ============================================================
DROP TABLE IF EXISTS i_ching_cache CASCADE;
DROP TABLE IF EXISTS i_ching_documents CASCADE;
DROP TABLE IF EXISTS tripitaka_documents CASCADE;

DROP FUNCTION IF EXISTS match_i_ching_documents(vector(768), FLOAT, INT);
DROP FUNCTION IF EXISTS search_i_ching_by_keyword(TEXT, INT);
DROP FUNCTION IF EXISTS search_tripitaka_documents(TEXT, INT);
DROP FUNCTION IF EXISTS match_zhouyi_documents(vector(768), FLOAT, INT);

-- ============================================================
-- 1. pgvector 확장 활성화
-- ============================================================
CREATE EXTENSION IF NOT EXISTS vector;

-- ============================================================
-- 2. 주역(I Ching) 문서 테이블
--    기존 zhouyi_embeddings 스키마 기준
-- ============================================================
CREATE TABLE i_ching_documents (
  id SERIAL PRIMARY KEY,
  content TEXT NOT NULL,
  metadata JSONB,
  embedding vector(768),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ivfflat 인덱스는 데이터가 있어야 생성 가능 → 데이터 시딩 후 수동 실행:
-- CREATE INDEX idx_i_ching_embedding
--   ON i_ching_documents USING ivfflat (embedding vector_cosine_ops)
--   WITH (lists = 100);

CREATE INDEX idx_i_ching_content_gin
  ON i_ching_documents USING gin (to_tsvector('simple', content));

-- ============================================================
-- 3. 팔만대장경 + 구사론 문서 테이블
-- ============================================================
CREATE TABLE tripitaka_documents (
  id BIGSERIAL PRIMARY KEY,
  content TEXT NOT NULL,
  source TEXT,               -- 'tripitaka' 또는 'guda' (구사론)
  source_lang TEXT DEFAULT 'ko',
  metadata JSONB DEFAULT '{}',
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_tripitaka_source
  ON tripitaka_documents (source);

CREATE INDEX idx_tripitaka_lang
  ON tripitaka_documents (source_lang);

CREATE INDEX idx_tripitaka_content_gin
  ON tripitaka_documents USING gin (to_tsvector('simple', content));

-- ============================================================
-- 4. 주역 응답 캐시 테이블
--    기존 zhouyi_cache 스키마 기준
-- ============================================================
CREATE TABLE i_ching_cache (
  id SERIAL PRIMARY KEY,
  hexagram_number INTEGER NOT NULL,
  line_number INTEGER,
  query_hash VARCHAR(64) NOT NULL,
  interpretation TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  hit_count INTEGER DEFAULT 0,
  UNIQUE(query_hash)
);

-- ============================================================
-- 5. 벡터 유사도 검색 함수 (주역)
-- ============================================================
CREATE OR REPLACE FUNCTION match_i_ching_documents(
  query_embedding vector,
  match_threshold FLOAT DEFAULT 0.3,
  match_count INT DEFAULT 10
)
RETURNS TABLE (
  id INT,
  content TEXT,
  metadata JSONB,
  similarity FLOAT
)
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY
  SELECT
    d.id,
    d.content,
    d.metadata,
    (1 - (d.embedding <=> query_embedding))::FLOAT AS similarity
  FROM i_ching_documents d
  WHERE 1 - (d.embedding <=> query_embedding) > match_threshold
  ORDER BY d.embedding <=> query_embedding
  LIMIT match_count;
END;
$$;

-- ============================================================
-- 6. 키워드 검색 함수 (주역 폴백용)
-- ============================================================
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

-- ============================================================
-- 7. 키워드 검색 함수 (팔만대장경 + 구사론)
--    다국어 가중치: ko=5, zh=2, en=2, sa=1
-- ============================================================
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

-- ============================================================
-- 8. RLS 정책
-- ============================================================
ALTER TABLE i_ching_documents ENABLE ROW LEVEL SECURITY;
ALTER TABLE tripitaka_documents ENABLE ROW LEVEL SECURITY;
ALTER TABLE i_ching_cache ENABLE ROW LEVEL SECURITY;

CREATE POLICY "i_ching_documents_select" ON i_ching_documents
  FOR SELECT TO authenticated USING (true);

CREATE POLICY "tripitaka_documents_select" ON tripitaka_documents
  FOR SELECT TO authenticated USING (true);

CREATE POLICY "i_ching_cache_service_select" ON i_ching_cache
  FOR SELECT TO service_role USING (true);

CREATE POLICY "i_ching_cache_service_insert" ON i_ching_cache
  FOR INSERT TO service_role WITH CHECK (true);

-- ============================================================
-- 9. 기존 zhouyi 테이블에서 데이터 마이그레이션
-- ============================================================
DO $$
BEGIN
  -- zhouyi_embeddings → i_ching_documents
  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'zhouyi_embeddings') THEN
    INSERT INTO i_ching_documents (content, metadata, embedding, created_at)
    SELECT content, metadata, embedding, created_at
    FROM zhouyi_embeddings;
    RAISE NOTICE 'zhouyi_embeddings → i_ching_documents 마이그레이션 완료';
  END IF;

  -- zhouyi_cache → i_ching_cache
  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'zhouyi_cache') THEN
    INSERT INTO i_ching_cache (hexagram_number, line_number, query_hash, interpretation, created_at, hit_count)
    SELECT hexagram_number, line_number, query_hash, interpretation, created_at, hit_count
    FROM zhouyi_cache;
    RAISE NOTICE 'zhouyi_cache → i_ching_cache 마이그레이션 완료';
  END IF;
END $$;

-- 9-3. 기존 테이블 제거
DROP TABLE IF EXISTS zhouyi_cache CASCADE;
DROP TABLE IF EXISTS zhouyi_embeddings CASCADE;
