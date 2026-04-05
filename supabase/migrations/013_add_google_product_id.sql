-- products 테이블에 Google Play 상품 ID 컬럼 추가
ALTER TABLE public.products ADD COLUMN IF NOT EXISTS google_product_id TEXT;

-- Google Play Console에 등록된 상품 ID 매핑
UPDATE public.products SET google_product_id = 'guda_sub_light' WHERE name = 'Guda Light';
UPDATE public.products SET google_product_id = 'guda_sub_pro' WHERE name = 'Guda Pro';
UPDATE public.products SET google_product_id = 'guda_sub_elite' WHERE name = 'Guda Elite';
UPDATE public.products SET google_product_id = 'guda_charge_100' WHERE name = '100회 충전';
UPDATE public.products SET google_product_id = 'guda_charge_200' WHERE name = '200회 충전';
UPDATE public.products SET google_product_id = 'guda_charge_500' WHERE name = '500회 충전';