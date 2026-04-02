-- 6. 페르소나 단일 업데이트
-- Usage: select update_persona('유저ID', 'basic/friendly/strict');
CREATE OR REPLACE FUNCTION update_persona(
    p_user_id UUID,
    p_persona TEXT
)
RETURNS VOID AS $$
BEGIN
    UPDATE profiles
    SET persona = p_persona::persona_type,
        updated_at = NOW()
    WHERE id = p_user_id;
END;
$$ LANGUAGE plpgsql SECURITY INVOKER;

COMMENT ON FUNCTION update_persona IS '사용자의 페르소나 정보를 단일 업데이트합니다. (TEXT 입력을 persona_type으로 캐스팅)';
