-- RFM CUSTOMER SEGMENTATION
-- Scores customers 1-5 on Recency, Frequency, and Revenue
-- and classifies them into segments (Champion, Loyal, At Risk, etc.)
-- Reference date: 2025-07-01

with cte_rfm_setup as(
	select
		c.customerid as customer_id,
		'2025-07-01'::date - (max(soh.orderdate))::date as days_since_last_order,
		count(distinct soh.salesorderid) as order_count,
		sum(sod.unitprice * sod.orderqty * (1 - sod.unitpricediscount)) as revenue
	from sales.customer c
	join sales.salesorderheader soh
		on c.customerid = soh.customerid
	join sales.salesorderdetail sod
		on soh.salesorderid = sod.salesorderid
	group by c.customerid
),
cte_ntile as(
	select
		customer_id,
		days_since_last_order,
		order_count,
		revenue,
		ntile(5) over(order by days_since_last_order desc) as recency_score,
		ntile(5) over(order by order_count) as frequency_score,
		ntile(5) over(order by revenue) as revenue_score
	from cte_rfm_setup
)
select
	customer_id,
	days_since_last_order,
	order_count,
	round(revenue::numeric, 0) as revenue,
	recency_score,
	frequency_score,
	revenue_score,
	concat(recency_score, frequency_score, revenue_score) as total_score,
	case
		when concat(recency_score, frequency_score, revenue_score) = '555' then 'Champion'
		when frequency_score = 5 then 'Loyal'
		when recency_score = 1 then 'Lost'
		when recency_score <= 3 then 'At Risk'
		else 'Standard'
	end as customer_label
from cte_ntile
order by total_score desc;




	