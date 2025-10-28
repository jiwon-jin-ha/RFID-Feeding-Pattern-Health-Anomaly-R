# 🚀 PLF-Internship: RFID Feeding Patterns for Early Health Deviation Detection

This project was conducted during an internship at **Wageningen Livestock Research** to perform statistical analysis and modeling aimed at **early detection of biting-related health deviations in weaned piglets using RFID feeder data**.

| **Focus** | **Health Anomaly Detection, Behavioural Analysis, Feeding Efficiency** |
| :--- | :--- |
| **Duration** | [Start Date] - [End Date] |
| **Tool** | **R Studio (Statistical Analysis)** |

---

## 1. Project Goal & Business Impact

### Objective
This study aimed to determine if **deviations in feeding patterns**, detected through **RFID technology**, could indicate **biting-related health issues** in weaned piglets. This addresses the need for non-invasive, early detection methods.

### Potential Business Value
By providing insight into early health indicators based on behaviour, the analysis contributes to **improving animal welfare** and potentially **reducing mortality/losses** associated with biting behaviours, leading to better **farm management decisions**.

---

## 2. Technical Pipeline & Implementation

### 🛠️ Key Technologies
| Category | Tool / Method |
| :--- | :--- |
| **Data Cleaning & Analysis** | **R Studio** (`tidyverse`, `dplyr`) |
| **Statistical Modeling** | **Non-Parametric Analysis (Mann-Whitney U tests)** |
| **Sensor Data** | **RFID Feeder Log Data (360 barrow piglets)** |

### 🔍 Methodology: Feeding Pattern Feature Engineering & Statistical Comparison
The project focused on comparing feeding patterns across seven weeks post-weaning.

1.  **Data Ingestion & Feature Engineering:** Analyzed data from **360 barrow piglets** over seven weeks.
2.  **Pattern Feature Definition:** Established specific criteria for statistical analysis of feeding behaviour:
    * **Visit Criterion:** **10 seconds**
    * **Meal Criterion:** **58.5 seconds**
3.  **Statistical Comparison:** Used **Mann-Whitney U tests** to compare key feeding behaviours (duration, meal frequency) between piglets affected by biting and healthy piglets, particularly during the peak biting week.

---

## 3. Key Findings & Contributions

The most significant insights and contributions were derived from the RFID behavioural analysis.

* **Significant Health Deviation:** Biting-affected pigs consistently exhibited **shorter feeding durations, fewer meals, and shorter average meal durations** compared to healthy pigs.
* **Temporal Specificity:** Differences in feeding patterns were most pronounced during the **peak biting week**, suggesting a reliable temporal window for detection.
* **Validation of RFID Utility:** The findings indicate that deviations in feeding patterns serve as **potential early indicators** for health issues, proving the utility of RFID data for proactive PLF management.

---

## 4. Repository Structure & Contact

| File / Folder | Purpose |
| :--- | :--- |
| `R_Scripts/` | **[Feeding_Pattern_Analysis.R]** and other core analysis scripts. |
| `data_sample/` | **[Placeholder for anonymized sample RFID log data, if applicable.]** |
| `plots/` | **[Graphs visualizing the Mann-Whitney U test results and feeding behavior comparisons.]** |
| `report/` | **[Final report or presentation material.]** |

---

* **LinkedIn:** [Jiwon Ha's Profile](https://www.linkedin.com/in/jiwon-ha)
* **Email:** `haj180723@gmail.com`
