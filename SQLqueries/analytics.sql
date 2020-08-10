-- metrics for % of pageviews and time spent  from different channel source 

SELECT 
channel,
ROUND((page_views/total_pageview)*100, 2) as pageview_percantage, 
ROUND((time_spent/total_timespent)*100, 2) as timespent_percantage

FROM (SELECT channel, 
page_views, time_spent,
SUM(page_views) OVER (PARTITION BY date) as total_pageview, 
SUM(time_spent) OVER (PARTITION BY date) as total_timespent

FROM (
SELECT date, channelGrouping AS channel,
SUM(totals.pageviews) as page_views, 
SUM(totals.timeOnSite) as time_spent, 
FROM
`bigquery-public-data.google_analytics_sample.ga_sessions_20170801`
GROUP BY channelGrouping,date
ORDER BY page_views desc));
