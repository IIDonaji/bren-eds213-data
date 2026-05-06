-- WEEK 4.2 - Who worked with whom?--
-- Step 1
SELECT A.Site, A.Observer AS Observer_1, B.Observer AS Observer_2
FROM Camp_assignment A
JOIN Camp_assignment B
  ON A.Site = B.Site
-- Step 2
  AND (A.Start <= B.End)
  AND (A.End >= B.Start)
-- Step 3
-- WHERE A.Site = 'lkri';
  AND A.Observer < B.Observer
-- Step 4
 WHERE A.Site = 'lkri';
 
-- Bonus problem with full names --
SELECT A.Site, p1.Name AS Name_1, p2.Name AS Name_2
FROM Camp_assignment A
JOIN Camp_assignment B
  ON A.Site = B.Site
  AND (A.Start <= B.End)
  AND (A.End >= B.Start)
  AND (A.Observer < B.Observer)
JOIN Personnel AS p1 ON A.Observer = p1.Abbreviation
JOIN Personnel AS p2 ON B.Observer = p2.Abbreviation
WHERE A.Site = 'lkri'
ORDER BY Name_2;