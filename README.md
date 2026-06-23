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

## 📚 What I Learned

- Handling multi-value columns (country, genre, cast) using `UNNEST` and `STRING_TO_ARRAY`
- Using window functions (`LAG`, `OVER`, `PARTITION BY`) for time-series analysis
- Writing clean, readable SQL with CTEs for complex multi-step analysis
- Translating raw data into business-relevant insights

---

*Dataset source: [Shivam Bansal on Kaggle](https://www.kaggle.com/datasets/shivamb/netflix-shows) — CC0 Public Domain*