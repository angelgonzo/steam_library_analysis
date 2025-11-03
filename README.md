## Steam Library Dashboard

An interactive Power BI dashboard analyzing a personal Steam game library. This project demonstrates Python's pandas webscraping techniques, SQL data handling, and interactive visualizations to uncover insights about game playtime, genres, developers, and pricing trends. Perfect for showcasing data analytics and visualization skills.

---

## 📊 Project Overview

**Goal:**  
Analyze a Steam library to discover key insights about games, playtime, developers, genres, pricing trends, and release patterns.

**Data Source:**  
- CSV file containing game metadata: `name`, `playtime_hours`, `release_date`, `developer(s)`, `publisher(s)`, `genres`, `price`.

**Tools Used:**
- **Python**: Web scraping
- **Microsoft Excel**: Data cleaning
- **MySQL**: Data cleaning, aggregation, and querying  
- **Power BI**: Dashboard building, DAX measures, and interactive visualization  

---

## 🛠️ Data Cleaning & SQL Queries

1. **Normalized multi-value fields**  
   - Separated multiple developers, publishers, and genres into individual rows to ensure accurate aggregation.  
2. **Handled duplicate rows**  
   - Each game now appears once per developer/genre/publisher, and DISTINCTCOUNT / SUMX measures are used to avoid double-counting.  
3. **SQL Queries** included in the project:
   - Total games in library
   - Average playtime per game, per developer, per genre
   - Top developers by playtime
   - Release trends by decade
   - Price analysis
   - Complex queries using CTEs and partitions

> All SQL scripts are included in the mySQL file

---

## ✨ Power BI Dashboard Features

1. **Dynamic KPI Cards**  
   - Total Games, Total Playtime (hrs), Average Price, Unique Developers  
   - Updates automatically based on filters

2. **Top 10 Games & Developers by Playtime**  
   - Interactive bar charts highlighting library favorites

3. **Genre & Year Insights**  
   - Average playtime by genre  
   - Trends in playtime and game releases across decades

4. **Interactive Filters / Slicers**  
   - Slice by Genre, Developer, Release Year

---

## 🖼️ Dashboard Preview

![Dashboard Screenshot](./images/steam_library_dashboard.png)  


---

## 🔎 Key Insights

- Action games have the highest total playtime (~7929 hours), showing that players spend the most time on fast paced genres.  
- Games released in the 2010s dominate the library, accounting for ~60% of all titles.
- Games priced above $30 were played 10x more than games priced between $10-$30
- ~ %2.35 of games have more than 50 hours of playtime.
