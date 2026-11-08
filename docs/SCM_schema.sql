-- Reference schema. Seeded template: dist/data/empty.db.gz
PRAGMA application_id=1396919620;

CREATE TABLE analysis_settings(name TEXT PRIMARY KEY, value REAL NOT NULL CHECK(value>0));

CREATE TABLE column_dictionary(
      source_kind TEXT NOT NULL, table_name TEXT NOT NULL, ordinal INTEGER NOT NULL,
      original_name TEXT NOT NULL, database_column TEXT NOT NULL, sql_type TEXT NOT NULL,
      is_unused INTEGER NOT NULL, PRIMARY KEY(source_kind,ordinal), UNIQUE(table_name,database_column));

CREATE TABLE data_issues(
      issue_id INTEGER PRIMARY KEY, source_file_id INTEGER NOT NULL, source_row_number INTEGER,
      column_name TEXT, issue_type TEXT NOT NULL, original_value TEXT,
      FOREIGN KEY(source_file_id) REFERENCES source_files(source_file_id));

CREATE TABLE dim_date(
      snapshot_date TEXT PRIMARY KEY, year INTEGER NOT NULL, month INTEGER NOT NULL,
      day INTEGER NOT NULL, weekday INTEGER NOT NULL, is_weekend INTEGER NOT NULL);

CREATE TABLE dim_product(
      offline_product_id TEXT PRIMARY KEY, logistics_product_id TEXT, product_name TEXT,
      first_seen_date TEXT NOT NULL, last_seen_date TEXT NOT NULL);

CREATE TABLE ingestion_runs(
      run_id INTEGER PRIMARY KEY, started_at TEXT NOT NULL, finished_at TEXT, source_root TEXT NOT NULL,
      status TEXT NOT NULL, imported_files INTEGER NOT NULL DEFAULT 0,
      skipped_files INTEGER NOT NULL DEFAULT 0, imported_rows INTEGER NOT NULL DEFAULT 0, error_message TEXT);

CREATE TABLE "inventory_daily"(
          snapshot_date TEXT NOT NULL, source_file_id INTEGER NOT NULL, source_row_number INTEGER NOT NULL,
          "순번" INTEGER, "센터명" TEXT, "물류상품ID" TEXT, "상품명" TEXT, "총재고" INTEGER, "입하대기재고" INTEGER, "불량재고" INTEGER, "사용X" TEXT, "사용X__2" TEXT, "연동상품상태" TEXT, "사용X__3" TEXT, "판매가능수량" INTEGER, "판매가능수량(쓱1DAY)" INTEGER, "출하예정량" INTEGER, "출하예정량(D-0)" INTEGER, "출하예정량(D-1)" INTEGER, "출하예정량(D-2)" INTEGER, "출하예정량(D-3)" INTEGER, "출하예정량(쓱1DAY)" INTEGER, "입하예정수량" INTEGER, "SSG 재고일수 (14일 기준)" REAL, "DW 일평균 판매량 (14일 기준)" REAL, "SSG 재고일수 (85일 기준)" REAL, "DW 일평균 판매량 (85일 기준)" REAL, "사용X__4" TEXT, "사용X__5" TEXT, "판매가" INTEGER, "사용X__6" TEXT, "그룹물류상품ID" TEXT, "오프라인상품번호" TEXT, "연동상품ID" TEXT, "연동상품옵션ID" TEXT, "상품바코드" TEXT, "판매자명(ID)" TEXT, "물류서비스유형(상세)" TEXT, "연동공급업체명" TEXT, "사용X__7" TEXT, "사용X__8" TEXT, "물류분류" TEXT, "사용X__9" TEXT, "유통기한관리여부" TEXT, "유통기한표시형식" TEXT, "유통기한일수" INTEGER, "물류운영카테고리대분류" TEXT, "물류운영카테고리중분류" TEXT, "물류운영카테고리소분류" TEXT, PRIMARY KEY(source_file_id,source_row_number),
          FOREIGN KEY(source_file_id,source_row_number) REFERENCES raw_rows(source_file_id,source_row_number),
          FOREIGN KEY(snapshot_date) REFERENCES dim_date(snapshot_date),
          FOREIGN KEY("오프라인상품번호") REFERENCES dim_product(offline_product_id));

