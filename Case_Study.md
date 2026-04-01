# 📖 Case Study: PayMoret AML & Fraud Investigation

## 1. The Context & Business Problem
**PayMoret**, a rapidly growing FinTech (Neobank), faced a critical risk management challenge. Their automated digital lending system flagged an unusual spike in high-frequency, low-value transactions across multiple accounts, coupled with a rising rate of unpaid digital loans (defaults). 

The risk management team needed to understand: Is this a system glitch, normal user behavior, or a coordinated financial crime? 

I was tasked with conducting a full **Anti-Money Laundering (AML)** investigation to trace the money, profile the suspects, and uncover the ultimate goal of these activities.

---

## 2. The Business Questions
Before diving into the SQL database, I framed the investigation around five core business questions:
1. **Behavioral:** Are there specific accounts performing rapid, successive transactions indicative of "Smurfing"?
2. **Internal Security:** Are all suspicious accounts tied to real, verified clients, or is there evidence of internal exploitation (Ghost Accounts)?
3. **Demographics:** Who are the perpetrators behind these accounts? (Gender and Age profiling).
4. **Geography:** Is this a localized threat or a nationwide syndicate?
5. **The Endgame:** Did these suspicious activities lead to direct financial losses for the platform (e.g., unpaid loans)?

---

## 3. The Analytical Journey & Thought Process

### Phase 1: Overcoming Data Engineering Hurdles
Raw financial data is rarely clean. Before any analysis, I encountered and solved two major roadblocks:
* **The "Bleeding Data" Issue:** The `trans.csv` file suffered from line-break formatting issues (`\r\n` carriage returns) native to European/Windows systems, causing data to bleed across columns during import. I resolved this by writing a custom `LOAD DATA INFILE` script to strictly enforce line terminations.
* **Hybrid Cleaning (Excel + SQL):** While SQL is powerful, some initial data triage, null-handling, and structural formatting were faster to execute in Excel. I combined Excel preprocessing with SQL standardizations (Date formatting and translating terms to English) to build a solid data foundation.

### Phase 2: Detecting the "Smurfing" Pattern
Money launderers avoid detection by keeping transactions small. I wrote an optimized CTE to group transactions by `account_id` and `date`, filtering for accounts with **more than 5 transactions in a single day**. This "trap" successfully caught 30 highly suspicious accounts.

### Phase 3: The "Ghost Account" Discovery (Insider Threat)
* **The Thought Process:** While joining the transaction data with client data using an `INNER JOIN`, I realized this might hide a bigger threat. What if an account is highly active but has no associated client data?
* **The Execution:** I utilized a `LEFT JOIN` to search for these specific anomalies. Finding accounts with massive transaction volumes but `NULL` client IDs points directly to **Ghost Accounts**—a strong indicator of internal fraud, system bypass, or employee collusion within the FinTech platform.

### Phase 4: Escaping the "Temporal Trap" in Age Profiling
* **The Thought Process:** To profile the age of the fraudsters, the initial instinct is to subtract their birth year from the *current* year (`NOW()`). However, this is a "Temporal Trap." Calculating their age today misrepresents their demographic profile at the time the crime was committed.
* **The Execution:** I optimized the query to calculate the difference between the `Birth_Date` and the specific `t.date` of the fraudulent transaction. 
* **The Result:** The average age dropped to the late 30s and early 40s, proving these were not young tech-savvy hackers, but mature individuals manipulating the digital system.

### Phase 5: The "Bust-Out" Fraud Revelation
The final step was connecting the smurfing accounts to the `loan` table. I discovered a chilling pattern:
The intense transaction activity (smurfing) was merely a smokescreen to artificially inflate the account's activity score. Once the Neobank's automated algorithm categorized them as "High-Value/Active Clients", they applied for massive digital loans (up to **$541k**). Immediately after receiving the funds, the accounts went dormant, and the loans defaulted (**Status D**). This confirmed a classic **Bust-Out Fraud** scheme exploiting the FinTech's automated lending model.

---

## 4. Final Business Insights & Recommendations

### 📊 Key Findings:
1. **The Core Threat:** Smurfing is being used to build fake creditworthiness, culminating in "Bust-Out" digital loan defaults.
2. **The Profile:** The perpetrators are equally split between genders, average ~40 years old, and operate primarily in major urban centers (Prague, Ostrava, Zlin).
3. **Financial Impact:** Over 80% of the flagged accounts successfully secured and defaulted on large loans, costing the platform millions.

### 🛡️ Strategic Recommendations for PayMoret:
1. **Implement Velocity Rules:** Update the automated fraud detection system to immediately flag and freeze accounts attempting more than 5 transactions within a 24-hour window.
2. **Algorithm Overhaul:** Modify the digital credit-scoring algorithm so that loan approvals are not based solely on transaction *frequency*, but also require long-term account maturation and deep identity verification.
3. **Internal Audit:** Immediately investigate the IT logs for any "Ghost Accounts" to rule out employee involvement in identity fabrication.
