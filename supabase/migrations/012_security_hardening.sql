-- ============================================================
-- 012: Security Hardening Migration
-- 보안 강화 마이그레이션
-- ============================================================

-- 1. i_ching_cache: service_role UPDATE 정책 추가
-- 문제: hit_count 업데이트 시 UPDATE 정책이 없어 실패할 수 있음
DO $$ BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies WHERE policyname = 'i_ching_cache_service_update' AND tablename = 'i_ching_cache'
  ) THEN
    CREATE POLICY "i_ching_cache_service_update" ON i_ching_cache
      FOR UPDATE TO service_role USING (true);
  END IF;
END $$;

-- 2. deleted_accounts: 30일 이전 레코드 정리용 인덱스
CREATE INDEX IF NOT EXISTS idx_deleted_accounts_cleanup
  ON deleted_accounts (deleted_at)
  WHERE deleted_at < NOW() - INTERVAL '30 days';

-- 3. messages: content 길이 제한 추가 (DB 레벨 방어)
DO $$ BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.table_constraints
    WHERE constraint_name = 'chk_messages_content_length' AND table_name = 'messages'
  ) THEN
    ALTER TABLE messages ADD CONSTRAINT chk_messages_content_length CHECK (LENGTH(content) <= 50000);
  END IF;
END $$;

-- 4. chat_rooms: title 길이 제한 (DB 레벨 방어)
DO $$ BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.table_constraints
    WHERE constraint_name = 'chk_chat_rooms_title_length' AND table_name = 'chat_rooms'
  ) THEN
    ALTER TABLE chat_rooms ADD CONSTRAINT chk_chat_rooms_title_length CHECK (LENGTH(title) <= 255);
  END IF;
END $$;

-- 5. bookmarks: title/content 길이 제한
DO $$ BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.table_constraints
    WHERE constraint_name = 'chk_bookmarks_title_length' AND table_name = 'bookmarks'
  ) THEN
    ALTER TABLE bookmarks ADD CONSTRAINT chk_bookmarks_title_length CHECK (LENGTH(title) <= 500);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.table_constraints
    WHERE constraint_name = 'chk_bookmarks_content_length' AND table_name = 'bookmarks'
  ) THEN
    ALTER TABLE bookmarks ADD CONSTRAINT chk_bookmarks_content_length CHECK (LENGTH(content) <= 100000);
  END IF;
END $$;

-- 6. profiles: avatar_url 길이 제한 (SSRF 방지)
DO $$ BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.table_constraints
    WHERE constraint_name = 'chk_profiles_avatar_url_length' AND table_name = 'profiles'
  ) THEN
    ALTER TABLE profiles ADD CONSTRAINT chk_profiles_avatar_url_length CHECK (avatar_url IS NULL OR LENGTH(avatar_url) <= 2048);
  END IF;
END $$;

-- 7. check_deleted_account에 search_path 설정
ALTER FUNCTION check_deleted_account(TEXT) SET search_path = public;
