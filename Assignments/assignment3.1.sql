-- SQL Problem-1 
--Create table -> insert data -> run AVG -> explain results
-- Part-1 Experiemnt
-- Create a temp table with a REAL column
CREATE TEMP Table mytable(val REAl);

-- Insert mutiple rows at once (Yes, can insert multi rows)
INSERT INTO mytable VALUES (10), (20), (30), (NULL);
-- Check what's in there
SELECT * FROM mytable;
-- Experiment
SELECT AVG(val) FROM mytable;

-- Results
-- AVG ignores NULLS entirely. It computes (10 + 20 + 30) / 3 =20.0, not (10 + 20 + 30) / 4 = 15.0. 
-- The NULL row doesn't factor into either the sum or the count. 

-- Part-2 Which Manual Average is Correct?
SELECT SUM(val)/ COUNT(*) FROM mytable;
-- COUNT(*) counts all rows, including the NULL one, so you get 60/4 =15.0, which is wrong
SELECT SUM(val)/COUNT(val) FROM mytable;
-- COUNT(val) counts only non_NULL values in that column, so you get 60/3 = 20.0, matching AVG
-- Note; COUNT(*) = rows, COUNT(column) = non-null values n that columns. Since AVG ignores NULL, you must use COUNT(col) to replicate its behavior. 
DROP TABLE mytable;


