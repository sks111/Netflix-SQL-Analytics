-- ==========================================
-- Complete NETFLIX SQL Analysis
-- Table: netflix_titles
-- Columns: show_id, type, title, director, cast, country, date_added, 
--          release_year, rating, duration, listed_in, description
-- ==========================================

-- ==========================================
-- SECTION 1: BASIC METRICS (Q1-5)
-- ==========================================

-- 1. Count Movies vs TV Shows
SELECT 
    type,
    COUNT(*) AS total_titles
FROM netflix_titles
GROUP BY type
ORDER BY total_titles DESC;

-- 2. Most common rating by content type
WITH rating_counts AS (
    SELECT type, rating, COUNT(*) AS rating_count
    FROM netflix_titles 
    GROUP BY type, rating
),
ranked_ratings AS (
    SELECT type, rating, rating_count,
           RANK() OVER (PARTITION BY type ORDER BY rating_count DESC) AS rnk
    FROM rating_counts
)
SELECT type, rating AS most_frequent_rating, rating_count
FROM ranked_ratings
WHERE rnk = 1
ORDER BY type;

-- 3. Movies released in 2020
SELECT * 
FROM netflix_titles
WHERE type = 'Movie' AND release_year = 2020
ORDER BY title;

-- 4. Top 5 countries by content volume (MySQL 8.0.44 - SIMPLE)
SELECT 
    TRIM(SUBSTRING_INDEX(country, ',', 1)) AS country_clean,
    COUNT(*) AS total_content
FROM netflix_titles
WHERE country IS NOT NULL 
  AND TRIM(SUBSTRING_INDEX(country, ',', 1)) != ''
GROUP BY country_clean
ORDER BY total_content DESC
LIMIT 5;


-- 5. Longest movie (MySQL 8.0.44)
SELECT *
FROM netflix_titles
WHERE type = 'Movie' 
  AND duration REGEXP '^[0-9]+ min$'
ORDER BY CAST(REGEXP_SUBSTR(duration, '^[0-9]+') AS UNSIGNED) DESC
LIMIT 5;

-- ==========================================
-- SECTION 2: TIME-BASED ANALYSIS (Q6-10)
-- ==========================================

-- 6. Content added in last 5 years
-- 6. Content added in last 5 years (MySQL 8.0.44)
SELECT *
FROM netflix_titles
WHERE STR_TO_DATE(date_added, '%M %d, %Y') >= DATE_SUB(CURDATE(), INTERVAL 5 YEAR)
ORDER BY STR_TO_DATE(date_added, '%M %d, %Y') DESC;

-- 7. Content growth trend (titles added per year, last 10 years)
SELECT 
    YEAR(STR_TO_DATE(date_added, '%M %d, %Y')) AS year_added,
    COUNT(*) AS titles_added
FROM netflix_titles
WHERE date_added IS NOT NULL
  AND YEAR(STR_TO_DATE(date_added, '%M %d, %Y')) >= YEAR(CURDATE()) - 10
GROUP BY year_added
ORDER BY year_added DESC;

-- 8. TV shows with 5+ seasons
SELECT *
FROM netflix_titles
WHERE type = 'TV Show'
  AND duration REGEXP '^[0-9]+ Season'
  AND CAST(REGEXP_SUBSTR(duration, '^[0-9]+') AS UNSIGNED) > 5
ORDER BY CAST(REGEXP_SUBSTR(duration, '^[0-9]+') AS UNSIGNED) DESC;

-- 9. India content: Top 5 years by % share
WITH india_totals AS (
    SELECT COUNT(*) AS total_india_titles
    FROM netflix_titles 
    WHERE country LIKE '%India%'
),
india_by_year AS (
    SELECT release_year, COUNT(*) AS total_release_year
    FROM netflix_titles 
    WHERE country LIKE '%India%'
    GROUP BY release_year
)
SELECT 
    i.release_year,
    i.total_release_year,
    ROUND(i.total_release_year * 100.0 / t.total_india_titles, 2) AS pct_share
FROM india_by_year i, india_totals t
ORDER BY pct_share DESC, i.release_year DESC
LIMIT 5;

-- 10. Genre popularity ranking (first genre)
SELECT 
    TRIM(SUBSTRING_INDEX(listed_in, ',', 1)) AS genre,
    COUNT(*) AS total_content