CREATE TABLE "location_inventory_daily"(
          snapshot_date TEXT NOT NULL, source_file_id INTEGER NOT NULL, source_row_number INTEGER NOT NULL,
          "물류상품ID" TEXT, "물류상품명" TEXT, "물류분류" TEXT, "사용X" TEXT, "사용X__2" TEXT, "유통기한잔여일수" INTEGER, "사용X__3" TEXT, "BOX입수" INTEGER, "사용X__4" TEXT, "존별 총재고" INTEGER, "존별 BOX수" INTEGER, "존별 PCS수" INTEGER, "위치재고" INTEGER, "창고" TEXT, "층" TEXT, "존" TEXT, "작업구역" TEXT, "보관위치(셀)" TEXT, "보관용기ID" TEXT, "보관용기유형" TEXT, "제조일자" TEXT, "유통기한" TEXT, "유통기한관리" TEXT, "전표번호" TEXT, "최초재고생성일자" TEXT, "출고금지여부(1P)" TEXT, "프론트재고만료여부" TEXT, "상품바코드" TEXT, "박스바코드" TEXT, "오프라인상품ID" TEXT, "판매자ID" TEXT, "물류서비스유형(상세)" TEXT, "운영카테고리대분류명" TEXT, "운영카테고리중분류명" TEXT, "운영카테고리소분류명" TEXT, "사은품구분" TEXT, "유통기한관리여부" TEXT, "사용X__5" TEXT, "재고확인필요여부" TEXT, "이동가능여부" TEXT, "특행미발주여부" TEXT, "샐비지상품여부" TEXT, "신선구분" TEXT, "필수속성입력여부" TEXT, "입수확인필요여부" TEXT, "센터체적입력여부" TEXT, "영업등급" TEXT, PRIMARY KEY(source_file_id,source_row_number),
          FOREIGN KEY(source_file_id,source_row_number) REFERENCES raw_rows(source_file_id,source_row_number),
          FOREIGN KEY(snapshot_date) REFERENCES dim_date(snapshot_date),
          FOREIGN KEY("오프라인상품ID") REFERENCES dim_product(offline_product_id));

CREATE TABLE "product_master_daily"(
          snapshot_date TEXT NOT NULL, source_file_id INTEGER NOT NULL, source_row_number INTEGER NOT NULL,
          "점포명" TEXT, "몰판매상태" TEXT, "점포운영상태" TEXT, "대표MD명" TEXT, "상품이미지" TEXT, "상품바코드" TEXT, "오프라인상품번호" TEXT, "상품명" TEXT, "SSG팀" TEXT, "SSG대분류" TEXT, "SSG중분류" TEXT, "SSG소분류" TEXT, "SSG세분류" TEXT, "기간계담당" TEXT, "기간계팀" TEXT, "기간계대분류" TEXT, "기간계중분류" TEXT, "기간계소분류" TEXT, "협력업체명" TEXT, "협력업체코드" TEXT, "재고판매상태" TEXT, "사용X" TEXT, "사용X__2" TEXT, "사용X__3" TEXT, "상품무게" REAL, "물류속성입력여부" TEXT, "사용X__4" TEXT, "사용X__5" TEXT, "물류분류코드" TEXT, "유통기한관리" TEXT, "사용X__6" TEXT, "사용X__7" TEXT, "센터이용구분" TEXT, "센터기능" TEXT, "매입형태" TEXT, "과세구분" TEXT, "공급가" INTEGER, "판매가" INTEGER, "마진(%)" REAL, "소분대상" TEXT, "매입단위" TEXT, "판매단위" TEXT, "매입단위입수" INTEGER, "매입단위중량" REAL, "BOX입수" INTEGER, "물류바코드" TEXT, "상품 KAN 바코드" TEXT, "상품체적(가로)" REAL, "상품체적(세로)" REAL, "상품체적(높이)" REAL, "사용X__8" TEXT, "사용X__9" TEXT, "사용X__10" TEXT, "사용X__11" TEXT, "사용X__12" TEXT, "사용X__13" TEXT, "사용X__14" TEXT, "발주대상여부" TEXT, "품절관리대상" TEXT, "가재고 생성여부" TEXT, "발주권한" TEXT, "판매단위상이여부" TEXT, "상품등록일" TEXT, "택배가능여부" TEXT, "사용X__15" TEXT, "수정자" TEXT, "수정일시" TEXT, PRIMARY KEY(source_file_id,source_row_number),
          FOREIGN KEY(source_file_id,source_row_number) REFERENCES raw_rows(source_file_id,source_row_number),
          FOREIGN KEY(snapshot_date) REFERENCES dim_date(snapshot_date),
          FOREIGN KEY("오프라인상품번호") REFERENCES dim_product(offline_product_id));

