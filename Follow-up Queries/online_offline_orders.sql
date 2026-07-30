-- ONLINE VS. OFFLINE ORDERS
-- Follow-up to churn_analysis.sql — quarterly order counts by channel.

select
	date_trunc('quarter', orderdate)::date as order_quarter,
	count(*) filter (where onlineorderflag = true) as online_orders,
	count(*) filter (where onlineorderflag = false) as offline_orders
from sales.salesorderheader
group by date_trunc('quarter', orderdate)::date
order by date_trunc('quarter', orderdate)::date;