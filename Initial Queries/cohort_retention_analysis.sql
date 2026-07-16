-- CUSTOMER COHORT RETENTION (QUARTERLY)
-- % of each cohort (grouped by first order quarter) that reordered
-- 1, 2, and 3 quarters later. NULL = too early to measure, 0.00% = measured and zero.

with cte_customer_orders as(
	select distinct
		c.customerid as customer_id,
		date_trunc('quarter', soh.orderdate) as order_quarter,
		min(date_trunc('quarter', soh.orderdate)) over(partition by c.customerid) as cohort_quarter
	from sales.customer c
	join sales.salesorderheader soh
		on c.customerid = soh.customerid
),
cte_quarters_since_cohort as(
	select
		co.customer_id,
		co.order_quarter::date,
		co.cohort_quarter::date,
		(date_part('year', co.order_quarter) - date_part('year', co.cohort_quarter)) * 4
			+ (date_part('quarter', co.order_quarter) - date_part('quarter', co.cohort_quarter)) as quarters_since_cohort
	from cte_customer_orders co
),
cte_quarter_counts as(
	select
		cohort_quarter,
		count(case when quarters_since_cohort = 0 then customer_id end) as cohort_quarter_customer_count,
		count(case when quarters_since_cohort = 1 then customer_id end) as quarter_1_customer_count,
		count(case when quarters_since_cohort = 2 then customer_id end) as quarter_2_customer_count,
		count(case when quarters_since_cohort = 3 then customer_id end) as quarter_3_customer_count
	from cte_quarters_since_cohort
	group by cohort_quarter
),
cte_customer_retention as(
	select
		cohort_quarter,
		cohort_quarter_customer_count,
		quarter_1_customer_count,
		quarter_2_customer_count,
		quarter_3_customer_count,
		round((quarter_1_customer_count::numeric / cohort_quarter_customer_count) * 100, 2) as quarter_1_retention,
		round((quarter_2_customer_count::numeric / cohort_quarter_customer_count) * 100, 2) as quarter_2_retention,
		round((quarter_3_customer_count::numeric / cohort_quarter_customer_count) * 100, 2) as quarter_3_retention
	from cte_quarter_counts
),
	cte_max_quarter as(
   		select 
        	max(date_trunc('quarter', soh.orderdate)) as max_quarter
    	from sales.salesorderheader soh
)
select
	cohort_quarter,
	cohort_quarter_customer_count,
	case
		when cohort_quarter <= max_quarter - interval '3 months'
		then quarter_1_customer_count
	end as quarter_1_customer_count,
	case
		when cohort_quarter <= max_quarter - interval '3 months'
		then quarter_1_retention
	end as quarter_1_retention,
	case
		when cohort_quarter <= max_quarter - interval '6 months'
		then quarter_2_customer_count
	end as quarter_2_customer_count,
	case
		when cohort_quarter <= max_quarter - interval '6 months'
		then quarter_2_retention
	end as quarter_2_retention,
	case
		when cohort_quarter <= max_quarter - interval '9 months'
		then quarter_3_customer_count
	end as quarter_3_customer_count,
	case
		when cohort_quarter <= max_quarter - interval '9 months'
		then quarter_3_retention
	end as quarter_3_retention
from cte_customer_retention
cross join cte_max_quarter
order by cohort_quarter;
	
	