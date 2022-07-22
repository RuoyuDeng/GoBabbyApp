-- Try to write SQLs on your own, use this as a reference when you are not sure
-- how to run certain queries.

SELECT *
FROM skaters
;

SELECT count(*)
FROM skaters
;

INSERT INTO Skaters VALUES(99,'johnny', 7, 13);

SELECT rating
FROM skaters
;

SELECT count(rating)
FROM skaters
;

SELECT count(DISTINCT rating)
FROM skaters
;

SELECT age
FROM skaters
;


SELECT AVG(age)
FROM skaters
;

SELECT age
FROM skaters
WHERE rating = 9
;

SELECT AVG(age)
FROM skaters
WHERE rating = 9
;

SELECT AVG(age)
FROM 
( -- Here "t" is a derived table
 SELECT age
 FROM skaters
 WHERE rating = 9
) t
;

SELECT AVG(age), COUNT(*)
FROM skaters
WHERE rating = 9
;

SELECT SUM(rating)
FROM skaters
;

SELECT MAX(rating), MIN(rating)
FROM skaters
;

-- sub query is an aggregation but the outer query is not.
SELECT sname
FROM skaters
WHERE rating = (SELECT MAX(rating) FROM skaters)
;

-- ERROR !!
SELECT sname
FROM skaters
WHERE rating = MAX(rating)
;

-- Grouping ...

SELECT AVG(age)
FROM skaters
GROUP BY rating
;

SELECT  rating, AVG(age), COUNT(*)
FROM skaters
WHERE age > 4
GROUP BY rating
HAVING COUNT(*) >= 2
;

SELECT * FROM SKATERS
LIMIT 0;

SELECT rating, AVG(age), MIN(age)
, MAX(age), COUNT(*), SUM(1)
FROM skaters
GROUP BY rating
;

-- ERROR !!
SELECT sname, rating, AVG(age)
FROM skaters
GROUP BY rating
;


SELECT rating, AVG(age) as avgage
FROM skaters
WHERE rating > 6
GROUP BY rating
ORDER BY avgage
;


SELECT rating, AVG(age)
FROM skaters
WHERE age > 10
GROUP BY rating
ORDER BY rating
;


-- Error !!
SELECT rating, AVG(age)
FROM skaters
GROUP BY rating
WHERE AVG(age) > 11
;



SELECT rating, MIN(age) --, COUNT(*)
FROM skaters
GROUP BY rating
HAVING COUNT(*) >= 2
;

SELECT rating, AVG(age)
FROM skaters
GROUP BY rating
HAVING AVG(age) > 11
;


SELECT rating, AVG(age)
FROM skaters
WHERE rating < 10
GROUP BY rating
HAVING AVG(age) > 11
;

SELECT rating, age, count(*)
FROM skaters
GROUP BY rating, age
;

SELECT c.cid, p.sid
FROM competition c, participates p
WHERE c.cid = p.cid
;

SELECT c.cid, COUNT(*)
FROM competition c, participates p
WHERE c.cid = p.cid AND c.ctype = 'local'
GROUP BY c.cid
;

SELECT c.cid, COUNT(*) AS numskaters
FROM competition c, participates p
WHERE c.cid = p.cid
GROUP BY c.cid
;

SELECT c.cid, COUNT(*) AS numskaters
FROM competition c, participates p
WHERE c.cid = p.cid
AND c.cid IN ( 101,104)
GROUP BY c.cid
;

SELECT cid, COUNT(*) AS numskaters
FROM
(
  SELECT c.cid, p.sid
  FROM competition c, participates p
  WHERE c.cid = p.cid
  AND c.cid IN ( 101,104)
) t2
GROUP BY cid
;

SELECT c.cid, COUNT(*) AS numskaters
FROM competition c, participates p
WHERE c.cid = p.cid
GROUP BY c.cid
HAVING COUNT(*) >= 2
;

SELECT AVG (S2.age)
FROM Skaters S2
GROUP BY rating
;


-- Error !! no nesting of AGG operators.
SELECT  MIN (AVG (S2.age))
FROM Skaters S2
GROUP BY rating
;



-- Use derived tables OR Views
SELECT MIN(avgage)
FROM
(
  SELECT  AVG (S2.age) AS avgage
  FROM Skaters S2
  GROUP BY rating
)X
;

SELECT   DISTINCT s.sid, s.sname
FROM  skaters s, participates p
WHERE s.sid = p.sid
;

