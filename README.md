# Code Snippets for Queries, Metrics and Dashboards 

 Sample codes references for SQL queries, creating metrics and dashboards through Bigquery, and other SQL editor.
  
### Example #1 

 I used google's open dataset to create dashboard for COVID-19 confirmed cases and deaths in United States. The dataset does not contain geo-locations to reference the cases on the map, so I created geo-locations by concating two columns from different data source then joining the temporary table with the table that has the location reference on county_fips_code (reference for the counties in US).
	
```SQL 
WITH geo_US AS (
SELECT DISTINCT CONCAT(ST_Y(ST_CENTROID(county_geom)),',',ST_X(ST_CENTROID(county_geom))) AS marker,  
county_name as county, 
CONCAT(state_fips_code,county_fips_code) as county_fips_code
FROM `bigquery-public-data`.utility_us.us_county_area ),

join_table AS (SELECT counties.*, geo_US.marker from geo_US 
RIGHT OUTER JOIN `bigquery-public-data.covid19_nyt.us_counties` as counties
 USING (county_fips_code)
),

```
After joining the tables, I created lag columns for confirmed cases and death so I can create daily changes or percantage change. 
```SQL
daily_change AS (SELECT *, lag(confirmed_cases,1) OVER one_day_lag as lag_cases,
lag(deaths,1) OVER one_day_lag as lag_deaths
FROM join_table 
WINDOW one_day_lag as (PARTITION BY county, state_name ORDER BY date asc)),

temp_table AS( SELECT *, (confirmed_cases-lag_cases) as daily_change_cases, 
	(deaths - lag_deaths) as daily_change_deaths 

FROM daily_change )

SELECT * FROM temp_table 

```
Link for dashboard: https://datastudio.google.com/u/0/reporting/45e97e16-08ca-4e4d-a7a9-bce29d86f17f/page/31MZB
