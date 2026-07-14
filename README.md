# 🛒 Blinkit Unit Economics & Surge Pricing Engine 

![Blinkit Command Center](Blinkit_Unit_Economic_Engine.JPEG)

## 📌 Executive Summary
In the 10-minute quick commerce sector, micro-orders (low cart value, high distance) actively destroy profit margins. This project is an end-to-end data pipeline designed to mathematically identify bleeding transactions and deploy a statistically bounded surge pricing model to recover capital without triggering customer churn.

## ⚠️ The Business Problem
Using proxy FMCG margins (20%) and standard gig-economy driver payouts (₹20 base + ₹5/km), initial analysis revealed a massive operational bleed. 
* **The Bleed Point:** Orders averaging **₹96.84** traveling **3.15 km** were generating a net loss of **-₹16.39** per transaction.

## 🏗️ The 4-Pillar Architecture
I built a 4-tier data architecture to transition from raw logs to an automated financial recovery system:

1. **The Prototyping Layer (Excel):** Built the initial financial sandbox to prove the unit economics math and establish the baseline profitability thresholds.
2. **The ETL Pipeline (MySQL):** Architected a `CREATE VIEW` backend pipeline to automatically ingest order logs and calculate the Net Margin and Profitability Status (`PROFIT` vs `LOSS`) for thousands of historical orders.
3. **The Statistical Engine (Python & Pandas):** Bypassed standard ML regression in favor of a deterministic statistical model. The script calculates the exact algebraic deficit per order and applies a **25% Elasticity Cap** to ensure the proposed surge fee never exceeds the customer's churn threshold. 
4. **The Command Center (Power BI):** Deployed a live dashboard connecting the MySQL warehouse to executive visualizations, tracking the exact capital recovery matrix.

## 📈 Financial Impact (The Results)
The Statistical Surge Engine successfully modeled the recovery of capital while protecting user retention:
* **Total Capital Bleed Identified:** ₹1,874.62
* **Capital Recovered Safely:** ₹1,313.25
* **Recovery Rate:** **70.1%**
* **Strategic Loss:** The remaining 29.9% was flagged as an unrecoverable "Strategic Customer Acquisition Cost" to maintain long-term retention.

## 🛠️ Tech Stack
* **Database:** MySQL Workbench (ETL, View Engineering)
* **Compute:** Python (Pandas, Numpy, SQLAlchemy)
* **Visualization:** Power BI (DAX, UI/UX Design)
* **Prototyping:** Advanced Excel

## 🚀 How to Run the Pipeline
1. Execute `Blinkit_unit_economics_Engine.sql` in MySQL to generate the staging view.
2. Run `surge_engine.ipynb` to calculate statistical caps and push the final matrix to the database.
3. Open `Data Engg background for unit economics Engine.pbix` to view the live executive dashboard.
