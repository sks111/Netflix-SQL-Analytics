<div align="center">

</div>

---

# 🎬 Netflix SQL Analytics — End-to-End Business Case Study

![MySQL](https://img.shields.io/badge/MySQL-8.0.44-4479A1)
![SQL](https://img.shields.io/badge/SQL-007ACC)
![Status](https://img.shields.io/badge/Project-Complete-success)


> A **production-style SQL analytics project** analyzing Netflix’s content catalog to answer **20 real business questions** using **EDA, advanced SQL, and insight-driven analysis**.

---

## 📌 Project Overview

This project analyzes the **Netflix Movies & TV Shows dataset (8,807 titles)** to simulate how data analysts support decision-making for:

- Content Strategy teams  
- Growth & Expansion teams  
- Audience Insights teams  
- Regional Programming managers  

The focus is not just writing queries, but demonstrating:
- **Exploratory Data Analysis (EDA)**
- **Data cleaning & transformation**
- **Business-driven SQL solutions**
- **Insight communication**

---

## 🎯 Business Objectives

- Understand Netflix’s **content mix (Movies vs TV Shows)**
- Analyze **platform growth over time**
- Identify **regional production patterns**
- Evaluate **director & actor contribution**
- Segment content by **audience maturity and genre trends**
- Assess **data quality and limitations**

---

## 🧠 Dataset Overview

| Attribute | Description |
|--------|------------|
| Total Titles | 8,807 |
| Content Types | Movies, TV Shows |
| Time Range | 1925 – Present |
| Dimensions | Country, Genre, Rating, Cast, Director, Duration, Release Year |
| Format | Structured CSV → MySQL Database |

---

## 🔍 Exploratory Data Analysis (EDA)

Before answering business questions, a comprehensive **EDA phase** was conducted using SQL.

### EDA Steps Performed

### 1️⃣ Dataset Profiling
- Verified record count and content types
- Checked release year and `date_added` ranges
- Identified Movies vs TV Shows distribution

### 2️⃣ Data Quality Assessment
- Quantified missing values in:
  - `director`
  - `cast`
  - `country`
- Identified incomplete metadata affecting people analytics

### 3️⃣ Categorical Exploration
- Analyzed:
  - Ratings distribution
  - Genres (`listed_in`)
  - Country diversity
- Identified multi-value columns requiring transformation

### 4️⃣ Temporal Analysis
- Compared `release_year` vs `date_added`
- Identified **post-2016 content growth spike** (global expansion phase)

📌 **EDA Outcome:**  
Defined feasible questions, highlighted limitations, and guided SQL transformations.

---

## 🧩 Data Cleaning & Transformation

Several fields required transformation to support accurate analysis.

| Challenge | SQL Solution |
|--------|--------------|
| Multiple genres in one column | `SUBSTRING_INDEX`, string parsing |
| Multiple countries per title | Country normalization logic |
| TV seasons stored as text | `CAST()` + string extraction |
| Mixed duration formats | Separate logic for Movies vs TV Shows |
| Missing directors | Flagged for data quality analysis |

---

## 🧠 Solution Design & SQL Methodology

Each question follows a structured workflow:

1. Define the **business question**
2. Identify relevant columns
3. Clean & transform data if required
4. Aggregate metrics using SQL
5. Rank, filter, or segment results
6. Translate output into **business insight**

### SQL Techniques Used

- Common Table Expressions (CTEs)
- Window Functions (`RANK`, `ROW_NUMBER`)
- `CASE WHEN` for classification
- Date & time functions
- String manipulation functions
- `GROUP BY`, `HAVING`, subqueries

---

## 📊 Business Questions Answered

<details>
<summary><b>📈 Section 1: Content Overview</b></summary>

| Q# | Question |
|---|----------|
| Q1 | Movies vs TV Shows count |
| Q2 | Most common ratings by content type |
| Q3 | Movies released in 2020 |
| Q4 | Top 5 content-producing countries |
| Q5 | Longest movies by duration |

</details>

<details>
<summary><b>⏳ Section 2: Growth & Time Trends</b></summary>

| Q# | Question |
|---|----------|
| Q6 | Content added in the last 5 years |
| Q7 | Annual growth trend (last 10 years) |
| Q8 | TV shows with 5+ seasons |
| Q9 | India peak content years (% share) |
| Q10 | Top 10 primary genres |

</details>

<details>
<summary><b>👥 Section 3: People Analytics</b></summary>

| Q# | Question |
|---|----------|
| Q11 | Rajiv Chilaka’s complete works |
| Q12 | Top 5 directors by volume |
| Q13 | Top 10 Indian movie actors |
| Q14 | Salman Khan movies (last 10 years) |
| Q15 | Missing director data analysis |

</details>

<details>
<summary><b>🎯 Section 4: Audience & Strategy</b></summary>

| Q# | Question |
|---|----------|
| Q16 | Rating distribution by content type (%) |
| Q17 | Kids vs Mature vs Other content |
| Q18 | Genre evolution by decade |
| Q19 | Multi-country collaborations |
| Q20 | Movie duration by country |

</details>

---

## 📈 Key Insights

- Movies dominate the catalog, but **TV Shows support long-term engagement**
- Significant **content acceleration post-2016**
- India shows **cyclical production peaks**
- Mature-rated content dominates overall supply
- Multi-country collaborations are increasing
- Metadata gaps impact people-based analytics

---


## 🚀 How to Run the Project

```bash
# Clone repository
git clone https://github.com/yourusername/Netflix-SQL-Analytics.git
cd Netflix-SQL-Analytics

# Load dataset
mysql -u root -p netflix_db < netflix_titles.sql

# Run full analysis
mysql -u root -p netflix_db < netflix_complete_analysis.sql
