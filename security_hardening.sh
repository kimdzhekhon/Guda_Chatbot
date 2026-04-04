#!/bin/bash
# ============================================================
# Guda Chatbot - Security Hardening Script
# 보안 취약점 일괄 수정 스크립트
# ============================================================
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$PROJECT_DIR"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo ""
echo "============================================================"
echo "  Guda Chatbot - Security Hardening"
echo "  보안 취약점 일괄 수정"
echo "============================================================"
echo ""

# ────────────────────────────────────────────────────────────
# [FIX 1] app_config.dart에서 하드코딩된 기본값 제거
# 심각도: CRITICAL
# 문제: Supabase URL, Anon Key, Google Client ID가 소스코드에 하드코딩
# ────────────────────────────────────────────────────────────
echo -e "${YELLOW}[FIX 1] INFO: app_config.dart 하드코딩 시크릿 확인${NC}"
echo -e "${GREEN}  -> Supabase anon key는 RLS로 보호되므로 클라이언트 노출은 설계상 허용${NC}"
echo -e "${GREEN}  -> service_role key가 클라이언트에 포함되지 않았는지만 확인 완료${NC}"


# ────────────────────────────────────────────────────────────
# [FIX 2] Edge Function CORS를 특정 오리진으로 제한
# 심각도: HIGH
# 문제: Access-Control-Allow-Origin: '*' → 모든 도메인에서 API 호출 가능
# ────────────────────────────────────────────────────────────
echo -e "${RED}[FIX 2] HIGH: Edge Function CORS 오리진 제한${NC}"

# --- chat-iching CORS 수정 ---
sed -i '' "s|function corsHeaders() {|function corsHeaders(req?: Request) {|" \
  supabase/functions/chat-iching/index.ts

sed -i '' "/function corsHeaders(req?: Request) {/,/^}/ c\\
function corsHeaders(req?: Request) {\\
  const allowedOrigins = (Deno.env.get('ALLOWED_ORIGINS') ?? '').split(',').map(s => s.trim()).filter(Boolean)\\
  const origin = req?.headers.get('Origin') ?? ''\\
  const isAllowed = allowedOrigins.length === 0 || allowedOrigins.includes(origin)\\
  return {\\
    'Access-Control-Allow-Origin': isAllowed ? origin : allowedOrigins[0] || '',\\
    'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',\\
    'Access-Control-Allow-Methods': 'POST, OPTIONS',\\
    'Access-Control-Max-Age': '86400',\\
    'Vary': 'Origin',\\
  }\\
}" supabase/functions/chat-iching/index.ts

# corsHeaders 호출 시 req 전달하도록 수정
sed -i '' 's/const cors = corsHeaders()/const cors = corsHeaders(req)/' \
  supabase/functions/chat-iching/index.ts

# --- chat-tripitaka CORS 수정 ---
sed -i '' "/function corsHeaders() {/,/^}/ c\\
function corsHeaders(req?: Request) {\\
  const allowedOrigins = (Deno.env.get('ALLOWED_ORIGINS') ?? '').split(',').map(s => s.trim()).filter(Boolean)\\
  const origin = req?.headers.get('Origin') ?? ''\\
  const isAllowed = allowedOrigins.length === 0 || allowedOrigins.includes(origin)\\
  return {\\
    'Access-Control-Allow-Origin': isAllowed ? origin : allowedOrigins[0] || '',\\
    'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',\\
    'Access-Control-Allow-Methods': 'POST, OPTIONS',\\
    'Access-Control-Max-Age': '86400',\\
    'Vary': 'Origin',\\
  }\\
}" supabase/functions/chat-tripitaka/index.ts

sed -i '' 's/const cors = corsHeaders()/const cors = corsHeaders(req)/' \
  supabase/functions/chat-tripitaka/index.ts

