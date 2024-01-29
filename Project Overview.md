# overview of steel project

This data anlysis project aims to provide insights in to the sales of the steel rods of an steel production company over the past year. By analyzing various aspects of the sales data , we seek to indentify trends, make data-drien recommendations, and gain a deeper understanding of the client performance

## Table of contents
- [Data sources](#data-sources)
- [Tools](#tools)
- [Data Cleaning/ Preparation](#data-cleaning-preparation)
- [Exploratory Data Analysis](#exploratory-data-analysis)
- [Results/ Findings](#results-findings)
- [Recommendations](#recommendations)


_
## Data sources
steel_set : The primary dataset used for this analysis is the "steel_set.csv" file containing detailed information about each sale made by production company

## Tools
- Excel - Data store , Data Cleaning
- Python -Exploratory Data Analysis, Data preprocessing
- MySql - Data Analysis
- PowerBI - creating reports and Dashboards
- (Tableau - when there is need iof map visualization)
- Google Data studio/Looker studio - creating Dashboards


## Data Cleaning/ Preparation
In the data preparation phase, We performed these task
1. Data loading and inspection
2. Handling missing values
3. Data cleaning and formatting

## Exploratory Data Anlaysis 
- In the initial EDA phase, We performed four business moments
1. First business moment ( Measures of central tendency)
2. Second business moment ( Measures of dispersion)
3. Third business moment ( Skewness)
4. Fourth business moment ( Kurtosis)

## Data Analysis
```sql
 SELECT Quantity AS mode_Quantity
FROM (
SELECT Quantity, COUNT(*) AS frequency
FROM steelset
GROUP BY Quantity
ORDER BY frequency DESC
LIMIT 1
) AS subquery;
```

## Results/ Findings
1.The companys sales have been steadily increasing over past year , with anoiceable peak during Steel having full length and grade of 500d is the highest selling
2.Length of 12m and 8mm dia  is best performing in terms of sales and revenue
3.There are 1016 distinct customers and among them Dia of 6mm is least bought

## Recommendations
Based on the anlaysis , we recommend the following actions:
- Invest in marketing and promotions during peak season to maximize revenue
- Focus on expanding and promoting products in steel having full length or 12m and grade of 500D
- Real time monitoring. 
- Production unit should take care of the careful cutting of the steel rods as per required length to reduce offcuts .
- Demand forecasting  :- Steel rods having 8mm dia are sold more therefore the production unit just have to focus on producing those as 6mm is least sold as it can be produced as per requirement 


## Limitations
 I had to remove all zero values from rtnmrp and rtnquantity because they would affected the accuracy of my conclusions for the analysis . There are still few outliers even after the ommision 









  
