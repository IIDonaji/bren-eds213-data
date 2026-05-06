# To verify that we have the "right" dtabse open, look what tables are in the databsed:
. table
# To see the Duckdb-specific commands, do this: duckdb database.duckdb make sure your in the correct file bath file database
.help
.help mode
# USe .exit to exit, or Ctrl D
.exit
# In SQL, comments are delimited with --
-- . table --- list tables
-- .shema -- lists the whole scema
.schema
-- Getting help on SQL: Look at the "railroad" diagrams in SQLite
-- check out https://sqlite.org/lang.html

-- our first quey
-- The * means all columns; all rows are implied because we didn't specify a WHERE clause
SELECT * FROM Species;

-- A couple gotchas
-- 1. Dont forget the closing semicolon, DuckDB will wait for it forever
-- 2. Watch for missing closing quotes

-- To see just a few rows:
SELECT * FROM Species LIMIT 5;
-- Can also "page" through the rows
SELECT Code, Scientific_name FROM Species;

-- Another handy query to explore data: 
SELECT Species FROM Bird_nests;
SELECT DISTINCT Species FROM Bird_nests; 

-- Can also get distinct pairs of tuples that occur
SELECT DISTINCT Species, Observer FROM Bird_nests;

-- CAn ask that the results be ordered
SELECT Scientific_name FROM Species;
SELECT Scientific_name FROM Species ORDER BY Scientific_name; 

SELEC * FROM Speceis; 

-- The default ordering (which is undefined) can be subtle
SELECT DISTINCT Species FROM Bird_nests;
SELECT DISTINCT Species FROM Bird_nests LIMIT 3; 

-- IN-class challenge:
-- Select distinct locations from the Site table; are they in order? If not, order them.
SELECT DISTINCT Location FROM Site;
SELECT DISTINCT Location FROM Site ORDER BY Location; 
-- Does adding a limit apply after the results are ordered or before?
--  If you do not specify an ORDER BY clause, the database does not guarantee the order of the rows returned when using LIMIT.
-- If you want predictable results, always include an ORDER BY clause before applying LIMIT.


