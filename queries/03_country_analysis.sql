-- ================================================
-- 03: COUNTRY ANALYSIS
-- ================================================

-- Top 10 content-producing countries
SELECT
    TRIM(country_split.value) AS country,
    COUNT(*) AS total_titles
FROM netflix_titles,
     LATERAL UNNEST(STRING_TO_ARRAY(country, ',')) 
     AS country_split(value)
WHERE country IS NOT NULL
GROUP BY country
ORDER BY total_titles DESC
LIMIT 10;

-- Single country only (no co-productions)
SELECT
    country,
    COUNT(*) AS titles
FROM netflix_titles
WHERE country IS NOT NULL
  AND country NOT LIKE '%,%'
GROUP BY country
ORDER BY titles DESC
LIMIT 10;