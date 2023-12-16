CREATE DATABASE First_Project;
USE First_Project;

CREATE TABLE users(user_id INT, 
products INT, 
reviews INT);

CREATE TABLE reccomendations(app_id INT, 
helpful INT, 
funny INT,
recc_date DATE,
is_reccomended TEXT,
hours DOUBLE,
user_id INT,
review_id INT);

CREATE TABLE games(app_id INT, 
title VARCHAR(255), 
date_release DATE,
win TEXT,
mac TEXT,
linux TEXT,
rating TEXT,
positive_ratio DOUBLE,
user_reviews INT,
price_final DOUBLE,
price_original DOUBLE,
discount INT,
steam_deck TEXT);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/recommendations.csv'
INTO TABLE reccomendations
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
SELECT *
FROM reccomendations;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/games.csv'
INTO TABLE games
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
SELECT *
FROM games;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/users.csv'
INTO TABLE users
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
SELECT *
FROM users;

SELECT YEAR(date_release) AS release_year, COUNT(*) AS num_releases
FROM games
WHERE YEAR(date_release) < 2023 
AND YEAR(date_release) >= 2000
GROUP BY release_year
ORDER BY release_year;
SELECT 
SUM(CASE WHEN win = 'TRUE' THEN 1 ELSE 0 END) / COUNT(*) * 100 AS 'win_cap_%', 
SUM(CASE WHEN mac = 'TRUE' THEN 1 ELSE 0 END) / COUNT(*) * 100 AS 'mac_cap_%', 
SUM(CASE WHEN linux = 'TRUE' THEN 1 ELSE 0 END) / COUNT(*) * 100 AS 'linux_cap_%'
FROM games;

SELECT SUM(reviews) / COUNT(DISTINCT user_id) AS avg_raview_rate
FROM users;

SELECT SUM(CASE WHEN is_recommended = 'TRUE' THEN 1 ELSE 0 END) AS total_positive, 
COUNT(*) AS total_recommendations,
SUM(CASE WHEN is_recommended = 'TRUE' THEN 1 ELSE 0 END) / COUNT(*) * 100 AS 'recc_rate_%'
FROM recommendations;
SELECT DISTINCT g.title, r.hours
FROM recommendations AS r
LEFT JOIN games AS g
ON r.app_id = g.app_id
ORDER BY r.hours DESC
LIMIT 10;
SELECT SUM(hours) / SUM(CASE WHEN is_recommended = 'TRUE' THEN 1 ELSE 0 END) AS playtime_per_recommendation
FROM recommendations;

ALTER TABLE reccomendations RENAME recommendations;
ALTER TABLE recommendations RENAME COLUMN is_reccomended TO is_recommended;
ALTER TABLE recommendations RENAME COLUMN recc_date TO rec_date;

SELECT DISTINCT g.title, YEAR(g.date_release) AS year_released, g.positive_ratio
FROM games AS g
INNER JOIN games AS g2
WHERE YEAR(g.date_release) = 2023 AND g.rating LIKE '%Positive%' AND g.user_reviews > (SELECT AVG(g2.user_reviews) FROM games AS g2)
ORDER BY g.positive_ratio DESC
LIMIT 20;

SHOW VARIABLES LIKE "secure_file_priv";