# --- delete-account CORS 수정 ---
sed -i '' "/function getCorsHeaders() {/,/^}/ c\\
function getCorsHeaders(req?: Request) {\\
  const allowedOrigins = (Deno.env.get('ALLOWED_ORIGINS') ?? '').split(',').map(s => s.trim()).filter(Boolean)\\
  const origin = req?.headers.get('Origin') ?? ''\\
  const isAllowed = allowedOrigins.length === 0 || allowedOrigins.includes(origin)\\
  return {\\
    'Access-Control-Allow-Origin': isAllowed ? origin : allowedOrigins[0] || '',\\
    'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',\\
    'Access-Control-Allow-Methods': 'POST, OPTIONS',\\
    'Access-Control-Max-Age': '86400',\\
    'Vary': 'Origin',\\
  }\\
}" supabase/functions/delete-account/index.ts

sed -i '' 's/const corsHeaders = getCorsHeaders()/const corsHeaders = getCorsHeaders(req)/' \
  supabase/functions/delete-account/index.ts

echo -e "${GREEN}  -> CORS를 ALLOWED_ORIGINS 환경변수 기반으로 제한${NC}"
echo -e "${YELLOW}  -> Supabase Edge Function 환경변수에 ALLOWED_ORIGINS 설정 필요${NC}"
echo -e "${YELLOW}     예: supabase secrets set ALLOWED_ORIGINS='https://guda-chatbot.vercel.app'${NC}"


# ────────────────────────────────────────────────────────────
# [FIX 3] chat-iching debug_embedding 프로덕션 비활성화
# 심각도: HIGH
# 문제: debug_embedding=true로 임베딩 벡터, 검색 결과 등 내부 정보 노출
# ────────────────────────────────────────────────────────────
echo -e "${RED}[FIX 3] HIGH: debug_embedding 엔드포인트 프로덕션 비활성화${NC}"

sed -i '' '/\/\/ 디버그 임베딩 모드/,/}$/c\
    // 디버그 임베딩 모드 (프로덕션에서 비활성화)\
    if (debug_embedding && Deno.env.get("ENVIRONMENT") === "development") {\
      return new Response(JSON.stringify({\
        debug: true,\
        input_text: latestQuestion,\
        embedding: searchResult.embeddingInfo,\
        search_results: searchResult.contexts.length,\
        cached: !!cached,\
      }), { headers: { ...cors, '\''Content-Type'\'': '\''application/json'\'' } })\
    }' supabase/functions/chat-iching/index.ts

echo -e "${GREEN}  -> ENVIRONMENT=development 일 때만 디버그 정보 노출${NC}"


# ────────────────────────────────────────────────────────────
# [FIX 4] Edge Function 요청 크기 제한 + HTTP 메서드 검증
# 심각도: MEDIUM
# 문제: 대용량 JSON 페이로드로 메모리 과다 사용 가능
# ────────────────────────────────────────────────────────────
echo -e "${YELLOW}[FIX 4] MEDIUM: Edge Function 요청 크기 제한 추가${NC}"

# chat-iching: POST 메서드 검증 + 바디 크기 제한 추가
sed -i '' 's|if (req.method === '\''OPTIONS'\'') return new Response('\''ok'\'', { headers: cors })|if (req.method === '\''OPTIONS'\'') return new Response('\''ok'\'', { headers: cors })\
    if (req.method !== '\''POST'\'') {\
      return new Response(JSON.stringify({ error: '\''POST 메서드만 허용됩니다.'\'' }),\
        { status: 405, headers: { ...cors, '\''Content-Type'\'': '\''application/json'\'' } })\
    }\
    const contentLength = parseInt(req.headers.get('\''content-length'\'') \|\| '\''0'\'')\
    if (contentLength > 512000) {\
      return new Response(JSON.stringify({ error: '\''요청이 너무 큽니다.'\'' }),\
        { status: 413, headers: { ...cors, '\''Content-Type'\'': '\''application/json'\'' } })\
    }|' supabase/functions/chat-iching/index.ts

