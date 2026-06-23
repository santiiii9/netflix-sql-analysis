-- ================================================
-- 02: CONTENT TYPE ANALYSIS
-- ================================================

-- Movies vs TV Shows
SELECT
    type,
    COUNT(*) AS total,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 1) AS pct
FROM netflix_titles
GROUP BY type
ORDER BY total DESC;

-- Average movie duration
SELECT
    ROUND(AVG(CAST(REPLACE(duration, ' min', '') 
    AS INTEGER)), 0) AS avg_duration_min
FROM netflix_titles
WHERE type = 'Movie'
  AND duration LIKE '%min%';

-- TV Shows by number of seasons
SELECT
    duration AS seasons,
    COUNT(*) AS total_shows
FROM netflix_titles
WHERE type = 'TV Show'
GROUP BY duration
ORDER BY total_shows DESC
LIMIT 10;