-- 5. 프로필 업서트
-- Usage: select upsert_profile('유저ID', '닉네임', '생일', '페르소나', '약관동의시각');
CREATE OR REPLACE FUNCTION upsert_profile(
    p_user_id UUID,
    p_nickname TEXT,
    p_birth_date TEXT,
    p_persona TEXT,
    p_terms_agreed_at TIMESTAMPTZ
)
RETURNS VOID AS $$
BEGIN
    INSERT INTO profiles (
        id, 
        nickname, 
        birth_date, 
        persona, 
        terms_agreed_at, 
        updated_at
    )
    VALUES (
        p_user_id, 
        p_nickname, 
        p_birth_date, 
        p_persona, 
        p_terms_agreed_at, 
        NOW()
    )
    ON CONFLICT (id) DO UPDATE
    SET nickname = EXCLUDED.nickname,
        birth_date = EXCLUDED.birth_date,
        persona = EXCLUDED.persona,
        terms_agreed_at = EXCLUDED.terms_agreed_at,
        updated_at = NOW();
END;
$$ LANGUAGE plpgsql SECURITY INVOKER;

COMMENT ON FUNCTION upsert_profile IS '사용자 프로필 정보를 생성하거나 갱신합니다.';
