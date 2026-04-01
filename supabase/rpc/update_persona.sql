-- 6. 페르소나 단일 업데이트
-- Usage: select update_persona('유저ID', 'wise/friendly/strict');
CREATE OR REPLACE FUNCTION update_persona(
    p_user_id UUID,
    p_persona persona_type
)
RETURNS VOID AS $$
BEGIN
    UPDATE profiles
    SET persona = p_persona,
        updated_at = NOW()
    WHERE id = p_user_id;
END;
$$ LANGUAGE plpgsql SECURITY INVOKER;

COMMENT ON FUNCTION update_persona IS '사용자의 페르소나 정보를 단일 업데이트합니다.';
