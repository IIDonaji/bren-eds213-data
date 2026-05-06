.table
# recap from Monday
# keyword are ALL CAPS, we did queries such as
SELECT DISTINCT Location
    FROM Site
    ORDER BY Location
    LIMIT 3;

-- FILTERING
-- Looks just like in R or Python
SELECT * FROM Site WHERE AREA < 200;
SELECT * FROM Site WHERE < 200 AND Latitude > 60; -- Spell out AND, OR
-- older-style operators
SELECT * FROM Site WHERE Code != 'iglo';
SELECT * FROM Site WHERE Code <> 'iglo'; -- older style 
-- expression: the usal operators, plus lots function like regex

## EXPRESSIONS
SELECT Site_name, AREA *2.47 FROM Site;
-- Very handy to give a name to columns
SELECT Site_name, AREA*2.47 AS Area_acrs FROM Site;

-- string concatenation
-- old style operator double pike || is concatenation
SELECT Site_name || ',' || Location AS Full_name FROM Site;
-- there are probably other operators

-- BTW, you have another fancy calculator!
SELECT 2+2; 

## AGGREGATION & Grouping
-- How many rows are on this table?
SELECT COUNT(*) FROM Bird_nests;
-- the "*" in the above means, just count rows
-- we can also ask, how non-null values are there? 
SELECT COUNT(*) FROM Species;
SELECT COUNT(Scientific_name) FROM Species;

-- very handy to count number of distinct things
SELECT COUNT(*) FROM Site;
SELECT COUNT(DISTINCT Location) FROM Site; -- number of disticnt locations
SELECT COUNT(Location) FROM Site; -- number of non-null location
-- reminder from MOnday:
SELECT DISTINCT Location FROM Site;

-- The usual aggregation functions
SELECT AVG(Area) FROM Site;
SELECT MIN(Area) FROM Site;

-- This won't work, but suppose we want to list 7 locations
-- that occur in the site table, along with the average areas
SELECT Location, AVG(Area) FROM Site; -- wonts work

-- need to enter grouping
SELECT Location, AVG(Area) FROM Site GROUP BY Location; 
-- similar for counting
SELECT Location, COUNT(*) FROM Site GROUP BY Location;
-- for comparison
-- Site %>% group_by(Location) %>% summarize(count=n())

-- we can site have WHERE clauses! 
SELECT Location, COUNT(*)
    FROM Site
    WHERE Location LIKE '%CANADA' -- old style pattern-matching, NOT full regex, just wildcard (%)
    GROUP BY Location; 
-- the order of the clauses reflect the order of the processing
-- But, what if you want to do some filtering on your group, i.e., *after* you've done the grouping?
SELECT Location, MAX(Area) AS MAX_area
    FROM Site
    WHERE Location LIKE '%Canada'
    GROUP BY Location
    HAVING Max_area > 200
    ORDER BY Max_area DESC;

## RELATIONAL ALGEBRA
-- Everything is a table
-- Evert query, every statement actually, returns a table
SELECT COUNT(*) FROM Site;
-- you can save tables, you an nest queries
SELECT COUNT(*) FROM ( SELECT COUNT(*) FROM Site );

-- you an nest queries 
SELECT DISTINCT Species FROM Bird_nests;
    SELECT Code FROM Species
    WHERE Code NOT IN ( SELECT DISTINCT Species FROM Bird_nests); -- (things in here run first)

## NULL processing
-- NULL is infectious
-- IN a table, NULL means no data, the absence of value
-- In an expression, NULL means unknown
SELECT count(*) FROM Bird_nests WHERE ageMethod = 'float';
SELECT count(*) FROM Bird_nests WHERE ageMethod <> 'float';

-- This won't work but you will try it by accidents anways
SELECT COUNT(*) FROM Bird_nests WHERE ageMethod IS NULL;
-- THE ONLY WAY
SELECT COUNT(*) FROM Bird_nests WHERE ageMethod IS NULL;
SELECT COUNT(*) FROM Bird_nests WHERE ageMethod IS NOT NULL;
-- so-called "tri-value" logic

-- JOINS
-- 90% of the time, we'll join tables based on a foreign key relationship
SELECT * FROM Camp_assignment;

SELECT * FROM Camp_assignment JOIN Personnel
    ON Observer = Abbreviation
    LIMIT 10;

-- JOIN is a very general apperation, can be applied to any tables, with any expression joining them
-- fundamentally, joins always start from Cartesian product of the table
-- CRASS JOIN = Cartesian product
SELECT * FROM Site CROSS JOIN Species;
SELECT COUNT(*) FROM Site;
SELECT COUNT(*) FROM Species;
SELECT 99*16; 

-- *any* condition can be expression, we have complete freedom here

-- but when there *is* a foregin key relationship, then 
-- what happens?
-- the result is the same as the table with the foregin key but augmented with additonal columns. 
SELECT * FROM Bird_nests BN JOIN Species S
    ON BN.Species = S.Code
    LIMIT 5;
SELECT COUNT(*) FROM Bird_nests BN JOIN Species S
    ON BN.Species = S.Code;

-- Table aliases
-- Sometimes, if column names are ambiguous where they're coming from,
-- need qualify them
SELECT * FROM Bird_nests JOIN Species
    ON Bird_nests.Species = Species.Code;
-- Same, using a table alias
SELECT * FROM Bird_nests AS BN JOIN Species AS Same 
    ON BN.Species = S.Code;
-- even more compact, leave out the "AS"