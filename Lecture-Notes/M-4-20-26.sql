
-- ASDN databse
duckdb database.duckdb
-- TRi-Value logic
SELECT COUNT(*) FROM Bird_nests
  WHERE floatAge < 7 OR floatAge >= 7;

-- Nesting queries for more complex analysis
-- SQL query is a table
-- SELECT COUNT(*) 
-- In this case we get a Bird_nest table with distinct species from there it makes a table with species columns where code is not in birds-nest
SELECT * FROM Species WHERE
  Code NOT IN (SELECT DISTINCT Species FROM Bird_nests);

-- Which site are located in Canada and have an area larger than 200?
SELECT Location, MAX(Area) AS Max_area
  FROM Site
   --- % Simple form of pattern mathing-- 
  WHERE Location LIKE '%Canada'-- WHERE filters rows
  GROUP BY Location
  HAVING Max_area > 200; -- HAVING filter data on condition in combination of GROUP BY
--Lets pretend that SQL didnt have a HAVING clause. Could we somehow get the saem functionality?
--Let's go back to the example where we used a HAVING clause

--- As a reminder, the Site table:
SELECT * FROM Site LIMIT 5;

-- Nesting Clause imaagen no HAVING clause
SELECT * FROM
    (SELECT Location, MAX(Area) AS Max_area
        FROM Site
        WHERE Location LIKE '%Canada' 
        GROUP BY Location)
        WHERE Max_area > 200;

-- Switch to toy.duckdb
--In somde databases, to do a Cartesian prodcut you would just...
SELECT * FROM A;
SELECT * FROM B;

-- Here's what the Cartesian product looks like: 9 rows and 5 columns
SELECT * FROM A CROSS JOIN B;

-- Let's a join conditon, which can be *any* expression! 

SELECT * FROM A JOIN B ON acol1 < bcol1;
-- This is what's reffered to as an INNER JOIN 
SELECT * FROM A INNER JOIN B ON acol1 < bcol1;
-- Right JOIN
SELECT * FROM A RIGHT JOIN B ON acol1 < bcol1;
-- LEFT Join
SELECT * FROM A LEFT JOIN B ON acol1 < bcol1;
-- Outer join: We're addding rows from one table that never got matched. 
-- Just for completeness (this is way more rare that you would want to do this) OUTER JOIN:
SELECT * FROM A FULL OUTER JOIN B ON acol1 < bcol1;

--Now, joining on a foreign key relationship is way more common 
.schema
---Look at data first

SELECT * FROM House;
SELECT * FROM Student;

--Typical thing to do: by defualt inner join
SELECT * FROM Student S JOIN House H ON S.House_ID = H.House_ID;

--As an aside, the above without aliases:
SELECT * FROM Student JOIN House ON Student.House_ID = House.House_ID

--One nice benefit of joining on a column that has the same name (i.e, House_ID here)
is you can use USING clause

SELECT * FROM Student JOIN House USING (House_ID);


--For better viewing:
.mode line

SELECT * FROM Bird_eggs LIMIT 1;
SELECT * FROM Bird_eggs JOIN Bird_nest USING (Nest_ID) LIMIT 1:
SELECT COUNT(*) FROM Bird_eggs JOIN Bird_nest USING (Nest_ID);
.mode duckbox

---Import point!! Ordering is assuredly lost doing a JOIN, So don't sat this:
--Ordering should always and only be the very last thing

SELECT * FROM  
    (SELECT * FROM Bird_eggs ORDER BY Width)
    JOIN Bird_nest
    USING (Nest_ID); 

--Gotcha with DuckDB... it's not as smart as some other databses

SELECT Nest_ID, COUNT(*)
    FROM Bird_nests JOIN Bird_eggs USING (Nest_ID)
    GROUP BY Nest_ID;

---Some databases allow you to say: in this case should give an error

SELECT Nest_ID, Species, COUNT(*)
    FROM Bird_nests JOIN Bird_eggs USING (Nest_ID)
    GROUP BY Nest_ID;

SELECT Nest_ID, Species, Egg_num, Width, Length FROM
    Bird_eggs JOIN Bird_nests USING (Nest_ID)
    ORDER BY Nest_ID, Egg_num
    LIMIT 10;

--Can two species inhabit the same nest?
.table Bird_nests 


