-- Week 4.1 - Missing data --
-- Which sites have no egg data? 
-- Intuative checks --
SELECT * FROM Bird_eggs LIMIT 10;

SELECT * FROM Site Limit 10;

-- Check row counts --
SELECT COUNT(*) FROM Site;
SELECT COUNT(DISTINCT Site) FROM Bird_eggs;

-- Method 1: NOT IN subquery --
SELECT Code FROM Site
WHERE Code NOT IN (SELECT Site FROM Bird_eggs) 
ORDER BY Code;

-- Method 2: LEFT JOIN with IS NULL --
SELECT s.Code FROM Site s
LEFT JOIN Bird_eggs e ON s.Code = e.Site
WHERE e.Site IS NULL
ORDER BY s.Code; 