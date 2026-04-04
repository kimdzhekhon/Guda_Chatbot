-- 페르소나 단일 업데이트 (현재 로그인 유저 대상)
-- Usage: select update_persona('basic/friendly/strict');
CREATE OR REPLACE FUNCTION update_persona(
    p_persona TEXT
)
RETURNS VOID AS $$
DECLARE
    v_user_id UUID := auth.uid();
BEGIN
    IF v_user_id IS NULL THEN
        RAISE EXCEPTION 'NOT_AUTHENTICATED'
            USING HINT = '로그인이 필요합니다.';
    END IF;

    IF p_persona NOT IN ('basic', 'friendly', 'strict') THEN
        RAISE EXCEPTION 'INVALID_PERSONA'
            USING HINT = '유효하지 않은 페르소나입니다. (basic, friendly, strict)';
    END IF;

    UPDATE profiles
    SET persona = p_persona::persona_type,
        updated_at = NOW()
    WHERE id = v_user_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;

COMMENT ON FUNCTION update_persona IS '현재 로그인한 사용자의 페르소나 정보를 업데이트합니다. (SECURITY DEFINER 적용)';
