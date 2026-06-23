# 🎬 Netflix Content Analysis — SQL Project

**Tools:** PostgreSQL · SQL · Excel  
**Dataset:** [Netflix Movies and TV Shows — Kaggle](https://www.kaggle.com/datasets/shivamb/netflix-shows)  
**Dataset Size:** 8,807 titles | 12 columns | 2008–2021

---

## 📌 Problem Statement

Netflix has grown into one of the largest content libraries in the world.
This project explores the dataset to answer key business questions:

- What type of content dominates Netflix — Movies or TV Shows?
- Which countries produce the most content on Netflix?
- How has content volume changed year over year?
- What are the most common genres and ratings?
- Who are the most featured directors and actors?

---

## 📁 Repository Structure

```
netflix-sql-analysis/
├── README.md
├── data/
│   └── netflix_titles.csv          ← raw dataset from Kaggle
├── queries/
│   ├── 01_data_exploration.sql
│   ├── 02_content_type_analysis.sql
│   ├── 03_country_analysis.sql
│   ├── 04_yearly_trends.sql
│   ├── 05_genre_analysis.sql
│   └── 06_director_actor_analysis.sql
└── results/
    └── key_findings.md
```

---

## 🔍 Key Findings

| # | Question | Finding |
|---|----------|---------|
| 1 | Content split | 69% Movies, 31% TV Shows |
| 2 | Top country | United States leads with 36% of all content |
| 3 | Peak year | 2019 had the highest number of content additions |
| 4 | Top rating | TV-MA is the most common rating (36% of titles) |
| 5 | Top genre | International Movies is the #1 genre on the platform |

---

## 🗄️ SQL Queries

### 1. Data Exploration — Overview

```sql
-- Total number of titles
SELECT COUNT(*) AS total_titles
FROM netflix_titles;

-- Split by type
SELECT
    type,
    COUNT(*)                                        AS total,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 1) AS percentage
FROM netflix_titles
GROUP BY type
ORDER BY total DESC;

-- Check for nulls
SELECT
    SUM(CASE WHEN title       IS NULL THEN 1 ELSE 0 END) AS null_title,
    SUM(CASE WHEN director    IS NULL THEN 1 ELSE 0 END) AS null_director,
    SUM(CASE WHEN country     IS NULL THEN 1 ELSE 0 END) AS null_country,
    SUM(CASE WHEN date_added  IS NULL THEN 1 ELSE 0 END) AS null_date_added,
    SUM(CASE WHEN rating      IS NULL THEN 1 ELSE 0 END) AS null_rating,
    SUM(CASE WHEN duration    IS NULL THEN 1 ELSE 0 END) AS null_duration
FROM netflix_titles;
```

---

### 2. Content Type Analysis

```sql
-- Movies vs TV Shows count and percentage
SELECT
    type,
    COUNT(*)                                              AS total,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 1)   AS pct
FROM netflix_titles
GROUP BY type
ORDER BY total DESC;

-- Average movie duration (minutes)
SELECT
    ROUND(AVG(CAST(REPLACE(duration, ' min', '') AS INTEGER)), 0) AS avg_duration_min
FROM netflix_titles
WHERE type = 'Movie'
  AND duration LIKE '%min%';

-- TV Shows by number of seasons
SELECT
    duration        AS seasons,
    COUNT(*)        AS total_shows
FROM netflix_titles
WHERE type = 'TV Show'
GROUP BY duration
ORDER BY total_shows DESC
LIMIT 10;
```

---

### 3. Country Analysis

```sql
-- Top 10 content-producing countries
SELECT
    TRIM(country_split.value)   AS country,
    COUNT(*)                    AS total_titles
FROM netflix_titles,
     LATERAL UNNEST(STRING_TO_ARRAY(country, ',')) AS country_split(value)
WHERE country IS NOT NULL
GROUP BY country
ORDER BY total_titles DESC
LIMIT 10;

-- Countries with most original content (single country only)
SELECT
    country,
    COUNT(*) AS titles
FROM netflix_titles
WHERE country IS NOT NULL
  AND country NOT LIKE '%,%'
GROUP BY country
ORDER BY titles DESC
LIMIT 10;
```

---

### 4. Yearly Trends

```sql
-- Content added per year (trend analysis)
SELECT
    EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY'))  AS year_added,
    COUNT(*)                                                   AS titles_added
FROM netflix_titles
WHERE date_added IS NOT NULL
GROUP BY year_added
ORDER BY year_added;

-- Year-over-year growth rate
WITH yearly AS (
    SELECT
        EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) AS yr,
        COUNT(*) AS total
    FROM netflix_titles
    WHERE date_added IS NOT NULL
    GROUP BY yr
)
SELECT
    yr,
    total,
    LAG(total) OVER (ORDER BY yr)                                   AS prev_year,
    ROUND((total - LAG(total) OVER (ORDER BY yr)) * 100.0
          / NULLIF(LAG(total) OVER (ORDER BY yr), 0), 1)            AS yoy_growth_pct
FROM yearly
ORDER BY yr;
```

---

### 5. Genre Analysis

```sql
-- Top 15 genres (listed_in column contains multiple genres per title)
SELECT
    TRIM(genre_split.value)     AS genre,
    COUNT(*)                    AS total
FROM netflix_titles,
     LATERAL UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre_split(value)
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
```

---

### 6. Director & Actor Analysis

```sql
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

-- Directors who made both Movies and TV Shows
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
```

---

## 🚀 How to Run

1. Download the dataset from [Kaggle](https://www.kaggle.com/datasets/shivamb/netflix-shows)
2. Set up PostgreSQL locally or use [DB Fiddle](https://www.db-fiddle.com/) (free, no install)
3. Create the table and import the CSV:

```sql
CREATE TABLE netflix_titles (
    show_id      VARCHAR(10),
    type         VARCHAR(10),
    title        VARCHAR(200),
    director     VARCHAR(300),
    cast_members TEXT,
    country      VARCHAR(200),
    date_added   VARCHAR(50),
    release_year INTEGER,
    rating       VARCHAR(20),
    duration     VARCHAR(20),
    listed_in    VARCHAR(200),
    description  TEXT
);

-- Then import:
COPY netflix_titles FROM '/path/to/netflix_titles.csv'
DELIMITER ',' CSV HEADER;
```

4. Run queries from the `/queries/` folder in order.

---

## 📚 What I Learned

- Handling multi-value columns (country, genre, cast) using `UNNEST` and `STRING_TO_ARRAY`
- Using window functions (`LAG`, `OVER`, `PARTITION BY`) for time-series analysis
- Writing clean, readable SQL with CTEs for complex multi-step analysis
- Translating raw data into business-relevant insights

---

*Dataset source: [Shivam Bansal on Kaggle](https://www.kaggle.com/datasets/shivamb/netflix-shows) — CC0 Public Domain*