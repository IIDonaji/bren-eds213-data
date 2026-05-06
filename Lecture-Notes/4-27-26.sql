-- Data Management --
-- Recap: VIEW & TEMP TABLE 
 -- Views --
 -- looks like tables 
 -- stored in the database - lives until its dropped
 -- executed each time it is referenced, not data is stored
 -- handy way to make SQL easier/nicer to work with.
 -- ergo, a view similar to a function in a programming language
 -- Can be used to subset attributes from a table that might store sensitive data 
 -- Example: Suppose we always want to see species names, not the codes, make a view query
 CREATE VIEW Nest_view AS -- View name
    SELECT Book_page, Year, Site, Nest_ID, Scientific_name, Observer -- the columns we want 
    FROM Bird_nests JOIN species
    ON Species = Code; 
-- Out puts a table like Bird_nests but with scientific names for the species column
SELECT * FROM Nest_view LIMIT 1;
-- Use as usal
-- Recall: when using GROUP_BY, every column in SELECT must either be the grouped column or wrapped in aggregate functions. SQL needs to know what to do with all the multi rows
SELECT Nest_ID, ANY_VALUE(Scientific_name), COUNT(*) AS Num_eggs -- COUNT # of egg rows that exist for each nest. Named Num_eggs for readability 
-- ANY_VALUE(): An aggergate that gives a non-aggergated column a rule for grouping "just pick one"
    FROM Nest_view JOIN Bird_eggs
    USING (Nest_ID) -- Shorthand for ON Nest_View.Nest_ID = Bird_eggs.Nest_ID
    GROUP BY Nest_ID; -- collapses all rows witht he same nest into one row, so you get one result per nest.
    
-- TEMP tables- lives only during the session
-- a regular table that gets deleted automatically when your database connection closes 
-- persist for the entire session and can be use across multi queries, take up memorie 
-- runs once and stores the result, subsequent queries hit the stored data not the original tables

-- WITH clause (CTE) Common Table Expression: creates a view for a single statement
-- WITH helps quary by breaking it down into logical steps 
-- only exist for that one statement and its not stored if you want to save use TEMP
-- Example take previous table, use its input to another query
WITH x AS ( -- WITH defines a temp names called x 
  SELECT Nest_ID, ANY_VALUE(Scientific_name) AS Scientific_name, -- SELECT
    COUNT(*) AS Num_eggs
    FROM Nest_view JOIN Bird_eggs
    USING (Nest_ID)
    GROUP BY Nest_ID
  )
SELECT Scientific_name, AVG(Num_eggs) AS Avg_num_eggs FROM x
GROUP BY Scientific_name;

-- SET OPERATIONS --
-- treat query like mathematical sets and combines them
-- UNION, INTERSECT, EXCEPT: Rule for all, both queries must have the same number of columns and compatible data types. SQL doesnt check column names-just shape.
-- last one is set difference
-- these are set operatioons, so UNION elimates duplicates
-- to preserve duplicate rows, UNION ALL
-- UNION - combines both results, removes duplicates
-- First create a table of all bird nests and egg counts including nests without egg data
SELECT Nest_ID, COUNT(Egg_num) as Num_eggs
  FROM Bird_nests LEFT JOIN Bird_eggs
  USING (Nest_ID)
  GROUP BY Nest_ID;

-- using UNION alternative to LEFT JOIN
-- first query nest that have egg data
SELECT Nest_ID, COUNT(*) AS Num_eggs -- print eggs per nest, only nest that appear in Bird_eggs show up here, nest with no eggs are absent. 
  FROM Bird_eggs
  GROUP BY Nest_ID

UNION -- stacks the two results together into one list: Can also just use lEFT JOIN 

-- second query nest with no egg data
SELECT Nest_ID, 0 AS Num_eggs -- 0 hardcodes 0 as the egg count sine we know there are none
  FROM Bird_nests -- start from the full list of nests
  WHERE Nest_ID NOT IN (SELECT DISTINCT Nest_ID FROM Bird_eggs); -- filters to only nests that dont appear in BIrd_eggs

-- EXCEPT
-- Example of EXCEPT: 3rd way of getting species without nest data
-- First method WHERE CLAUSE- WHERE NOT IN (subquery)- filters Species table to only codes not in the list
SELECT Code FROM Species
  WHERE Code NOT IN (SELECT DISTINCT Species FROM Bird_nests); -- (...) builds a list of every species code that has a nest 

-- Second: Outer JOIN: RIGHT JOIN
SELECT Species, Code
  FROM Bird_nests RIGHT JOIN Species -- keeps every row from the right table (species) even if there's no match in Bird_nests columns return as NULL
  ON Species = Code
  WHERE Species IS NULL; -- filter only those unmatched rows, i.e. species with no nest
  -- trick here is using NULL as a signal for no match found

-- Third - EXCEPT - directly maps in plain English 
SELECT Code FROM Species -- 1st quary all species codes
  EXCEPT -- subtract the second from the first
  SELECT DISTINCT Species FROM Bird_nests; -- 2nd query speces codes that have nests

-- DATA MANAGEMENT STATEMENTS
-- SQL isnt just SELECT you can also modify data and strucutre 
-- Main Statements: UPDATE, DELETE, ALTER, and DROP.
-- Check first 10 rows of the Bird_nests tables
SELECT * FROM Bird_nests LIMIT 10;
-- UPDATE change existing data
UPDATE Bird_nests
  SET floatAge = 4.5, ageMethod = 'float' -- SET secifies which columns to change and what values to set
  WHERE Nest_ID = '14HPE1'; -- WHERE targets specific rows. Without it, every row gets updated


--DELETE is similar
---Oops, what happens when accidentally do?:
---UPDATE Bird_nests SET floatAge = 4.5, ageMethod = ‘float’;
---There’s no UNDO in databases
--In this class we can recover using git:
--D .exit
-- git restore database.duckdb
-- duckdb database.duckdb
-- Note: But in general, won’t be a possibility, databases not typically under git control, usually stored on a server somewhere.
-- DELETE remove rows
-- DELETE FROM ..
--- WHERE ... = "..";
-- same danger as UPDATE, leaves off WHERE and you wipe the enie table 

-- Strategies to avoid catastrophes
-- Just subconsciouly be careful, like holding a kitchen knife
-- Do SELECT first, then replace SELECT with DELETE <- allows inspection of what’s about to be deleted
--Put comment in front: – DELETE FROM …, then remove comment
-- Tweak table name, put x in front, then remove
-- Create a temporary table (with the relevant subset when large table)