-- QUARTER COMPARISON
-- Follow-up to quarterly revenue trend: compares 2025 Q1 to 2025 Q2

with cte_order_quarters as(
	select
		date_trunc('quarter', soh.orderdate)::date as order_quarter,
		sum(sod.unitprice * sod.orderqty * (1 - sod.unitpricediscount)) as revenue,
		count(distinct soh.salesorderid) as order_count,
		count(distinct soh.customerid) as customer_count
	from sales.salesorderheader soh
	join sales.salesorderdetail sod
		on soh.salesorderid = sod.salesorderid
	where soh.orderdate >= '2025-01-01'
	group by date_trunc('quarter', soh.orderdate)::date
)
select
	order_quarter,
	round(revenue::numeric) as revenue,
	order_count,
	customer_count,
	round(revenue::numeric / order_count) as average_order_value,
	round(revenue::numeric / customer_count) as average_revenue_per_customer
from cte_order_quarters;

	