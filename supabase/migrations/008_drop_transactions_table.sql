-- 레거시 transactions 테이블 제거
-- transaction_logs 테이블이 트리거로 자동 기록하므로 중복 테이블 삭제
DROP TABLE IF EXISTS public.transactions CASCADE;