CREATE TABLE "purchase_order_daily"(
          snapshot_date TEXT NOT NULL, source_file_id INTEGER NOT NULL, source_row_number INTEGER NOT NULL,
          "중분류명" TEXT, "소분류명" TEXT, "세분류명" TEXT, "아이템명" TEXT, "물류분류코드명" TEXT, "오프라인상품번호" TEXT, "상품명" TEXT, "단위" TEXT, "판매예측치" REAL, "안전재고" INTEGER, "발주가용재고" INTEGER, "입점예정수량" INTEGER, "권고" INTEGER, "총발주" INTEGER, "발주" INTEGER, "재고일수" REAL, "낱개단위발주여부" TEXT, "행사유형" TEXT, "결과유형" TEXT, "발주상태" TEXT, "발주종류" TEXT, "발주유형" TEXT, "등록일시" TEXT, "등록자" TEXT, "확정일시" TEXT, "확정자" TEXT, "입점예정일" TEXT, "발주서작성여부" TEXT, "사용X" TEXT, PRIMARY KEY(source_file_id,source_row_number),
          FOREIGN KEY(source_file_id,source_row_number) REFERENCES raw_rows(source_file_id,source_row_number),
          FOREIGN KEY(snapshot_date) REFERENCES dim_date(snapshot_date),
          FOREIGN KEY("오프라인상품번호") REFERENCES dim_product(offline_product_id));

CREATE TABLE "purchase_receipt_daily"(
          snapshot_date TEXT NOT NULL, source_file_id INTEGER NOT NULL, source_row_number INTEGER NOT NULL,
          "점포명" TEXT, "점포입점예정일자" TEXT, "매입일" TEXT, "전표번호" TEXT, "전표구분" TEXT, "정정구분" TEXT, "전표구분상세" TEXT, "납품경로" TEXT, "사용X" TEXT, "중분류명" TEXT, "기간계 대분류명" TEXT, "물류분류코드" TEXT, "오프라인상품번호" TEXT, "상품명" TEXT, "BO상위업체" TEXT, "협력업체" TEXT, "사용X__2" TEXT, "판매단위" TEXT, "발주시점 입수수량" INTEGER, "현재시점 입수수량" INTEGER, "낱개단위발주여부" TEXT, "매입확정구분" TEXT, "발주일자" TEXT, "발주수량" INTEGER, "사용X__3" TEXT, "사용X__4" TEXT, "매입수량" INTEGER, "사용X__5" TEXT, "사용X__6" TEXT, "판매가" INTEGER, "해외창고 유형" TEXT, "검수주체" TEXT, PRIMARY KEY(source_file_id,source_row_number),
          FOREIGN KEY(source_file_id,source_row_number) REFERENCES raw_rows(source_file_id,source_row_number),
          FOREIGN KEY(snapshot_date) REFERENCES dim_date(snapshot_date),
          FOREIGN KEY("오프라인상품번호") REFERENCES dim_product(offline_product_id));

CREATE TABLE raw_rows(
      source_file_id INTEGER NOT NULL, source_row_number INTEGER NOT NULL, values_json TEXT NOT NULL,
      PRIMARY KEY(source_file_id,source_row_number),
      FOREIGN KEY(source_file_id) REFERENCES source_files(source_file_id));

