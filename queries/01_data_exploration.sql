-- ================================================
-- 01: DATA EXPLORATION
-- Netflix Content Analysis
-- Author: Santi Aulia Dewi
-- ================================================

-- Total number of titles
SELECT COUNT(*) AS total_titles
FROM netflix_titles;

-- Split by content type
SELECT
    type,
    COUNT(*) AS total,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 1) AS percentage
FROM netflix_titles
GROUP BY type
ORDER BY total DESC;

-- Check for null values
SELECT
    SUM(CASE WHEN title      IS NULL THEN 1 ELSE 0 END) AS null_title,
    SUM(CASE WHEN director   IS NULL THEN 1 ELSE 0 END) AS null_director,
    SUM(CASE WHEN country    IS NULL THEN 1 ELSE 0 END) AS null_country,
    SUM(CASE WHEN date_added IS NULL THEN 1 ELSE 0 END) AS null_date_added,
    SUM(CASE WHEN rating     IS NULL THEN 1 ELSE 0 END) AS null_rating,
    SUM(CASE WHEN duration   IS NULL THEN 1 ELSE 0 END) AS null_duration
FROM netflix_titles;

-- Preview first 10 rows
SELECT *
FROM netflix_titles
LIMIT 10;