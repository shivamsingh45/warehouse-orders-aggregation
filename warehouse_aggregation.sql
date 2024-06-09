SELECT
  wh.warehouse_id,
  CONCAT(wh.state,':',wh.warehouse_alias) AS warehouse_name,
  COUNT(od.order_id) AS num_of_orders,
  (SELECT COUNT(*) FROM silicon-airlock-424103-f2.warehouse.orders AS od) AS total_orders,
  CASE 
    WHEN COUNT(od.order_id)/(SELECT COUNT(*) FROM silicon-airlock-424103-f2.warehouse.orders AS od) <= 0.20
    THEN 'Fulfilled 0-20% of Orders'
    WHEN COUNT(od.order_id)/(SELECT COUNT(*) FROM silicon-airlock-424103-f2.warehouse.orders AS od) > 0.20
    AND COUNT(od.order_id)/(SELECT COUNT(*) FROM silicon-airlock-424103-f2.warehouse.orders AS od) <= 0.60
    THEN 'Fulfilled 20-60% of Orders'
    ELSE 'Fulfilled more than 60% of Orders'
  END AS Fulfillment_summary
FROM 
  silicon-airlock-424103-f2.warehouse.warehouse AS wh
LEFT JOIN 
  silicon-airlock-424103-f2.warehouse.orders AS od
  ON wh.warehouse_id = od.warehouse_id
GROUP BY 
  wh.warehouse_id,
  warehouse_name
HAVING 
  COUNT(od.order_id) > 0