CREATE TABLE source_files(
      source_file_id INTEGER PRIMARY KEY, source_kind TEXT NOT NULL, snapshot_date TEXT NOT NULL,
      relative_path TEXT NOT NULL, sha256 TEXT NOT NULL, encoding TEXT NOT NULL,
      byte_size INTEGER NOT NULL, row_count INTEGER NOT NULL, headers_json TEXT NOT NULL,
      original_bytes BLOB NOT NULL, loaded_at TEXT NOT NULL, run_id INTEGER NOT NULL,
      is_current INTEGER NOT NULL CHECK(is_current IN (0,1)), replaces_file_id INTEGER,
      FOREIGN KEY(run_id) REFERENCES ingestion_runs(run_id),
      FOREIGN KEY(replaces_file_id) REFERENCES source_files(source_file_id));

CREATE TABLE "stockout_daily"(
          snapshot_date TEXT NOT NULL, source_file_id INTEGER NOT NULL, source_row_number INTEGER NOT NULL,
          "기준일자" TEXT, "영업점번호" TEXT, "영업점명" TEXT, "오프라인담당명" TEXT, "오프라인팀명" TEXT, "오프라인대분류명" TEXT, "오프라인중분류명" TEXT, "오프라인소분류명" TEXT, "오프라인상품번호" TEXT, "오프라인상품명" TEXT, "표준카테고리대분류명" TEXT, "표준카테고리중분류명" TEXT, "표준카테고리소분류명" TEXT, "표준카테고리세분류명" TEXT, "SSG상품번호" TEXT, "SSG상품명" TEXT, "품절여부" TEXT, "자동발주여부" TEXT, "품절사유" TEXT, "운영시간수" REAL, "품절시간수" REAL, "품절율" REAL, "공급업체ID" TEXT, "공급업체명" TEXT, "하위공급업체ID" TEXT, "하위공급업체명" TEXT, "점물분등급" TEXT, "물류분류코드" TEXT, PRIMARY KEY(source_file_id,source_row_number),
          FOREIGN KEY(source_file_id,source_row_number) REFERENCES raw_rows(source_file_id,source_row_number),
          FOREIGN KEY(snapshot_date) REFERENCES dim_date(snapshot_date),
          FOREIGN KEY("오프라인상품번호") REFERENCES dim_product(offline_product_id));

CREATE INDEX "idx_inventory_daily_date_product" ON "inventory_daily"(snapshot_date,"오프라인상품번호");

CREATE INDEX "idx_inventory_daily_product_date" ON "inventory_daily"("오프라인상품번호",snapshot_date);

CREATE INDEX "idx_location_inventory_daily_date_product" ON "location_inventory_daily"(snapshot_date,"오프라인상품ID");

CREATE INDEX "idx_location_inventory_daily_product_date" ON "location_inventory_daily"("오프라인상품ID",snapshot_date);

CREATE INDEX "idx_product_master_daily_date_product" ON "product_master_daily"(snapshot_date,"오프라인상품번호");

CREATE INDEX "idx_product_master_daily_product_date" ON "product_master_daily"("오프라인상품번호",snapshot_date);

CREATE INDEX "idx_purchase_order_daily_date_product" ON "purchase_order_daily"(snapshot_date,"오프라인상품번호");

CREATE INDEX "idx_purchase_order_daily_product_date" ON "purchase_order_daily"("오프라인상품번호",snapshot_date);

CREATE INDEX "idx_purchase_receipt_daily_date_product" ON "purchase_receipt_daily"(snapshot_date,"오프라인상품번호");

CREATE INDEX "idx_purchase_receipt_daily_product_date" ON "purchase_receipt_daily"("오프라인상품번호",snapshot_date);

CREATE INDEX "idx_stockout_daily_date_product" ON "stockout_daily"(snapshot_date,"오프라인상품번호");

CREATE INDEX "idx_stockout_daily_product_date" ON "stockout_daily"("오프라인상품번호",snapshot_date);

CREATE UNIQUE INDEX uq_current_source ON source_files(source_kind,snapshot_date) WHERE is_current=1;

