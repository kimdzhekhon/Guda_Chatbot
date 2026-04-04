-- ==========================================
-- 프로필 검증 쿼리 (Supabase SQL Editor에서 실행)
-- ==========================================

-- 1. terms_agreed_at이 NULL인 유저 조회
--    → 온보딩 완료했는데 여기 나오면 upsert_profile RPC 문제
SELECT
    p.id,
    p.email,
    p.persona,
    p.terms_agreed_at,
    p.created_at,
    p.updated_at,
    CASE
        WHEN p.terms_agreed_at IS NULL THEN '❌ 미동의'
        ELSE '✅ 동의완료'
    END AS terms_status
FROM profiles p
ORDER BY p.created_at DESC;

-- 2. auth.users는 삭제됐는데 profiles는 남아있는 고아 레코드 조회
--    → 여기 나오면 CASCADE 또는 delete_user_data RPC 문제
SELECT
    p.id,
    p.email,
    p.persona,
    p.terms_agreed_at,
    p.created_at
FROM profiles p
LEFT JOIN auth.users u ON u.id = p.id
WHERE u.id IS NULL;

-- 3. 탈퇴 기록은 있는데 프로필이 남아있는 유저 조회
--    → 탈퇴 처리가 불완전했던 케이스
SELECT
    d.email,
    d.user_id,
    d.deleted_at,
    p.id AS profile_still_exists
FROM deleted_accounts d
INNER JOIN profiles p ON p.id = d.user_id;

-- 4. 고아 프로필 수동 정리 (필요 시 주석 해제 후 실행)
-- DELETE FROM profiles p
-- WHERE NOT EXISTS (
--     SELECT 1 FROM auth.users u WHERE u.id = p.id
-- );
