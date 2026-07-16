-- MARKET BASKET ANALYSIS (CATEGORY-LEVEL)
-- Finds pairs of product categories ordered together and how often, using a self-join.

select
	pc1.name as product_category_1,
	pc2.name as product_category_2,
	count(sod1.salesorderid) as co_occurence_count
from sales.salesorderdetail sod1
join sales.salesorderdetail sod2
	on sod1.salesorderid = sod2.salesorderid
	and sod1.productid < sod2.productid
join production.product p1
	on sod1.productid = p1.productid
join production.productsubcategory psc1
	on p1.productsubcategoryid = psc1.productsubcategoryid
join production.productcategory pc1
	on psc1.productcategoryid = pc1.productcategoryid
join production.product p2
	on sod2.productid = p2.productid
join production.productsubcategory psc2
	on p2.productsubcategoryid = psc2.productsubcategoryid
join production.productcategory pc2
	on psc2.productcategoryid = pc2.productcategoryid
where pc1.name != pc2.name
group by pc1.name, pc2.name
order by co_occurence_count desc;