CREATE VIEW v_action_candidates AS
SELECT *,CASE WHEN stockout_hours>0 AND pending_quantity>0 THEN '입하대기 가용화 확인'
              WHEN stockout_hours>0 AND damaged_quantity>0 THEN '불량 판정/양품화 확인'
              WHEN total_quantity>0 AND mall_status<>'판매중' THEN '몰판매상태/MD 확인'
              WHEN stockout_hours>0 AND receipt_shortage_quantity>0 THEN '납품부족 확인'
              WHEN order_quantity>0 AND coverage_days_14d>=(SELECT value FROM analysis_settings WHERE name='overstock_days') THEN '과재고 추가발주 검토'
              WHEN expiring_quantity>0 THEN '기한임박 소진 검토'
              ELSE '재고/품절 원장 확인' END AS suggested_action
FROM v_latest_inventory WHERE stockout_hours>0 OR pending_quantity>0 OR damaged_quantity>0
 OR (total_quantity>0 AND mall_status<>'판매중') OR excess_available_quantity>0 OR expiring_quantity>0;

CREATE VIEW v_daily_kpi AS
SELECT snapshot_date,COUNT(*) AS observed_products,
       SUM(CASE WHEN stockout_hours IS NOT NULL THEN 1 ELSE 0 END) AS stockout_observed_products,
       SUM(CASE WHEN stockout_hours>0 THEN 1 ELSE 0 END) AS stockout_products,
       100.0*SUM(CASE WHEN operating_hours>0 AND stockout_hours IS NOT NULL THEN stockout_hours END)
          /NULLIF(SUM(CASE WHEN operating_hours>0 AND stockout_hours IS NOT NULL THEN operating_hours END),0) AS time_weighted_stockout_pct,
       SUM(total_quantity) AS total_quantity,SUM(available_quantity) AS available_quantity,
       SUM(pending_quantity) AS pending_quantity,SUM(damaged_quantity) AS damaged_quantity,
       SUM(inventory_retail_value) AS inventory_retail_value,SUM(inventory_supply_value) AS inventory_supply_value,
       SUM(unavailable_retail_value) AS unavailable_retail_value,
       SUM(estimated_opportunity_retail) AS estimated_opportunity_retail,
       SUM(excess_available_quantity*selling_price) AS excess_available_retail_value,
       SUM(expiring_quantity*selling_price) AS expiring_retail_value
FROM v_sku_day GROUP BY snapshot_date;

CREATE VIEW v_data_quality AS
SELECT 'inventory_location_mismatch' AS check_name,COUNT(*) AS issue_count FROM v_sku_day
 WHERE location_quantity IS NOT NULL AND total_quantity IS NOT NULL AND ABS(location_quantity-total_quantity)>0.001
UNION ALL SELECT 'synthetic_three_bucket_mismatch',COUNT(*) FROM v_sku_day
 WHERE ABS(total_quantity-available_quantity-pending_quantity-damaged_quantity)>0.001
UNION ALL SELECT 'missing_master',COUNT(*) FROM v_sku_day WHERE has_master=0
UNION ALL SELECT 'missing_stockout',COUNT(*) FROM v_sku_day WHERE has_stockout=0
UNION ALL SELECT 'missing_order',COUNT(*) FROM v_sku_day WHERE has_order=0
UNION ALL SELECT 'stockout_hours_out_of_range',COUNT(*) FROM v_sku_day
 WHERE stockout_hours<0 OR stockout_hours>operating_hours
UNION ALL SELECT 'numeric_conversion_issues',COUNT(*) FROM data_issues q
 JOIN source_files f ON f.source_file_id=q.source_file_id WHERE f.is_current=1
UNION ALL SELECT 'duplicate_inventory_keys',COUNT(*) FROM
 (SELECT 1 FROM inventory_daily GROUP BY snapshot_date,"오프라인상품번호" HAVING COUNT(*)>1)
UNION ALL SELECT 'duplicate_master_keys',COUNT(*) FROM
 (SELECT 1 FROM product_master_daily GROUP BY snapshot_date,"오프라인상품번호" HAVING COUNT(*)>1)
