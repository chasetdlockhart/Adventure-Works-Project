# Adventure Works Sales Analytics

## Overview
This project analyzes customer behavior and sales performance using Microsoft's
AdventureWorks sales database, covering customer cohort retention, churn,
quarter-over-quarter revenue growth, the split between online and offline sales
channels, and RFM-based customer segmentation. 
## Project Structure
- `Initial Queries` — SQL queries run against the AdventureWorks database
- `Raw csvs` — unprocessed query exports
- `Data Cleaning` — pandas notebooks that clean and reshape the raw exports for Tableau
- `Clean csvs` — final, cleaned output ready for Tableau
## Pipeline / Process
I queried the database in DBeaver, and exported those results as CSVs. Rather than taking the raw exports straight to Tableau, I cleaned and reformatted them using pandas in VSCode. I changed data types, reshaped some CSVs to long format, and created `is_measurable` columns so I could flag values that weren't measurable and filter them out when making dashboards. These changes are meant to make working with the CSVs in Tableau easier. After that I exported the clean CSVs which were now ready for Tableau.
## Design Approach
After working with the database one of the first design decisions I made was to use quarters instead of months, because many of the company's sales were on a quarterly basis. By analyzing on a quarterly basis, the actual trends of the company are more clear. Another recurring design decision I made throughout this project was to make values that were immeasurable null instead of letting them default to zero. This showed up through multiple queries but specifically in the `cohort_retention_analysis` where I had to make the immeasurable values for 1, 2, and 3 quarters after the customer's `cohort_quarter` null instead of 0. Then the addition of the `is_measurable` boolean column lets me filter this out when making visualizations. 
## Key Findings