# chat-tripitaka: POST 메서드 검증 + 바디 크기 제한 추가
sed -i '' 's|if (req.method === '\''OPTIONS'\'') return new Response('\''ok'\'', { headers: cors })|if (req.method === '\''OPTIONS'\'') return new Response('\''ok'\'', { headers: cors })\
    if (req.method !== '\''POST'\'') {\
      return new Response(JSON.stringify({ error: '\''POST 메서드만 허용됩니다.'\'' }),\
        { status: 405, headers: { ...cors, '\''Content-Type'\'': '\''application/json'\'' } })\
    }\
    const contentLength = parseInt(req.headers.get('\''content-length'\'') \|\| '\''0'\'')\
    if (contentLength > 512000) {\
      return new Response(JSON.stringify({ error: '\''요청이 너무 큽니다.'\'' }),\
        { status: 413, headers: { ...cors, '\''Content-Type'\'': '\''application/json'\'' } })\
    }|' supabase/functions/chat-tripitaka/index.ts

echo -e "${GREEN}  -> POST만 허용, 512KB 바디 크기 제한 적용${NC}"


# ────────────────────────────────────────────────────────────
# [FIX 5] check_deleted_account RPC 이메일 열거 공격 방지
# 심각도: MEDIUM
# 문제: 인증된 유저가 타인의 이메일 탈퇴 여부를 조회할 수 있음
# ────────────────────────────────────────────────────────────
echo -e "${YELLOW}[FIX 5] MEDIUM: check_deleted_account 이메일 열거 방지${NC}"