UNION ALL SELECT 'duplicate_stockout_keys',COUNT(*) FROM
 (SELECT 1 FROM stockout_daily GROUP BY snapshot_date,"오프라인상품번호" HAVING COUNT(*)>1)
UNION ALL SELECT 'duplicate_order_snapshot_keys',COUNT(*) FROM
 (SELECT 1 FROM purchase_order_daily GROUP BY snapshot_date,"오프라인상품번호" HAVING COUNT(*)>1)
UNION ALL SELECT 'negative_inventory_quantity',COUNT(*) FROM inventory_daily
 WHERE "총재고"<0 OR "판매가능수량"<0 OR "입하대기재고"<0 OR "불량재고"<0;

CREATE VIEW v_file_inventory AS
SELECT source_kind,snapshot_date,COUNT(*) AS versions,
       SUM(CASE WHEN is_current=1 THEN row_count ELSE 0 END) AS current_rows,
       SUM(CASE WHEN is_current=1 THEN byte_size ELSE 0 END) AS current_bytes
FROM source_files GROUP BY source_kind,snapshot_date;

CREATE VIEW v_latest_inventory AS SELECT * FROM v_sku_day
WHERE snapshot_date=(SELECT MAX(snapshot_date) FROM inventory_daily);

CREATE VIEW v_location_day AS
SELECT snapshot_date, "오프라인상품ID" AS offline_product_id,
       COUNT(*) AS location_rows, SUM("위치재고") AS location_quantity,
       MIN("유통기한잔여일수") AS minimum_remaining_days,
       SUM(CASE WHEN "유통기한잔여일수" <= (SELECT value FROM analysis_settings WHERE name='expiry_days') THEN "위치재고" ELSE 0 END) AS expiring_quantity
FROM location_inventory_daily GROUP BY snapshot_date,"오프라인상품ID";

CREATE VIEW v_product_current AS
SELECT m.* FROM product_master_daily m
WHERE m.snapshot_date=(SELECT MAX(n.snapshot_date) FROM product_master_daily n WHERE n."오프라인상품번호"=m."오프라인상품번호");

CREATE VIEW v_receipt_day AS
SELECT snapshot_date,"오프라인상품번호" AS offline_product_id,COUNT(*) AS receipt_rows,
       CASE WHEN COUNT("발주수량")=COUNT(*) THEN SUM("발주수량") END AS expected_quantity,
       CASE WHEN COUNT("매입수량")=COUNT(*) THEN SUM("매입수량") END AS received_quantity
FROM purchase_receipt_daily GROUP BY snapshot_date,"오프라인상품번호";

CREATE VIEW v_sku_day AS
WITH i AS (SELECT * FROM inventory_daily GROUP BY snapshot_date,"오프라인상품번호" HAVING COUNT(*)=1),
     m AS (SELECT * FROM product_master_daily GROUP BY snapshot_date,"오프라인상품번호" HAVING COUNT(*)=1),
     s AS (SELECT * FROM stockout_daily GROUP BY snapshot_date,"오프라인상품번호" HAVING COUNT(*)=1),
     o AS (SELECT * FROM purchase_order_daily GROUP BY snapshot_date,"오프라인상품번호" HAVING COUNT(*)=1)
