select
	*
from steam_lib;

-- ====================================================
## Basic Analysis (#1-#4)


-- Query 1: Games with more than 50 hours of play time
-- ====================================================
select distinct
	name,
    playtime_hours
from steam_lib
where playtime_hours > 50.0
order by playtime_hours desc;

-- ====================================================
-- Query 2: All games released after 2020
-- ====================================================
select distinct
	name,
    release_date
from steam_lib
where year(release_date) > 2020
order by release_date; 

-- ====================================================
-- Query 3: Unique developers
-- ====================================================
select
    distinct(developer)
from steam_lib;

-- ====================================================
-- Query 4: Total number of games in the library
-- ====================================================
select
	count(distinct name) as total_games
from steam_lib;
-- ====================================================
## Aggregations and Summaries (#5-#9)


-- Query 5: Average playtime across all genres
-- ====================================================
select
	avg(distinct playtime_hours) as avg_playtime,
    genres
from steam_lib
group by genres
order by avg_playtime desc;

-- ====================================================
-- Query 6: Most Played Developer
-- ====================================================
select
	sum(distinct playtime_hours) as most_play_dev,
    developer
from steam_lib
group by developer
order by most_play_dev desc
limit 1;

-- ====================================================
-- Query 7: Top 5 most played games
-- ====================================================
select
	name,
    sum(distinct playtime_hours) as total_play
from steam_lib
group by name
order by total_play desc
limit 5;

-- ====================================================
-- Query 8: Total money spent on library
-- ====================================================	
select
	round(sum(distinct price), 2) as total_money
from steam_lib;

-- ====================================================
-- Query 9: Average price/genre
-- ====================================================
select
	genres,
    round(sum(distinct price), 2) as total_money_genre
from steam_lib
group by genres;

-- ====================================================
## Intermediate Analytics (#10-#14)


-- Query 10: Publisher with most released games based on library
-- ====================================================
select
	count(distinct name) as total_games,
    publisher
from steam_lib
group by publisher
order by total_games desc
limit 1;

-- ====================================================
-- Query 11: Total playtime for each genre
-- ====================================================
select
	genres,
    sum(playtime_hours) as total_hours
from steam_lib
group by genres;

-- ====================================================
-- Query 12: Oldest and Newest game in the library
-- ====================================================
select
	distinct name,
    release_date
from steam_lib
where release_date = (select min(release_date) from steam_lib)
or release_date = (select max(release_date) from steam_lib);

-- ====================================================
-- Query 13: Correlation between price and playtime
-- ====================================================
select
	 (avg(price * playtime_hours) - avg(price) * avg(playtime_hours)) / 
     (sqrt(avg(price * price) - avg(price) * avg(price)) * 
     sqrt(avg(playtime_hours * playtime_hours) - avg(playtime_hours) * avg(playtime_hours))) as corr_coefficient
from steam_lib;

-- ====================================================
-- Query 14: Devs with AVG playtime of 20 hours
-- ====================================================
select
	developer,
    round(avg(playtime_hours), 2) as avg_hours
from steam_lib
group by developer
having avg(playtime_hours) >= 20
order by avg_hours;

-- ====================================================
## Date and Time-Based Analytics (#15-#18)


-- Query 15: # of games released each year
-- ====================================================
select
	count(distinct name),
    year(release_date)
from steam_lib
group by year(release_date);

-- =============================================================
-- Query 16: Average playtime by release decade 2000 vs 2010s
-- =============================================================
select
	case
		when year(release_date) between 2000 and 2009 then '2000s'
        when year(release_date) between 2010 and 2019 then '2010s'
        when year(release_date) >= 2020 then '2020s'
        else 'before 2000s'
	end as release_decade,
    round(avg(playtime_hours), 2) as avg_hours
from steam_lib
group by release_decade;

-- =============================================================
-- Query 17: Games released before 2010, with >10 hours of playtime
-- =============================================================
select
	distinct name,
    playtime_hours
from steam_lib
where playtime_hours > 10 and release_date < 2010
order by playtime_hours;


-- =============================================================
-- Query 18: Most common release month
-- =============================================================
select
	count(distinct name),
    month(release_date)
from steam_lib
group by month(release_date)
order by month(release_date) desc
limit 1;

-- =====================================
## Advanced Analysis (#20-#24)


-- Query 20: Ranking games by playtime
-- =====================================
select
	distinct name,
    playtime_hours,
    dense_rank() over (order by playtime_hours desc)
from steam_lib;

-- =====================================
-- Query 20: Ranking games by playtime
-- =====================================
select
	distinct name,
    publisher,
    playtime_hours,
dense_rank() over (partition by publisher order by playtime_hours desc)
from steam_lib;

-- ========================================================
-- Query 21: Top developer per genre based on avg playtime
-- ========================================================
select
	distinct developer,
    genres,
    round(avg(playtime_hours), 2) as avg_playtime,
    rank() over (partition by genres order by round(avg(playtime_hours), 2) desc) as playtime_rank
from steam_lib
group by developer, genres;

-- ===============================================
-- Query 23: Total playtime based on price tiers
-- ===============================================
select
	CASE
		when price < 10.00 then 'low price'
        when price between 10.00 and 30.00 then 'mid price'
        when price > 30.00 then 'high price'
	END as price_tiers,
	round(sum(playtime_hours), 2) as total_playtime
from steam_lib
group by price_tiers
order by total_playtime desc;

-- ========================================================
-- Query 24: CTE to filter games with over 10 hours,
-- then summarize avg price and release year
-- ========================================================
with over_10 as (
	select
		distinct name,
        price,
        year(release_date) as release_year
	from steam_lib
    where playtime_hours < 10
)

select
    round(avg(price), 2) as avg_price,
    round(avg(release_year), 2) as avg_release_year
from over_10;