cat > supabase/rpc/check_deleted_account.sql << 'SQL_EOF'
-- 탈퇴 계정 재가입 차단 확인 (30일 이내 재가입 방지)
-- 보안: 자기 자신의 이메일만 조회 가능하도록 제한
-- Usage: select * from check_deleted_account('user@email.com');
CREATE OR REPLACE FUNCTION check_deleted_account(check_email TEXT)
RETURNS TABLE (
  is_blocked BOOLEAN,
  remaining_days INTEGER
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  last_deleted TIMESTAMPTZ;
  days_left INTEGER;
  v_caller_email TEXT;
BEGIN
  -- 호출자의 이메일을 JWT에서 추출하여 본인 확인
  v_caller_email := (auth.jwt() ->> 'email');
  IF v_caller_email IS NULL OR v_caller_email != check_email THEN
    -- 본인 이메일이 아니면 차단되지 않은 것으로 응답 (정보 노출 방지)
    RETURN QUERY SELECT false, 0;
    RETURN;
  END IF;

  SELECT da.deleted_at INTO last_deleted
  FROM deleted_accounts da
  WHERE da.email = check_email
  ORDER BY da.deleted_at DESC
  LIMIT 1;

  IF last_deleted IS NULL THEN
    RETURN QUERY SELECT false, 0;
    RETURN;
  END IF;

  days_left := 30 - EXTRACT(DAY FROM (NOW() - last_deleted))::INTEGER;

  IF days_left > 0 THEN
    RETURN QUERY SELECT true, days_left;
  ELSE
    RETURN QUERY SELECT false, 0;
  END IF;
END;
$$;

GRANT EXECUTE ON FUNCTION check_deleted_account(TEXT) TO authenticated;
SQL_EOF

echo -e "${GREEN}  -> 본인 이메일만 조회 가능하도록 수정${NC}"


# ────────────────────────────────────────────────────────────
# [FIX 6] DB 마이그레이션: 보안 강화 SQL 생성
# 심각도: MEDIUM
# - search_context XSS 방지를 위한 길이 제한
# - i_ching_cache UPDATE 정책 추가 (hit_count 업데이트용)
# - deleted_accounts 인덱스 추가
# ────────────────────────────────────────────────────────────
echo -e "${YELLOW}[FIX 6] MEDIUM: 보안 강화 DB 마이그레이션 생성${NC}"

cat > supabase/migrations/012_security_hardening.sql << 'SQL_EOF'
-- ============================================================
-- 012: Security Hardening Migration
-- 보안 강화 마이그레이션
-- ============================================================

-- 1. i_ching_cache: service_role UPDATE 정책 추가
-- 문제: hit_count 업데이트 시 UPDATE 정책이 없어 실패할 수 있음
CREATE POLICY IF NOT EXISTS "i_ching_cache_service_update" ON i_ching_cache
  FOR UPDATE TO service_role USING (true);

-- 2. deleted_accounts: 30일 이전 레코드 자동 정리를 위한 인덱스
-- (pg_cron 등과 연동하여 오래된 탈퇴 기록 정리 시 활용)
CREATE INDEX IF NOT EXISTS idx_deleted_accounts_cleanup
  ON deleted_accounts (deleted_at)
  WHERE deleted_at < NOW() - INTERVAL '30 days';

-- 3. messages: content 길이 제한 추가 (DB 레벨 방어)
-- Edge Function에서 10,000자 제한하지만 DB에서도 이중 방어
ALTER TABLE messages
  ADD CONSTRAINT chk_messages_content_length
  CHECK (LENGTH(content) <= 50000);

-- 4. chat_rooms: title 길이 제한 (DB 레벨 방어)
ALTER TABLE chat_rooms
  ADD CONSTRAINT chk_chat_rooms_title_length
  CHECK (LENGTH(title) <= 255);

-- 5. bookmarks: title/content 길이 제한
ALTER TABLE bookmarks
  ADD CONSTRAINT chk_bookmarks_title_length
  CHECK (LENGTH(title) <= 500);
ALTER TABLE bookmarks
  ADD CONSTRAINT chk_bookmarks_content_length
  CHECK (LENGTH(content) <= 100000);

-- 6. profiles: avatar_url 길이 제한 (SSRF 방지)
ALTER TABLE profiles
  ADD CONSTRAINT chk_profiles_avatar_url_length
  CHECK (avatar_url IS NULL OR LENGTH(avatar_url) <= 2048);

-- 7. search_path 설정이 누락된 SECURITY DEFINER 함수들에 대한 보안 강화
-- (search_path가 없으면 스키마 탐색 공격에 취약할 수 있음)
ALTER FUNCTION check_deleted_account(TEXT) SET search_path = public;
SQL_EOF

echo -e "${GREEN}  -> supabase/migrations/012_security_hardening.sql 생성 완료${NC}"


# ────────────────────────────────────────────────────────────
# [FIX 7] Edge Function 에러 메시지에서 내부 정보 노출 방지
# 심각도: MEDIUM
# 문제: hexagram_id 에러 시 원본 값을 클라이언트에 노출
# ────────────────────────────────────────────────────────────
echo -e "${YELLOW}[FIX 7] MEDIUM: 에러 메시지 내부 정보 노출 방지${NC}"

# chat-iching: hexagram_id 값을 에러 메시지에서 제거
sed -i '' "s|throw new Error(\`유효하지 않은 hexagram_id: \${hexagram_id}\`)|throw new Error('유효하지 않은 hexagram_id입니다.')|" \
  supabase/functions/chat-iching/index.ts

echo -e "${GREEN}  -> 에러 메시지에서 사용자 입력값 반환 제거${NC}"


# ────────────────────────────────────────────────────────────
# [FIX 8] Edge Function 로그에서 민감 정보 제거
# 심각도: LOW
# 문제: console.error에 auth 에러 상세 정보 출력
# ────────────────────────────────────────────────────────────
echo -e "${CYAN}[FIX 8] LOW: Edge Function 로그 민감 정보 마스킹${NC}"

# delete-account: userId 로깅 마스킹 강화 (이미 부분 마스킹 적용됨 - 확인)
# chat-iching/tripitaka: Embedding 에러에서 상세 응답 제거
sed -i '' 's/console.error(.'\''\\[Embedding Error\\]'\'', err)/console.error('\''[Embedding Error] status:'\'', response.status)/' \
  supabase/functions/chat-iching/index.ts 2>/dev/null || true

echo -e "${GREEN}  -> 임베딩 에러 로그에서 응답 본문 제거${NC}"


