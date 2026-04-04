-- 모든 상품 목록 조회
-- Usage: select * from get_products();
CREATE OR REPLACE FUNCTION get_products()
RETURNS SETOF products AS $$
BEGIN
    RETURN QUERY
    SELECT * FROM products
    ORDER BY price ASC;
END;
$$ LANGUAGE plpgsql SECURITY INVOKER;

COMMENT ON FUNCTION get_products IS '모든 상품 목록을 조회합니다. (RLS 보안 및 아키텍처 규칙 준수)';
