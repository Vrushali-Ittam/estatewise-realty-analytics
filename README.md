# EstateWise Realty Analytics

### SQL Analytics Practice Project | Real Estate Domain

## 📌 Project Overview

EstateWise Realty is a SQL-based data analytics project designed to analyze real estate sales and booking data.

The project uses MySQL to analyze property listings, customer bookings, sales performance, builders, agents, cities, and buyer spending patterns.

The main objective is to use SQL to answer real-world business questions and generate useful insights for decision-making.

---

## 🎯 Problem Statement

EstateWise Realty is a fictional real estate consultancy operating across multiple cities in India.

The company has property listing and booking data for the years **2024 and 2025**.

The objective of this project is to analyze the data and identify:

* Sales performance across different cities
* Top-performing builders
* Agent performance
* Buyer spending patterns
* Property booking trends
* Unsold and aging properties
* Monthly and yearly sales performance
* Property and possession-type performance

---

## 📊 Dataset Overview

The project contains two main tables:

| Table               | Description                                                    |
| ------------------- | -------------------------------------------------------------- |
| `properties`        | Contains property listing and property-related information     |
| `property_bookings` | Contains booking, buyer, agent, discount and sales information |

### Dataset Details

* **140** property listings
* **2,600** property bookings
* Data period: **2024–2025**
* Multiple cities across India
* Multiple property types and builders

---

## 🗂️ Database Structure

### 1. `properties`

Contains information about properties such as:

* property id
* project name
* builder
* city
* locality
* property type
* bhk
* area
* price per sqft
* base price
* possession status
* amenities score
* year built

### 2. `property_bookings`

Contains information about:

* transaction id
* booking date
* property id
* buyer details
* agent
* sales channel
* base price
* discount
* sale price
* payment mode
* loan amount
* down payment

### 🔗 Relationship

```text
properties
     |
     | property_id
     ↓
property_bookings
```

The `property_id` connects the two tables.

---

## 🛠️ Tools & Technologies

* MySQL
* MySQL Workbench
* SQL
* GitHub

---

## 🧠 SQL Concepts Used

This project covers beginner to advanced SQL concepts, including:

* `select`
* `where`
* `order by`
* `group by`
* `having`
* `distinct`
* aggregate functions
* joins
* left joins
* subqueries
* common table expressions (CTEs)
* `case` statements
* date functions
* window functions
* `row_number()`
* `dense_rank()`
* `lag()`

---

## 📈 Business Analysis Performed

The project contains **25 SQL business analysis queries** divided into three levels.

### Beginner Level

* Find properties by city and property type
* Identify bookings by sales channel
* Find distinct builders
* Filter high-value properties
* Analyze properties with discounts
* Identify properties with high amenities scores
* Calculate total bookings

### Intermediate Level

* Calculate total sales by city
* Identify top buyers by spending
* Calculate average discount by sales channel
* Analyze agent performance
* Find properties that have never been booked
* Calculate monthly and yearly sales
* Identify high-performing builders
* Find highest-value bookings by city
* Calculate unique buyers by city

### Advanced Level

* Rank builders based on total sales
* Identify the top-performing agent in each city
* Calculate cumulative monthly sales
* Identify buyers spending above average
* Calculate year-over-year sales growth
* Identify aging ready-to-move inventory
* Segment buyers based on spending
* Analyze average sale price by property type
* Identify the best-performing month for each city

---

## 📁 Project Structure

```text
estatewise-realty-analytics/
│
├── README.md
│
├── sql/
│   ├── 01_schema_and_data_load.sql
│   └── 02_business_analysis_queries.sql
│
├── dataset/
│   ├── properties.csv
│   └── property_bookings.csv
│
└── screenshots/
    ├── top_buyers.png
    ├── sales_by_city.png
    ├── agent_performance.png
    └── yoy_growth.png
```

---

## ▶️ How to Run the Project

1. Install **MySQL Workbench**.
2. Open `01_schema_and_data_load.sql`.
3. Create the `estatewise_realty` database.
4. Create the required tables.
5. Import the CSV datasets.
6. Run `02_business_analysis_queries.sql`.
7. View the results in MySQL Workbench.

---

## 📸 Project Screenshots

Selected SQL query results are included in the `screenshots` folder to demonstrate the analysis performed in MySQL Workbench.

The screenshots highlight examples such as:

* Top buyers
* Sales by city
* Agent performance
* Year-over-year sales growth

---

## 💡 Key Business Areas Analyzed

The analysis focuses on four major areas:

**Sales Performance**
Analyzing sales across cities, builders, months and years.

**Agent Performance**
Comparing agents based on bookings and total sales.

**Buyer Analysis**
Understanding buyer spending and identifying high-value customers.

**Inventory Analysis**
Identifying properties that remain unbooked and analyzing aging inventory.

---

## 📚 What I Learned

Through this project, I practiced:

* Writing SQL queries for real-world business problems
* Working with relational tables
* Joining multiple tables
* Performing sales and customer analysis
* Using CTEs and subqueries
* Applying window functions
* Using SQL for business decision-making
* Converting raw data into meaningful insights

---

## 👩‍💻 Author

**Vrushali Ittam**

Aspiring Data Analyst

**Skills:** SQL | Python | Excel | Power BI

