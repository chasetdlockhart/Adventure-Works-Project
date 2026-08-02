# Adventure Works Sales Analytics

## Overview
This project analyzes customer behavior and sales performance using Microsoft's
AdventureWorks sales database, covering quarter-over-quarter revenue growth, customer churn,  RFM-based customer segmentation, and customer cohort retention. 
## Project Structure
- `Initial Queries` - SQL queries run against the AdventureWorks database
- `Raw csvs` - unprocessed query exports
- `Data Cleaning` - pandas notebooks that clean and reshape the raw exports for Tableau
- `Clean csvs` - final, cleaned output ready for Tableau
- `Follow-up Queries` - SQL queries to answer follow-up questions
## Pipeline / Process
I queried the database in DBeaver, and exported those results as CSVs. Rather than taking the raw exports straight to Tableau, I cleaned and reformatted them using pandas in VSCode. I changed data types, reshaped some CSVs to long format, and created `is_measurable` columns so I could flag values that weren't measurable and filter them out when making dashboards. These changes are meant to make working with the CSVs in Tableau easier. After that I exported the clean CSVs which were now ready for Tableau.
## Design Approach
After working with the database one of the first design decisions I made was to use quarters instead of months, because many of the company's sales were on a quarterly basis. By analyzing on a quarterly basis, the actual trends of the company are more clear. Another recurring design decision I made throughout this project was to make values that were immeasurable null instead of letting them default to zero. This showed up through multiple queries but specifically in the `cohort_retention_analysis` where I had to make the immeasurable values for 1, 2, and 3 quarters after the customer's `cohort_quarter` null instead of 0. Then the addition of the `is_measurable` boolean column lets me filter this out when making visualizations. 
## Key Findings
[View the interactive dashboards on Tableau Public](https://public.tableau.com/shared/2TJQ2PXDT?:display_count=n&:origin=viz_share_link)
### Quarterly Revenue Trend
Adventure Works quarterly revenue increased from 2.5 million dollars in early 2022 to 12.8 million at the beginning of 2025 before taking a steep decline to 7.2 million in the following quarter, a 44% decline. To further investigate the sudden decline, I compared KPIs of 2025 Q1 to 2025 Q2. I found that the 44% decrease in revenue can be attributed to a 14.2% decrease in order volume and a 14.3% decrease in customer count while average order value decreased by 34.8% and average customer revenue fell by 34.7%. In unison, these factors led to the largest quarter-over-quarter revenue drop in the data. The fact that orders per customer stayed nearly identical between quarters supports a wholesale/inventory-ordering pattern, which is also why sales line up better on a quarterly than monthly basis. Further investigation into product mix or promotional timing would help pinpoint the exact driver, though that's outside this project's customer-behavior scope.

![alt text](image.png)

