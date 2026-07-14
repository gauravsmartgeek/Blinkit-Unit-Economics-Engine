create database blinkit_ml_warehouse;
use blinkit_ml_warehouse;

CREATE TABLE fact_delivery_performance (
    order_id VARCHAR(50) PRIMARY KEY,
    delivery_partner_id VARCHAR(50),
    promised_time DATETIME,
    actual_time DATETIME,
    delivery_time_minutes DECIMAL(10, 2),
    distance_km DECIMAL(10, 2),
    delivery_status VARCHAR(50),
    reasons_if_delayed VARCHAR(255)
);
CREATE TABLE fact_blinkit_orders (
    order_id VARCHAR(255),
    customer_id VARCHAR(255),
    order_date datetime,
    promised_delivery_time datetime,
    actual_delivery_time datetime,
    delivery_status VARCHAR(255),
    order_total int,
    payment_method VARCHAR(255),
    delivery_partner_id VARCHAR(255),
    store_id VARCHAR(255)
);



CREATE OR REPLACE VIEW vw_sla_breach_engine AS
SELECT 
    o.order_id,
    o.order_date,
    o.total_order,
    dp.delivery_partner_id,
    dp.distance_km,
    dp.delivery_time_minutes,
    
    -- The Logic Layer: Using TIMESTAMPDIFF exactly as we discussed earlier
    -- If actual delivery is more than 0 minutes past promised, it's a breach
    CASE 
        WHEN TIMESTAMPDIFF(MINUTE, o.promised_delivery_time, o.actual_delivery_time) > 0 THEN 1 
        ELSE 0 
    END AS is_sla_breach,
    
    -- The Architect Layer: Window Function for rolling performance
    ROUND(
        AVG(dp.delivery_time_minutes) OVER (
            PARTITION BY dp.delivery_partner_id 
            ORDER BY o.order_date ASC 
            ROWS BETWEEN 5 PRECEDING AND CURRENT ROW
        ), 2
    ) AS rolling_partner_avg_time

FROM 
    fact_blinkit_orders o
INNER JOIN 
    fact_delivery_performance dp ON o.order_id = dp.order_id;
   SELECT COUNT(*) FROM fact_blinkit_orders;
SELECT COUNT(*) FROM fact_delivery_performance;
SELECT 
    SUM(is_sla_breach) AS total_breaches,
    SUM(total_order) as revenue_at_risk
FROM 
    vw_sla_breach_engine
WHERE 
    is_sla_breach = 1;
    
create or replace view vw_unit_economics_engine as
select
o.order_id,
o.total_order,
dp.distance_km,
round((o.total_order*0.20),2) as Gross_margin,
round(20+(5*dp.distance_km),2) as Delivery_cost,
round ((o.total_order*0.20) -(20+(5*dp.distance_km)),2) as Net_profit,
case 
when ((o.total_order*0.20) -(20+(5*dp.distance_km))) < 0 then 'Loss'
else 'Profit'
end as Profitability_status
from fact_blinkit_orders o 
join fact_delivery_performance dp 
on o.order_id = dp.order_id;

select Profitability_status, count(*), sum(net_profit)
from vw_unit_economics_engine
group by Profitability_status;