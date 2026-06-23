-- ================================================
-- 04: YEARLY TRENDS
-- ================================================

-- Content added per year
SELECT
    EXTRACT(YEAR FROM TO_DATE(date_added, 
    'Month DD, YYYY')) AS year_added,
    COUNT(*) AS titles_added
FROM netflix_titles
WHERE date_added IS NOT NULL
GROUP BY year_added
ORDER BY year_added;

-- Year-over-year growth rate
WITH yearly AS (
    SELECT
        EXTRACT(YEAR FROM TO_DATE(date_added, 
        'Month DD, YYYY')) AS yr,
        COUNT(*) AS total
    FROM netflix_titles
    WHERE date_added IS NOT NULL
    GROUP BY yr
)
SELECT
    yr,
    total,
    LAG(total) OVER (ORDER BY yr) AS prev_year,
    ROUND((total - LAG(total) OVER (ORDER BY yr)) 
    * 100.0 / NULLIF(LAG(total) 
    OVER (ORDER BY yr), 0), 1) AS yoy_growth_pct
FROM yearly
ORDER BY yr;