FROM netflix_titles
WHERE listed_in IS NOT NULL 
  AND TRIM(SUBSTRING_INDEX(listed_in, ',', 1)) != ''
GROUP BY genre
ORDER BY total_content DESC
LIMIT 10;

-- ==========================================
-- SECTION 3:  PEOPLE & PERFORMANCE (Q11-15)
-- ==========================================

-- 11. Director 'Rajiv Chilaka' complete works
SELECT *
FROM netflix_titles
WHERE director LIKE '%Rajiv Chilaka%'
ORDER BY release_year DESC, title;

-- 12. Top 5 directors by total titles (first director)
SELECT 
    TRIM(SUBSTRING_INDEX(director, ',', 1)) AS director_name,
    COUNT(*) AS total_titles
FROM netflix_titles
WHERE director IS NOT NULL 
  AND TRIM(SUBSTRING_INDEX(director, ',', 1)) != ''
GROUP BY director_name
ORDER BY total_titles DESC
LIMIT 5;

-- 13. Top 10 actors in India movies (first actor)
SELECT 
    TRIM(SUBSTRING_INDEX(`cast`, ',', 1)) AS actor,
    COUNT(*) AS total_movies
FROM netflix_titles
WHERE country LIKE '%India%' AND type = 'Movie'
GROUP BY actor
ORDER BY total_movies DESC
LIMIT 10;

-- 14. Salman Khan movies (last 10 years)
SELECT *
FROM netflix_titles
WHERE type = 'Movie' 
  AND `cast` LIKE '%Salman Khan%' 
  AND release_year >= YEAR(CURDATE()) - 10
ORDER BY release_year DESC;

-- 15. Content without directors
SELECT *
FROM netflix_titles
WHERE director IS NULL OR TRIM(director) = ''
ORDER BY release_year DESC, title;

-- ==========================================
-- SECTION 3:  AUDIENCE & GENRE INSIGHTS (Q16-20)
-- ==========================================

-- 16. Rating distribution by content type
SELECT 
    type, rating, COUNT(*) AS title_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY type), 2) AS pct_of_type
FROM netflix_titles 
WHERE rating IS NOT NULL
GROUP BY type, rating
ORDER BY type, title_count DESC;

-- 17. Maturity ratings breakdown
WITH rating_category AS (
    SELECT *,
        CASE 
            WHEN rating IN ('TV-Y', 'TV-Y7', 'G', 'TV-G', 'PG') THEN 'Kids'
            WHEN rating IN ('TV-MA', 'R', 'NC-17') THEN 'Mature'
            ELSE 'Other'
        END AS maturity_rating
    FROM netflix_titles WHERE rating IS NOT NULL
)
SELECT maturity_rating, COUNT(*) AS titles,
       ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS percentage
FROM rating_category
GROUP BY maturity_rating
ORDER BY titles DESC;

-- 18. Genre evolution by decade (simplified)
SELECT 
    FLOOR(release_year / 10) * 10 AS decade,
    TRIM(SUBSTRING_INDEX(listed_in, ',', 1)) AS genre,
    COUNT(*) AS titles
FROM netflix_titles 
WHERE release_year IS NOT NULL
GROUP BY decade, genre
ORDER BY decade DESC, titles DESC
LIMIT 9;

-- 19. Multi-country collaborations (2+ countries)
SELECT 
    TRIM(SUBSTRING_INDEX(country, ',', 1)) AS country,
    COUNT(*) AS collab_titles
FROM netflix_titles
WHERE (LENGTH(country) - LENGTH(REPLACE(country, ',', ''))) >= 1
GROUP BY country
ORDER BY collab_titles DESC
LIMIT 10;

-- 20. Longest movies by country (avg duration)
SELECT 
    TRIM(SUBSTRING_INDEX(country, ',', 1)) AS country,
    AVG(CAST(REGEXP_SUBSTR(duration, '^[0-9]+') AS UNSIGNED)) AS avg_duration_minutes
FROM netflix_titles
WHERE type = 'Movie' AND duration REGEXP '^[0-9]+ min$'
GROUP BY country
HAVING COUNT(*) >= 5
ORDER BY avg_duration_minutes DESC
LIMIT 10;



