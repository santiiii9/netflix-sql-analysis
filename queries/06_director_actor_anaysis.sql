-- ================================================
-- 06: DIRECTOR & ACTOR ANALYSIS
-- ================================================

-- Top 10 most featured directors
SELECT
    director,
    COUNT(*) AS total_titles
FROM netflix_titles
WHERE director IS NOT NULL
  AND director NOT LIKE '%,%'
GROUP BY director
ORDER BY total_titles DESC
LIMIT 10;

-- Directors with both Movies AND TV Shows
SELECT
    director,
    COUNT(DISTINCT type) AS content_types,
    STRING_AGG(DISTINCT type, ', ') AS types
FROM netflix_titles
WHERE director IS NOT NULL
  AND director NOT LIKE '%,%'
GROUP BY director
HAVING COUNT(DISTINCT type) = 2
ORDER BY director
LIMIT 15;