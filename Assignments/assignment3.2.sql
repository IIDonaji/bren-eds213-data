-- SQL Problem-2
-- Part-1 Whats wrong with the query
SELECT Site_name, MAX(Area) FROM Site;

-- The problem with this query is a mismatch between aggregated and non aggregated columns. 
-- MAX(Area) collapses the entire table down to one row, the maxiumum value. 
-- Site_name is not aggregatd, there ar many site names, one per row. 
-- The databse has no way to know which site name to return alongside that single max value. 
-- It can't pair them meaningfully, so it objects to performe the query. 

-- Part-2
SELECT Site_name, Area
FROM Site
ORDER BY Area DESC
LIMIT 1;

-- Part-3 
SELECT Site_name, Area 
FROM Site 
WHERE Area = (SELECT MAX(Area) FROM Site);

