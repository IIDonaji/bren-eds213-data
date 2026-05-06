-- Week 4.3 - Who's the culprit?--
SELECT p.Name, COUNT(*) AS Num_floated_nests
FROM Bird_nests n
JOIN Personnel p ON n.Observer = p.Abbreviation
WHERE n.Site = 'nome'
    AND n.Year BETWEEN 1998 AND 2008
    AND n.ageMethod = 'float'
    GROUP BY p.Name
    HAVING COUNT(*) = 36;

