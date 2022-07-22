-- Try to write SQLs on your own, use this as a reference when you are not sure
-- how to run certain queries.


SELECT *
FROM skaters
;

SELECT sname, age
FROM skaters
;


SELECT age
FROM skaters
;


SELECT DISTINCT age, rating
FROM skaters
;


SELECT *
FROM skaters
WHERE age = 12
;

SELECT *
FROM skaters
WHERE age > 12
;

SELECT *
FROM skaters
WHERE age <> 12
;

SELECT *
FROM skaters
WHERE age BETWEEN 12 AND 15
;

-- Strings and dates

SELECT *
FROM competition
WHERE ctype = 'local'
;

SELECT *
FROM competition
WHERE ctype = 'local' OR ctype = 'regional'
;

SELECT *
FROM competition
WHERE ctype = 'local' AND cdate > '2015-01-01' 
;

SELECT *
FROM skaters
WHERE sname > 'l'
;

-- String matching
SELECT *
FROM skaters
WHERE sname LIKE 'd%'
;

SELECT *
FROM skaters
WHERE sname LIKE '_e%'
;

-- Ordering ...

SELECT *
FROM skaters
ORDER BY rating
;

SELECT *
FROM skaters
WHERE age < 17
ORDER BY rating
;

SELECT *
FROM skaters
WHERE age < 17
ORDER BY age, rating
;

SELECT *
FROM skaters
WHERE age < 17
ORDER BY age DESC, rating
;

-- Aliases
SELECT sid, rating as oldrating, rating+1 as newrating
FROM skaters;

SELECT sid, rating, 'Skater' as job
FROM skaters;

SELECT sid, rating as oldrating, rating+1 as newrating
FROM skaters;

-- Limits ..
SELECT *
FROM skaters
LIMIT 2;

-- Aliases
SELECT sname, rating FROM skaters;

SELECT skaters.sname, skaters.rating FROM skaters;

SELECT s.sname, s.rating FROM skaters s;

SELECT sname, rating FROM skaters WHERE age = 10;

SELECT sname, rating, 15 maxallowedrating FROM skaters;

-- Cross Product.
SELECT * FROM skaters, participates;

SELECT sname
FROM skaters, participates
WHERE skaters.sid = participates.sid
;


SELECT *
FROM skaters s, participates p
WHERE s.sid = p.sid
;


SELECT sname
FROM skaters, participates
WHERE skaters.sid = participates.sid
  AND participates.cid = 101
;

SELECT sname
FROM skaters JOIN participates
ON skaters.sid = participates.sid
;

-- Range variable / aliases ...
SELECT *
FROM skaters s, participates p
WHERE s.sid = p.sid
;

SELECT p.sid
FROM participates p, competition c
WHERE p.cid = c.cid
  AND c.ctype = 'local'
;

SELECT p.sid
FROM participates p, competition c
WHERE p.cid = c.cid
  AND c.ctype = 'regional'
;

SELECT p.sid
FROM participates p, competition c
WHERE p.cid = c.cid
  AND c.ctype = 'local'

UNION

SELECT p.sid
FROM participates p, competition c
WHERE p.cid = c.cid
  AND c.ctype = 'regional'
;
-- Also UNION ALL ...
-- Scope of p and c aliases ?

SELECT p.sid
FROM participates p, competition c
WHERE p.cid = c.cid
  AND c.ctype = 'local'

INTERSECT

SELECT p.sid
FROM participates p, competition c
WHERE p.cid = c.cid
  AND c.ctype = 'regional'
;

-- join instead of union
SELECT p.sid
FROM participates p, competition c
WHERE p.cid = c.cid
  AND (c.ctype = 'regional' OR c.ctype = 'local') -- Same as UNION ALL
;


-- join instead of intersection. (might contain duplicates)
SELECT p1.sid
FROM participates p1, participates p2
   , competition c1, competition c2
WHERE p1.cid = c1.cid AND c1.ctype = 'local'
  AND p2.cid = c2.cid AND c2.ctype = 'regional'
  AND p1.sid = p2.sid
;


SELECT p.sid
FROM participates p, competition c
WHERE p.cid = c.cid
  AND c.ctype = 'local'

EXCEPT

SELECT p.sid
FROM participates p, competition c
WHERE p.cid = c.cid
  AND c.ctype = 'regional'
;


-- IN syntax
SELECT sid FROM participates WHERE cid = 101
;

SELECT sname FROM skaters WHERE sid IN ( 31, 58)
;


-- Subquery / Nested Query
SELECT sname
FROM skaters
WHERE sid IN (SELECT sid FROM participates WHERE cid = 101)
;

SELECT sname
FROM skaters -- Does not work number of columns do not match for in operator
WHERE sid IN (SELECT sid, sname FROM participates WHERE cid = 101)
;

SELECT sname
FROM skaters s, participates p
WHERE s.sid = p.sid AND p.cid = 101
;

SELECT sname
FROM skaters s, participates p
WHERE s.sid = p.sid AND p.cid = 103
;

SELECT sname
FROM skaters s, participates p
WHERE s.sid = p.sid AND p.cid IN (101, 103)
;


SELECT sname
FROM skaters
WHERE sid IN (SELECT sid FROM participates WHERE cid IN (101, 103))
;

SELECT sname
FROM skaters
WHERE sid IN (SELECT sid FROM participates WHERE cid IN 
			( SELECT cid FROM competition WHERE ctype='local'))
;

SELECT sname
FROM skaters
WHERE sid NOT IN (SELECT sid FROM participates WHERE cid = 101)
;


-- EXISTS, corelated subquery
SELECT s.sname
FROM skaters  s
WHERE EXISTS (
               SELECT *
               FROM participates p
               WHERE p.cid = 101 AND p.sid = s.sid
             )
;
-- IN instead of EXISTS ?


-- Top order skaters.

SELECT rating FROM skaters;

SELECT sname
FROM skaters
WHERE rating > ALL (SELECT rating FROM skaters WHERE rating < 9)
;

SELECT *
FROM skaters
WHERE rating <= ALL (SELECT rating FROM skaters)
;

SELECT *
FROM skaters
WHERE rating > ANY (SELECT rating FROM skaters)
;



