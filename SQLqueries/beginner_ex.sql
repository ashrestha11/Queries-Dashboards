SELECT * FROM cd.facilities 
limit 100;

SELECT facid, name, membercost, monthlymaintenance FROM cd.facilities 
WHERE membercost > 0 
AND membercost < (monthlymaintenance/50) ;

SELECT * from cd.facilities 
WHERE name LIKE '%Tennis%';


SELECT * from cd.facilities 
WHERE facid in (1,5);

SELECT memid, firstname,surname, joindate FROM cd.members 
WHERE joindate > '2012-09-01'
limit 100;

SELECT DISTINCT(surname) FROM cd.members 
ORDER BY surname
limit 10;

SELECT joindate from cd.members 
ORDER by memid desc 
limit 1;

SELECT COUNT(name) from cd.facilities 
WHERE guestcost >= 10;

SELECT facid, starttime, sum(slots) from cd.bookings
WHERE starttime between '2012-09-01' and '2012-09-30'
GROUP BY facid 

limit 100;

SELECT facid, sum(slots) from cd.bookings
WHERE starttime >= '2012-09-01' and
starttime < '2012-10-01'
group by facid 
order by sum ;

SELECT facid, sum(slots) from cd.bookings
group by facid 
having sum(slots) > 1000
ORDER BY facid;


SELECT cd.bookings.starttime, cd.facilities.name
FROM cd.facilities 
INNER JOIN cd.bookings
ON cd.facilities.facid = cd.bookings.facid 
WHERE cd.facilities.facid in (0,1)
AND cd.bookings.starttime >= '2012-09-21'
AND cd.bookings.starttime < '2012-09-22';




