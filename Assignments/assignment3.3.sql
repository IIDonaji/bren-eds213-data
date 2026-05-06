-- SQL problem-3
-- Average egg volume per nests:
CREATE TEMP TABLE Average AS
    SELECT Nest_ID, AVG(3.14/6.0 * Width * Width * Length) AS Avg_volume
        FROM Bird_eggs
        GROUP BY NEST_ID;

-- Join with Bird_nests and Species, group by species:
SELECT Scientific_name, MAX(Avg_volume) AS Max_avg_volume
FROM Bird_nests
    JOIN Average USING (Nest_ID)
    JOIN Species ON Species = Code
GROUP BY Scientific_name
ORDER BY Max_avg_volume DESC;
