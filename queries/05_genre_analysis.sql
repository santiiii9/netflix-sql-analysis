-- ================================================
-- 05: GENRE ANALYSIS
-- ================================================

-- Top 15 genres
SELECT
    TRIM(genre_split.value) AS genre,
    COUNT(*) AS total
FROM netflix_titles,
     LATERAL UNNEST(STRING_TO_ARRAY(listed_in, ',')) 
     AS genre_split(value)
GROUP BY genre
ORDER BY total DESC
LIMIT 15;

-- Most common rating per content type
SELECT
    type,
    rating,
    COUNT(*) AS total
FROM netflix_titles
WHERE rating IS NOT NULL
GROUP BY type, rating
ORDER BY type, total DESC;