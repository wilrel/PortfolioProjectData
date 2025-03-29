CREATE TABLE KimiaFarma.analisa_table AS
SELECT 
  t.transaction_id,
  t.date,
  t.branch_id,
  kc.branch_name,
  kc.kota,
  kc.provinsi,
  kc.rating as rating_cabang,
  t.customer_name,
  t.product_id,
  p.product_name,
  p.price as actual_price,
  t.discount_percentage,
    CASE
        WHEN p.price <= 50000 THEN 0.10
        WHEN p.price > 50000 AND p.price <= 100000 THEN 0.15
        WHEN p.price > 100000 AND p.price <= 300000 THEN 0.20
        WHEN p.price > 300000 AND p.price <= 500000 THEN 0.25
        WHEN p.price > 500000 THEN 0.30
    END AS presentase_gross_laba,
    (p.price*(1 - t.discount_percentage/100)) AS nett_sales,
    ((p.price*(1 - t.discount_percentage/100)) *
    CASE
        WHEN p.price <= 50000 THEN 0.10
        WHEN p.price > 50000 AND p.price <= 100000 THEN 0.15
        WHEN p.price > 100000 AND p.price <= 300000 THEN 0.20
        WHEN p.price > 300000 AND p.price <= 500000 THEN 0.25
        WHEN p.price > 500000 THEN 0.30
    END) AS nett_profit,
  t.rating AS rating_transaksi
  FROM
      KimiaFarma.kf_final_transaction t
  JOIN
      KimiaFarma.kf_product p ON t.product_id = p.product_id
  JOIN 
      KimiaFarma.kf_kantor_cabang kc ON t.branch_id = kc.branch_id;