# Supply Chain Delivery Performance & Profitability Analysis
### SQL · Python · Power BI | End-to-End Analytics Project

---

## Table of Contents
- [Background](#background)
- [Problem Statement](#problem-statement)
- [Key Findings](#key-findings)
- [Recommendations](#recommendations)
- [Tech Stack](#tech-stack)
- [Project Structure](#project-structure)
- [Project Workflow](#project-workflow)
- [Dataset](#dataset)
- [How to Run](#how-to-run)
- [Dashboard](#dashboard)

---

## Background

DataCo Logistics operates across four global markets — LATAM, Europe, Pacific Asia, and USCA — processing hundreds of thousands of orders across multiple product departments and customer segments.

Revenue numbers looked stable on the surface. But delivery performance was degrading, and certain product departments were generating high order volumes while quietly losing money. Neither problem was visible without structured analysis across shipping modes, geographies, and customer segments.

This project digs into both.

---

## Problem Statement

Two questions drove this analysis:

> *"Why are so many orders arriving late — and which parts of the business are actually profitable?"*

More specifically:

- What percentage of orders are late, and where is the problem most concentrated?
- Which shipping modes are underperforming relative to their volume?
- Which departments and product categories are loss-making?
- Is there a seasonal pattern to delivery delays?
- Which customer segment is most exposed to delivery failures?
- What factors predict how late an order will be?

---

## Key Findings

| # | Finding | Number |
|---|---|---|
| 1 | More than half of all orders carry late delivery risk | 54.2% late rate |
| 2 | Standard Class averages the highest delay of any shipping mode | 2.8 days average |
| 3 | Second Class has the worst late rate across all modes | 65% late rate |
| 4 | Same Day delivery significantly outperforms every other mode | 18% late rate |
| 5 | Three departments are loss-making despite high order volume | Negative profit margin |
| 6 | Corporate segment generates the most revenue but has the worst delivery experience | 60% late rate |
| 7 | LATAM and Pacific Asia are the worst-performing markets geographically | Consistently above 60% |
| 8 | High-value orders tend to arrive faster — an informal priority system exists in operations | Negative regression coefficient |
| 9 | Shipping mode is the strongest predictor of delay duration | Regression coefficient: +1.8 |
| 10 | Revenue spikes and delay spikes occur in the same months | Demand surge pattern |

---

## Recommendations

**1. Audit Standard Class and Second Class carrier contracts**
These two modes carry 75% of total shipment volume and consistently underperform on delivery timelines. Renegotiating SLAs or introducing financial penalties for breach could meaningfully move the overall late delivery rate. A 10-point improvement in Standard Class alone shifts the company metric by roughly 5 points.

**2. Create a formal delivery tier for Corporate customers**
Corporate accounts drive the highest revenue share but face the worst delivery experience — a combination that is a churn risk in any B2B business. A dedicated fulfillment lane or guaranteed shipping mode upgrade for this segment serves both as a retention play and a potential revenue lever.

**3. Review the three loss-making departments**
Fan Shop, Book Shop, and one other department are generating revenue while destroying margin. The fix is either a pricing adjustment, a supplier cost renegotiation, or a deliberate decision to reduce volume in those categories. Continuing to grow order counts in negative-margin departments makes the problem worse.

**4. Make the high-value order priority rule explicit**
The data shows that expensive orders arrive faster on average — an informal priority system already exists somewhere in operations. Formalizing this as a policy or customer-facing premium tier sets clearer expectations and creates a monetizable logistics product.

**5. Use the regression model as an early-warning system at dispatch**
The model predicts delay duration with a mean absolute error of around 1.2 days — accurate enough to flag high-risk orders before they leave the warehouse, giving the ops team a window to intervene before a delay becomes a customer complaint.

---

## Tech Stack

| Tool | Purpose |
|---|---|
| Python (Pandas, Scikit-learn, Matplotlib, Seaborn) | Cleaning, EDA, feature engineering, regression |
| SQLite + SQLAlchemy | Star schema database and SQL analysis |
| Power BI Desktop | 3-page executive dashboard and DAX measures |
| Jupyter Notebook inside VS Code | Analysis environment |
| Git + GitHub | Version control |

---

## Project Structure

```
supply-chain-analytics/
│
├── data/
│   ├── raw/                            ← Original Kaggle CSV (not committed)
│   ├── cleaned/
│   │   ├── fact_orders.csv
│   │   ├── dim_customer.csv
│   │   ├── dim_product.csv
│   │   ├── dim_date.csv
│   │   └── dim_geo.csv
│   └── models/
│       └── supply_chain.db             ← SQLite star schema database
│
├── notebooks/
│   ├── 01_cleaning_eda.ipynb           ← Cleaning decisions + exploratory charts
│   ├── 02_feature_engineering.ipynb    ← Business-driven feature creation
│   └── 03_regression_model.ipynb       ← Model + coefficient interpretation
│
├── sql/
│   ├── 01_schema_creation.sql          ← Star schema DDL
│   └── 02_business_queries.sql         ← 8 business queries
│
├── powerbi/
│   └── supply_chain_dashboard.pbix     ← Final dashboard file
│
├── docs/
│   ├── eda_delay_analysis.png
│   ├── eda_dept_profit.png
│   ├── eda_monthly_trend.png
│   ├── regression_coefficients.png
│   └── data_dictionary.md
│
├── README.md
├── .gitignore
└── requirements.txt
```

---

## Project Workflow

```
Raw CSV (180K rows, 53 columns)
        │
        ▼
Python — Data Cleaning
  ├── Parse and fix date columns
  ├── Handle nulls using business logic
  ├── Remove duplicate order-item combinations
  ├── Standardize categorical values
  └── Create delay_days as the core target variable
        │
        ▼
Star Schema — SQLite
  ├── fact_orders       (180K rows — one row per order item)
  ├── dim_customer      (segment, city, country)
  ├── dim_product       (category, department, price)
  ├── dim_date          (full calendar with week, quarter, month)
  └── dim_geo           (market, region, country)
        │
        ▼
SQL Analysis — 8 Business Queries
  ├── Overall late delivery rate
  ├── Late rate and avg delay by shipping mode
  ├── Profit by department (JOIN to dim_product)
  ├── Market and region performance
  ├── Monthly revenue trend (JOIN to dim_date)
  ├── YTD running total (window function)
  ├── Customer revenue ranking (RANK + NTILE)
  └── Delivery status by segment (CASE WHEN pivot)
        │
        ▼
Python — EDA + Feature Engineering
  ├── Delay distribution and shipping mode breakdown
  ├── Department profit bar chart
  ├── Monthly revenue vs delay dual-axis chart
  ├── Correlation heatmap
  └── 7 new features: schedule adherence ratio,
      revenue per unit, season, ship mode encoding,
      high-value flag, market encoding, is_late flag
        │
        ▼
Linear Regression
  ├── Target: delay_days
  ├── MAE: ~1.2 days
  └── Top finding: shipping mode is the strongest predictor
        │
        ▼
Power BI Dashboard
  ├── Page 1: Executive Overview
  │     ├── 4 KPI cards with conditional color formatting
  │     ├── Line chart — monthly revenue vs delay trend
  │     ├── Bar chart — late rate by shipping mode
  │     └── Bar chart — late rate by market
  ├── Page 2: Profitability Analysis
  │     ├── 3 KPI cards
  │     ├── Bar chart — profit by department (red = loss)
  │     ├── Treemap — revenue by product category
  │     └── Matrix — department × category with conditional formatting
  └── Page 3: Customer & Segment Analysis
        ├── 4 KPI cards
        ├── Donut — revenue share by segment
        ├── Stacked bar — delivery status by segment
        └── Area chart — monthly revenue with MoM growth %
```

---

## Dataset

**DataCo Smart Supply Chain for Big Data Analysis**
Kaggle — https://www.kaggle.com/datasets/shashwatwork/dataco-smart-supply-chain-for-big-data-analysis

180,519 rows, 53 columns covering order transactions, shipping performance, customer details, product hierarchy, and geography. The raw file has mixed date formats, high null rates in certain columns, and inconsistent category naming — realistic enough to require proper cleaning decisions rather than a straightforward load.

---

## How to Run

```bash
# Clone the repo
git clone https://github.com/YOUR_USERNAME/supply-chain-analytics.git
cd supply-chain-analytics

# Install dependencies
pip install -r requirements.txt
```

Download the dataset from the Kaggle link above and place the CSV inside `data/raw/`. Run the notebooks in order — cleaning first, feature engineering second, regression third. The SQLite database gets created automatically during the first notebook.

For the Power BI file, open `powerbi/supply_chain_dashboard.pbix` in Power BI Desktop. If prompted to update the data source, point it to your local `data/cleaned/` folder.

---

## Dashboard

The dashboard has three pages, each answering a different layer of the business question.

**Page 1 — Executive Overview**
Headline KPIs, monthly trend, late rate by shipping mode, and late rate by market. The first page a decision-maker should open.

**Page 2 — Profitability Analysis**
Department-level profit breakdown with loss-making departments flagged in red. The treemap shows revenue concentration by category, and the matrix lets you drill from department down to category level with conditional formatting on both margin and late rate.

**Page 3 — Customer & Segment Analysis**
Revenue share by segment, delivery status breakdown, and monthly revenue trend with MoM growth. The key story here is the Corporate segment — highest revenue contribution, worst delivery experience.
