SELECT *
FROM
  (
   SELECT
     "w_warehouse_name"
   , "i_item_id"
   , "sum"((CASE WHEN (CAST("d_date" AS DATE) < DATE '2000-03-11') THEN "inv_quantity_on_hand" ELSE 0 END)) "inv_before"
   , "sum"((CASE WHEN (CAST("d_date" AS DATE) >= DATE '2000-03-11') THEN "inv_quantity_on_hand" ELSE 0 END)) "inv_after"
   FROM
     inventory
   , warehouse
   , item
   , date_dim
--    WHERE ("i_current_price" BETWEEN DECIMAL '0.99' AND DECIMAL '1.49')
   WHERE ("i_current_price" BETWEEN 0.99 AND 1.49)
      AND ("i_item_sk" = "inv_item_sk")
      AND ("inv_warehouse_sk" = "w_warehouse_sk")
      AND ("inv_date_sk" = "d_date_sk")
      AND (CAST("d_date" AS DATE) BETWEEN (DATE '2000-03-11' - INTERVAL '30' DAY) AND (DATE '2000-03-11' + INTERVAL '30' DAY))
   GROUP BY "w_warehouse_name", "i_item_id"
)  x
WHERE ((CASE WHEN ("inv_before" > 0) THEN (CAST("inv_after" AS DECIMAL(7,2)) / "inv_before") ELSE null END) BETWEEN (DECIMAL '2.00' / DECIMAL '3.00') AND (DECIMAL '3.00' / DECIMAL '2.00'))
-- WHERE ((CASE WHEN ("inv_before" > 0) THEN (CAST("inv_after" AS DOUBLE ) / "inv_before") ELSE null END) BETWEEN (2.00 / 3.00) AND (3.00 / 2.00))
ORDER BY "w_warehouse_name" ASC, "i_item_id" ASC
LIMIT 100
