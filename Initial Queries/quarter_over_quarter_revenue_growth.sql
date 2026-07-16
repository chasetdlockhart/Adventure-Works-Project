-- QUARTER-OVER-QUARTER REVENUE GROWTH
-- Calculates revenue per quarter and the % change from the prior quarter.

with cte_quarterly_revenue as(
	select
		date_trunc('quarter', soh.orderdate)::date as order_quarter,
				sum(sod.unitprice * sod.orderqty * (1 - sod.unitpricediscount)) as revenue
	from sales.salesorderheader soh
	join sales.salesorderdetail sod
		on soh.salesorderid = sod.salesorderid
	group by date_trunc('quarter', soh.orderdate)::date
),
cte_lag as(
	select
		order_quarter,
		revenue,
		lag(revenue) over(order by order_quarter) as last_quarter_revenue
	from cte_quarterly_revenue
)
select
	order_quarter,
	round(revenue::numeric, 2) as revenue,
	round(last_quarter_revenue::numeric, 2) as last_quarter_revenue,
	round((((revenue - last_quarter_revenue) / nullif(last_quarter_revenue, 0)) * 100)::numeric, 2) as quarter_over_quarter_percentage_change
from cte_lag
order by order_quarter;