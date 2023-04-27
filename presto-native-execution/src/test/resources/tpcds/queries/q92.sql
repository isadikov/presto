SELECT "round"("sum"("ws_ext_discount_amt"), 2) "Excess Discount Amount"
FROM
  web_sales
, item
, date_dim
WHERE ("i_manufact_id" = 350)
   AND ("i_item_sk" = "ws_item_sk")
   AND (CAST("d_date" AS DATE) BETWEEN DATE '2000-01-27' AND (DATE '2000-01-27' + INTERVAL '90' DAY))
   AND ("d_date_sk" = "ws_sold_date_sk")
   AND ("ws_ext_discount_amt" > (
      SELECT (DECIMAL '1.3' * "avg"("ws_ext_discount_amt"))
      FROM
        web_sales
      , date_dim
      WHERE ("ws_item_sk" = "i_item_sk")
         AND (CAST("d_date" AS DATE) BETWEEN DATE '2000-01-27' AND (DATE '2000-01-27' + INTERVAL '90' DAY))
         AND ("d_date_sk" = "ws_sold_date_sk")
   ))
ORDER BY "round"("sum"("ws_ext_discount_amt"), 2) ASC
LIMIT 100