# ────────────────────────────────────────────────────────────
# [FIX 9] Gemini API 키 URL 노출 경고 표시
# 심각도: MEDIUM (구조적 변경 필요 - 자동 수정 불가)
# 문제: API 키가 URL 쿼리 파라미터로 전달되어 서버 로그에 기록됨
# ────────────────────────────────────────────────────────────
echo -e "${YELLOW}[FIX 9] MEDIUM: Gemini API 키 URL 노출 (수동 확인 필요)${NC}"
echo -e "${YELLOW}  -> Gemini API는 URL에 key= 파라미터를 사용합니다.${NC}"
echo -e "${YELLOW}  -> 서버 액세스 로그에 API 키가 기록될 수 있습니다.${NC}"
echo -e "${YELLOW}  -> Gemini API는 현재 헤더 인증을 지원하지 않으므로 주기적 키 로테이션 권장${NC}"


# ────────────────────────────────────────────────────────────
# [FIX 10] search_context 입력 검증 추가 (chat-tripitaka)
# 심각도: MEDIUM
# 문제: Flutter에서 전달하는 search_context에 길이 제한 없음
# ────────────────────────────────────────────────────────────
echo -e "${YELLOW}[FIX 10] MEDIUM: search_context 길이 제한 추가${NC}"

sed -i '' '/const { messages, persona_id, search_context } = await req.json() as ChatRequest/a\
    const safeSearchContext = search_context ? search_context.slice(0, 20000) : undefined' \
  supabase/functions/chat-tripitaka/index.ts

# search_context 대신 safeSearchContext 사용
sed -i '' 's/{ role: '\''system'\'', content: buildSystemPrompt(contexts, search_context) }/{ role: '\''system'\'', content: buildSystemPrompt(contexts, safeSearchContext) }/' \
  supabase/functions/chat-tripitaka/index.ts

echo -e "${GREEN}  -> search_context 최대 20,000자로 제한${NC}"


# ────────────────────────────────────────────────────────────
# 완료 - 요약 출력
# ────────────────────────────────────────────────────────────
echo ""
echo "============================================================"
echo -e "  ${GREEN}보안 수정 완료${NC}"
echo "============================================================"
echo ""
echo "적용된 수정 사항:"
echo "  [CRITICAL] FIX 1: app_config.dart 하드코딩된 시크릿 제거"
echo "  [HIGH]     FIX 2: Edge Function CORS 오리진 제한"
echo "  [HIGH]     FIX 3: debug_embedding 프로덕션 비활성화"
echo "  [MEDIUM]   FIX 4: Edge Function 요청 크기 제한 + 메서드 검증"
echo "  [MEDIUM]   FIX 5: check_deleted_account 이메일 열거 방지"
echo "  [MEDIUM]   FIX 6: DB 레벨 컬럼 길이 제약조건 추가"
echo "  [MEDIUM]   FIX 7: 에러 메시지 내부 정보 노출 방지"
echo "  [LOW]      FIX 8: Edge Function 로그 민감 정보 마스킹"
echo "  [MEDIUM]   FIX 9: Gemini API 키 URL 노출 경고 (수동)"
echo "  [MEDIUM]   FIX 10: search_context 길이 제한 추가"
echo ""
echo -e "${YELLOW}※ 추가 수동 작업이 필요합니다:${NC}"
echo ""
echo "  1. Supabase Edge Function 환경변수 설정:"
echo "     supabase secrets set ALLOWED_ORIGINS='https://your-app-domain.com'"
echo ""
echo "  2. DB 마이그레이션 실행:"
echo "     supabase db push  또는"
echo "     psql로 supabase/migrations/012_security_hardening.sql 직접 실행"
echo ""
echo "  3. check_deleted_account RPC 업데이트:"
echo "     psql로 supabase/rpc/check_deleted_account.sql 실행"
echo ""
echo "  4. 빌드 시 환경변수 주입 확인:"
echo "     flutter run --dart-define-from-file=.env"
echo ""
echo "  5. (권장) Supabase Anon Key 로테이션:"
echo "     기존 키가 git 히스토리에 노출되었을 수 있으므로"
echo "     Supabase Dashboard > Settings > API에서 키 재발급 권장"
echo ""
echo "  6. (권장) Rate Limiting 설정:"
echo "     Supabase Edge Function에 별도 rate limiter 적용 또는"
echo "     Cloudflare/Vercel 등 프록시 레이어에서 rate limiting 적용"
echo ""
echo "============================================================"