CREATE VIEW activeSkaters (sid,sname) AS
SELECT DISTINCT s.sid, s.sname
FROM  skaters s, participates p
WHERE s.sid = p.sid
;

SELECT *
FROM activeSkaters
WHERE sname LIKE 'd%'
;

DROP VIEW activeSkaters;

CREATE VIEW avgSkaterAges(rating, avgage) AS
SELECT  rating, AVG (S2.age)
FROM Skaters S2
GROUP BY rating
;

--insert (10, 15)
--select sid, sname
--from skaters
--where sage > 10

SELECT * FROM avgSkaterAges;

SELECT MIN(avgage) FROM avgSkaterAges;

DROP VIEW avgSkaterAges;

-- NULL ....  slides

INSERT INTO skaters VALUES(72, 'katie', NULL, 12);
INSERT INTO skaters VALUES(83, 'Jack', NULL, 11);

SELECT * FROM skaters
ORDER BY rating
;

SELECT sname, rating, rating+1 newrating  
FROM skaters;

SELECT * FROM skaters WHERE rating > 5;

SELECT * FROM skaters WHERE NOT rating > 5;

-- Error !!
SELECT * FROM skaters WHERE rating = NULL;

SELECT * FROM skaters WHERE rating IS NULL;

SELECT * FROM skaters WHERE rating IS NOT NULL;


SELECT sname, rating
, COALESCE(rating, 0) modrating,
COALESCE(rating, 0)+1 newrating
FROM skaters;


SELECT sname, rating
  ,CASE WHEN rating IS NULL THEN 0 ELSE rating END modrating
FROM skaters;

SELECT sname, rating
  ,CASE WHEN rating = 10 THEN rating
	    WHEN rating IS NULL THEN 1
		ELSE rating + 1
	 END modrating
FROM skaters;

-- 3 Valued Logic (slides)

SELECT rating FROM skaters;

-- NULLs are considered same for distnct
SELECT distinct rating FROM skaters;

SELECT rating, count(*)
FROM skaters
GROUP BY rating
;


SELECT count(*) rating FROM skaters;

SELECT count(rating) rating FROM skaters;

SELECT count(distinct rating) rating FROM skaters;

SELECT AVG(rating) FROM skaters;

SELECT AVG(rating),
 AVG(age)
 ,SUM(rating), SUM(age), COUNT(*)
  FROM skaters;


----- INNER JOINS

SELECT s.sid, s.sname, p.cid, p.rank
FROM skaters s, participates p
WHERE s.sid = p.sid
ORDER BY s.sid, p.cid
;

SELECT s.sid, s.sname, p.cid, p.rank
FROM skaters s INNER JOIN participates p
  ON s.sid = p.sid
ORDER BY s.sid, p.cid
;

SELECT s.sid, s.sname, p.cid, p.rank
FROM skaters s INNER JOIN participates p
  ON s.sid = p.sid
  AND p.cid IN ( 101, 103 )
ORDER BY s.sid, p.cid
;

SELECT s.sid, s.sname, p.cid, p.rank
FROM skaters s INNER JOIN participates p
  ON s.sid = p.sid
WHERE p.cid IN ( 101, 103 )
ORDER BY s.sid, p.cid
;

SELECT s.sid, s.sname, p.cid, p.rank
FROM skaters s LEFT OUTER JOIN participates p
  ON s.sid = p.sid
ORDER BY s.sid, p.cid
;

SELECT s.sid, s.sname, p.cid, p.rank
FROM participates p RIGHT OUTER JOIN  skaters s
  ON s.sid = p.sid
ORDER BY s.sid, p.cid
;

SELECT * FROM skaters ORDER BY sid;

SELECT * FROM ourskaters ORDER BY sid;

SELECT s.sid, s.sname, s.rating, s.age, o.sid
     , o.sname, o.rating, o.age
FROM skaters s FULL OUTER JOIN ourskaters o
  ON s.sid = o.sid
ORDER BY s.sid, o.sid
;

-- With Clause

WITH partinfo(sid, sname, age, rank, cid) AS
(  
	SELECT S.sid, S.sname, S.age, P.rank, P.cid
	FROM skaters S
		INNER JOIN participates P
		ON S.sid = P.sid
)
SELECT sid, sname, cid
FROM partinfo
WHERE age > 7;


-- Derived tables
SELECT sid, sname, cid
FROM
(
	SELECT S.sid, S.sname, S.age, P.rank, P.cid
	FROM skaters S
	INNER JOIN participates P
	ON S.sid = P.sid
)partinfo
WHERE age > 7;

