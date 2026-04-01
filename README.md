# PayMoret: FinTech Anti-Money Laundering (AML) & Fraud Analysis

## 📌 Project Overview
This project is a comprehensive **End-to-End Data Analysis and Fraud Investigation** conducted on a real-world banking dataset. The goal was to identify sophisticated financial crimes, specifically **Smurfing** (Money Laundering) and **Bust-Out Fraud** (Loan Defaults), and to provide actionable insights for a FinTech risk management team.

### 💾 Data Source
The dataset used for this project is the **Czech Financial Dataset (Berka Dataset)** originally from the 1999 PKDD Discovery Challenge. It contains real, anonymized banking transactions, loans, and client demographic data.
* **Dataset Link:** [Czech Financial Bank Dataset - Kaggle](https://www.kaggle.com/datasets/volodymyrgavrysh/bank-dataset)

---

## 🕵️‍♂️ The Business Case (The Scenario)
The management at **PayMoret** noticed suspicious patterns in transaction volumes and high loan default rates. As a Data Analyst, I was tasked to investigate:
1. Are there accounts being used for money laundering (Smurfing)?
2. What is the demographic and geographical profile of these suspects?
3. Did these suspects exploit the bank’s credit system before disappearing?

---

## 🛠️ Data Engineering & Cleaning (The Foundation)
Before the investigation, the raw data required significant cleaning to ensure high-quality results. I utilized a dual-tool approach (Excel & SQL) for optimal processing:

* **Initial Triage (Excel):** Conducted preliminary data profiling, handled basic null values, and performed initial structural formatting for specific tables before migrating to the database.
* **Fixing Data Bleeding (SQL):** Resolved Windows/Linux carriage return issues (`\r\n`) that corrupted the `trans` table during the CSV import phase.
* **Temporal Standardization (SQL):** Converted non-standard string dates (e.g., YYMMDD and MM/DD/YYYY) into proper SQL `DATE` formats.
* **Localization (SQL):** Translated banking terminology from Czech (`PRIJEM`, `VYDAJ`, etc.) to English for international reporting.

---

## 🚀 Investigation Pipeline (SQL Analysis)

### 1. Smurfing Detection (The Red Flag)
I identified accounts performing more than **5 transactions per day**—a classic indicator of "Smurfing" where large sums are broken into small deposits to bypass regulatory limits.

### 2. Insider Threat & Ghost Accounts
By performing a `LEFT JOIN` between transactions and client records, I investigated **Ghost Accounts** (active accounts with no associated client data), highlighting potential internal system breaches or identity theft.

### 3. Demographic & Age Profiling
* **Gender Neutrality:** Fraud was almost equally split between males and females.
* **The Temporal Trap:** I avoided a common analytical error by calculating the suspects' age **at the exact time of the crime** (Avg. 39-42 years old), rather than their current age, providing a more accurate criminal profile.

### 4. Geospatial Analysis (Hotspots)
The analysis revealed that fraud is not scattered; it is concentrated in **Prague (The Capital)** and major industrial hubs like **Ostrava** and **Zlin**, suggesting organized crime syndicates operating in high-volume urban branches.

### 5. The "Bust-Out" Fraud (The Loan Heist)
The most critical finding: Most fraud suspects successfully applied for large loans (up to **500k+**) and subsequently moved to **Status D** (Default/Unpaid), proving that the smurfing was a precursor to a planned bank heist.

---

## 📈 Key Insights & Results
| Metric | Insight |
| :--- | :--- |
| **Suspect Count** | 30 Highly active accounts flagged for AML investigation. |
| **Average Loan Amount** | ~$350,000 per suspect. |
| **Primary Status** | Over 80% of suspects are in Status 'D' (Defaulted). |
| **Risk Hotspots** | Urban centers (Prague, Ostrava) are at 3x higher risk. |

---

## 📷 Project Visuals

### 🎥 Interactive Demo
![Dashboard Demo](04_Assets/Dashboard_Demo.gif)

### 🖥️ Desktop Dashboard
![Desktop Dashboard](04_Assets/Dashboard_Desktop.png)

### 📱 Mobile Layout
![Mobile Dashboard](04_Assets/Dashboard_Mobile.png)

*(Note: Visuals are placeholders and will be updated upon Power BI dashboard completion).*

---

## 📂 Project Structure
* `SQL_Scripts/`: Contains `01_Data_Preparation.sql` and `02_Fraud_Analysis.sql`.
* `Dataset/`: Contains the cleaned CSV exports used for visualization.
* `Dashboard/`: Contains the `.pbix` interactive dashboard file.
* `04_Assets/`: Screenshots of query results, GIFs, and dashboard layouts.

---

## 💡 Technical Skills Demonstrated
* **Advanced SQL:** CTEs, Window Functions, Complex Joins, Data Aggregation.
* **Data Cleaning:** Excel Data Preprocessing, Handling malformed CSVs, Date parsing.
* **Business Intelligence:** Strategic storytelling, AML investigation logic, Risk profiling.

---

## 👤 Author
**Ezz El Dean Hashish**
*Data Analyst | ex-Web Technical Lead*
