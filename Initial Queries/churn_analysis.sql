-- CHURN ANALYSIS (QUARTERLY)
-- Classifies each customer as New, Retained, Reactivated, or Churned for each quarter.

with cte_customer_orders as(
	select distinct
		c.customerid as customer_id,
		date_trunc('quarter', soh.orderdate)::date as order_quarter
	from sales.customer c
	join sales.salesorderheader soh
		on c.customerid = soh.customerid
),
cte_lag_lead as(
	select
		customer_id,
		order_quarter,
		lag(order_quarter) over(partition by customer_id order by order_quarter) as last_quarter,
		lead(order_quarter) over(partition by customer_id order by order_quarter) as next_quarter
	from cte_customer_orders
),
cte_new_retained_reactivated_churned as(
	select
		customer_id,
		order_quarter,
		case
			when last_quarter is null then 'New'
			when last_quarter = (order_quarter - interval '3 months')::date then 'Retained'
			when last_quarter != (order_quarter - interval '3 months')::date then 'Reactivated'
		end as customer_status,
		case
			when (next_quarter is null or next_quarter != (order_quarter + interval '3 months')::date)
			and order_quarter < (select max(order_quarter) from cte_customer_orders)
			then 'Churned'
		end as churned_status
	from cte_lag_lead
)
select
	order_quarter,
	count(case when customer_status = 'New' then 1 end) as new_customers,
	count(case when customer_status = 'Retained' then 1 end) as retained_customers,
	count(case when customer_status = 'Reactivated' then 1 end) as reactivated_customers,
	case
		when order_quarter < (select max(order_quarter) from cte_customer_orders)
		then count(case when churned_status = 'Churned' then 1 end) 
	end as churned_customers 
from cte_new_retained_reactivated_churned
group by order_quarter
order by order_quarter;

select
	date_trunc('quarter', orderdate)::date as order_quarter,
	count(*) filter (where onlineorderflag = true) as online_orders,
	count(*) filter (where onlineorderflag = false) as offline_orders
from sales.salesorderheader
group by date_trunc('quarter', orderdate)::date
order by date_trunc('quarter', orderdate)::date;