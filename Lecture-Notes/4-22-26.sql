-- toy.duckdb
.table
SELECT * FROM A;
SELECT * FROM B;
-- SELF- JOIN
-- CROSS Join Review -cartision join- not default join when you dont have a relationship with two tables
SELECT * FROM A CROSS JOIN B;
-- SELECT always select columns from the out com[uted after the FROM how many column should you expect? 
SELECT acol1, acol2 FROM (SELECT * FROM A CROSS JOIN B); --recall this is nesting

-- outputs an error 
SELECT acol1, acol2, COUNT(*)
    FROM (SELECT * FROM A CROSS JOIN B)
    GROUP BY acol1; --doesnt know what you mean by groupby
-- Said to use 3 row per group
SELECT acol1, ANY_VALUE(acol2), COUNT(*)
    FROM (SELECT * FROM A CROSS JOIN B)
    GROUP BY acol1;
-- will return two counts
SELECT acol1, ANY_VALUE(acol2), COUNT(bcol3)
    FROM (SELECT * FROM A CROSS JOIN B)
    GROUP BY acol1;
-- USING a condition
SELECT * FROM A JOIN B ON acol1 < bcol1;
-- INNER our OUTER JOIN
SELECT * FROM Student; 
SELECT * FROM House;
--INNER 
SELECT * FROM Student AS S JOIN House AS H ON  S.House_ID = H.House_ID;
-- same as above but shortcut Request the same column names
SELECT * FROM Student JOIN House USING (House_ID); --columns wraped in ()
--OUTER JOINs a NULL row bc no hugglepuff 
SELECT * FROM Student FULL JOIN House USING (House_ID);
-- Left Join: joins based on left table in this case student 
 SELECT * FROM Student LEFT JOIN House USING (House_ID);
-- Similar to FULL join tales the table on right in this case House
 SELECT * FROM Student RIGHT JOIN House USING (House_ID);
 
 --CROSS how many rows will you get 3 student 4 house 12 rows
 SELECT * FROM Student CROSS JOIN House;
 --- more common to use inner join 

 -- How to create a table in a database
 duckdb database.duckdb 
 .table 

 -- add table
 CREATE TABLE Snow_cover (
    Site VARCHAR NOT NULL,
    Year INTEGER NOT NULL CHECK (Year BETWEEN 1990 AND 2018),
    Date DATE NOT NULL,
    Plot VARCHAR NOT NULL,
    Location VARCHAR NOT NULL,
    Snow_cover REAL CHECK (Snow_cover BETWEEN 0 AND 130),
    Water_cover REAL CHECK (Water_cover BETWEEN 0 AND 130),
    Land_cover REAL CHECK (Land_cover BETWEEN 0 AND 130),
    Total_cover REAL CHECK (Total_cover BETWEEN 0 AND 130),
    Observer VARCHAR,
    Notes VARCHAR,
    PRIMARY KEY (Site, Plot, Location, Date),
    FOREIGN KEY (Site) REFERENCES Site (Code)
);
-- will give an empt table bc we havent added the data
SELECT * FROM Snow_cover;
-- add data
COPY Snow_cover FROM "../ASDN_csv/snow_survey_fixed.csv" (header TRUE, nullstr "NA");
-- check
SELECT * FROM Snow_cover LIMIT 5;
--- creating a Temporary table
CREATE TEMP TABLE Camp_assignment_copy AS
   SELECT * FROM Camp_assignment; 

.table

--Refresh
SELECT * FROM Camp_assignment_copy LIMIT 5;

SELECT * FROM Personnel LIMIT 5;

SELECT Year, Site, NAME 
    FROM Camp_assignment_copy JOIN Personnel ON Observer = Abbreviation;

-- Views
CREATE VIEW Camp_personnel_v AS
   SELECT Year, Site, Name 
   FROM Camp_assignment_copy JOIN Personnel ON Observer = Abbreviation;
.table
.schema 
-- list all views in DuckDB
SELECT view_name FROM duckdb_views;
-- Danger Zone
SELECT * FROM Camp_assignment_copy WHERE Site == 'bylo';
--checking something not sure?
SELECT * FROM Camp_personnel_v LIMIT 10