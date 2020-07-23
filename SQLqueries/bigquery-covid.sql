WITH geo_US AS (
SELECT DISTINCT CONCAT(ST_Y(ST_CENTROID(county_geom)),',',ST_X(ST_CENTROID(county_geom))) AS marker,  
county_name as county, 
CONCAT(state_fips_code,county_fips_code) as county_fips_code
FROM `bigquery-public-data`.utility_us.us_county_area ),

join_table AS (SELECT counties.*, geo_US.marker from geo_US 
RIGHT OUTER JOIN `bigquery-public-data.covid19_nyt.us_counties` as counties
 USING (county_fips_code)
),

daily_change AS (SELECT *, lag(confirmed_cases,1) OVER one_day_lag as lag_cases,
lag(deaths,1) OVER one_day_lag as lag_deaths
FROM join_table 
WINDOW one_day_lag as (PARTITION BY county, state_name ORDER BY date asc)),

temp_table AS( SELECT *, (confirmed_cases-lag_cases) as daily_change_cases, 
	(deaths - lag_deaths) as daily_change_deaths 

FROM daily_change )

SELECT * FROM temp_table 