SELECT i.snapshot_date,i."오프라인상품번호" AS offline_product_id,i."물류상품ID" AS logistics_product_id,
       i."상품명" AS product_name,i."물류운영카테고리대분류" AS category,
       i."물류운영카테고리중분류" AS subcategory,m."대표MD명" AS md_name,m."SSG팀" AS team_name,
       COALESCE(m."협력업체명",i."연동공급업체명") AS supplier_name,m."몰판매상태" AS mall_status,
       i."총재고" AS total_quantity,i."판매가능수량" AS available_quantity,
       i."입하대기재고" AS pending_quantity,i."불량재고" AS damaged_quantity,
       i."입하예정수량" AS incoming_quantity,i."출하예정량" AS outbound_planned_quantity,
       i."판매가" AS selling_price,m."공급가" AS supply_price,
       i."총재고"*i."판매가" AS inventory_retail_value,i."총재고"*m."공급가" AS inventory_supply_value,
       (i."입하대기재고"+i."불량재고")*i."판매가" AS unavailable_retail_value,
       i."DW 일평균 판매량 (14일 기준)" AS average_sales_14d,
       i."DW 일평균 판매량 (85일 기준)" AS average_sales_85d,
       i."SSG 재고일수 (14일 기준)" AS coverage_days_14d,
       i."SSG 재고일수 (85일 기준)" AS coverage_days_85d,
       i."DW 일평균 판매량 (14일 기준)"/NULLIF(i."DW 일평균 판매량 (85일 기준)",0) AS short_long_sales_ratio,
       s."품절시간수" AS stockout_hours,s."운영시간수" AS operating_hours,s."품절사유" AS recorded_stockout_reason,
       i."DW 일평균 판매량 (14일 기준)"*s."품절시간수"/NULLIF(s."운영시간수",0) AS estimated_opportunity_quantity,
       i."DW 일평균 판매량 (14일 기준)"*s."품절시간수"/NULLIF(s."운영시간수",0)*i."판매가" AS estimated_opportunity_retail,
       CASE WHEN i."DW 일평균 판매량 (14일 기준)">0 THEN MAX(0,i."판매가능수량"-i."DW 일평균 판매량 (14일 기준)"*(SELECT value FROM analysis_settings WHERE name='target_days')) END AS excess_available_quantity,
       o."발주" AS order_quantity,o."권고" AS recommended_quantity,o."확정자" AS confirmer,
       o."입점예정일" AS planned_arrival_date,
       (o."발주가용재고"+o."입점예정수량"+o."발주")/NULLIF(i."DW 일평균 판매량 (14일 기준)",0) AS simple_projected_coverage,
       r.expected_quantity AS expected_receipt_quantity,r.received_quantity,
       CASE WHEN r.expected_quantity IS NOT NULL AND r.received_quantity IS NOT NULL THEN MAX(0,r.expected_quantity-r.received_quantity) END AS receipt_shortage_quantity,
       l.location_quantity,l.minimum_remaining_days,l.expiring_quantity,
       CASE WHEN m.source_file_id IS NOT NULL THEN 1 ELSE 0 END AS has_master,
       CASE WHEN s.source_file_id IS NOT NULL THEN 1 ELSE 0 END AS has_stockout,
       CASE WHEN o.source_file_id IS NOT NULL THEN 1 ELSE 0 END AS has_order,
       i.source_file_id AS inventory_source_file_id,i.source_row_number AS inventory_source_row
FROM i LEFT JOIN m ON m.snapshot_date=i.snapshot_date AND m."오프라인상품번호"=i."오프라인상품번호"
LEFT JOIN s ON s.snapshot_date=i.snapshot_date AND s."오프라인상품번호"=i."오프라인상품번호"
LEFT JOIN o ON o.snapshot_date=i.snapshot_date AND o."오프라인상품번호"=i."오프라인상품번호"
LEFT JOIN v_receipt_day r ON r.snapshot_date=i.snapshot_date AND r.offline_product_id=i."오프라인상품번호"
LEFT JOIN v_location_day l ON l.snapshot_date=i.snapshot_date AND l.offline_product_id=i."오프라인상품번호";

CREATE VIEW v_supplier_receipt_kpi AS
SELECT snapshot_date,"협력업체" AS supplier_name,COUNT(*) AS observed_receipts,
       SUM("발주수량") AS ordered_quantity,SUM("매입수량") AS received_quantity,
       100.0*SUM(CASE WHEN "발주수량">0 AND "매입수량" IS NOT NULL THEN "매입수량" END)
       /NULLIF(SUM(CASE WHEN "발주수량">0 AND "매입수량" IS NOT NULL THEN "발주수량" END),0) AS quantity_fill_pct,
       SUM(CASE WHEN "발주수량" IS NOT NULL AND "매입수량" IS NOT NULL THEN MAX(0,"발주수량"-"매입수량") END) AS shortage_quantity,
       SUM(CASE WHEN "매입일">"점포입점예정일자" THEN 1 ELSE 0 END) AS late_receipts
FROM purchase_receipt_daily GROUP BY snapshot_date,"협력업체";
