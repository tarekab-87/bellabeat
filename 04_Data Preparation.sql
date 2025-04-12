# 🛠️ Data Preparation

## 1️⃣ Creating a Clean Daily Activity Table
**Removing 17 invalid records where users were sedentary but recorded distance and steps.**
```
CREATE TABLE `spheric-engine-432411-p0.case_study_2.daily_activity_cleaned` AS 
(
  SELECT * 
  FROM `spheric-engine-432411-p0.case_study_2.daily_activity` 
  WHERE NOT (SedentaryMinutes = 1440 AND TotalDistance <> 0 AND TotalSteps <> 0)
);
```
✅ **Table `daily_activity_cleaned` created with invalid records removed.**

---

## 2️⃣ Creating User Activity Level Tables
Users are categorized based on **average daily steps** into:
- **Sedentary Active:** `< 5000` steps
- **Lightly Active:** `5000 - 7499` steps
- **Fairly Active:** `7500 - 9999` steps
- **Very Active:** `>= 10000` steps

### 📌 Creating `sedentary_users` Table
```
WITH sedentary_users AS (
  SELECT Id, ROUND(AVG(TotalSteps), 2) AS average_steps
  FROM `spheric-engine-432411-p0.case_study_2.daily_activity_cleaned`
  GROUP BY Id
)
SELECT 
  sedentary_users.Id, tem_table_2.*
FROM sedentary_users
INNER JOIN `spheric-engine-432411-p0.case_study_2.daily_activity_cleaned` AS tem_table_2
ON sedentary_users.Id = tem_table_2.Id
WHERE average_steps < 5000;
```

### 📌 Creating `light_users` Table
```
WITH light_users AS (
  SELECT Id, ROUND(AVG(TotalSteps), 2) AS average_steps
  FROM `spheric-engine-432411-p0.case_study_2.daily_activity_cleaned`
  GROUP BY Id
)
SELECT 
  light_users.Id, tem_table_2.*
FROM light_users
INNER JOIN `spheric-engine-432411-p0.case_study_2.daily_activity_cleaned` AS tem_table_2
ON light_users.Id = tem_table_2.Id
WHERE average_steps BETWEEN 5000 AND 7499;
```

### 📌 Creating `fair_users` Table
```
WITH fair_users AS (
  SELECT Id, ROUND(AVG(TotalSteps), 2) AS average_steps
  FROM `spheric-engine-432411-p0.case_study_2.daily_activity_cleaned`
  GROUP BY Id
)
SELECT 
  fair_users.Id, tem_table_2.*
FROM fair_users
INNER JOIN `spheric-engine-432411-p0.case_study_2.daily_activity_cleaned` AS tem_table_2
ON fair_users.Id = tem_table_2.Id
WHERE average_steps BETWEEN 7500 AND 9999;
```

### 📌 Creating `very_active_users` Table
```
WITH very_active_users AS (
  SELECT Id, ROUND(AVG(TotalSteps), 2) AS average_steps
  FROM `spheric-engine-432411-p0.case_study_2.daily_activity_cleaned`
  GROUP BY Id
)
SELECT 
  very_active_users.Id, tem_table_2.*
FROM very_active_users
INNER JOIN `spheric-engine-432411-p0.case_study_2.daily_activity_cleaned` AS tem_table_2
ON very_active_users.Id = tem_table_2.Id
WHERE average_steps >= 10000;
```
✅ **User categories created successfully.**

---

## 3️⃣ Fixing Date Format in `minute_sleep` Table
**Issue:** Year **2016 imported as 0016**  
**Fix:** Adding **2000 years** to adjust incorrectly formatted timestamps.
```
UPDATE `spheric-engine-432411-p0.case_study_2.minute_sleep`
SET date = TIMESTAMP(DATETIME_ADD(CAST(date AS DATETIME), INTERVAL 2000 YEAR))
WHERE EXTRACT(YEAR FROM date) < 1900;
```
✅ **Date format corrected in `minute_sleep` table.**

---

## 4️⃣ Calculating Average Sleep Minutes Per Weekday
**Objective:** Calculate the **average sleep minutes per day of the week** across all users.
```
WITH week_day_table AS (
    SELECT
      Id,
      EXTRACT(DAYOFWEEK FROM date) AS week_day_num,
      FORMAT_TIMESTAMP('%A', date) AS week_day,
      COUNT(*) AS activity_count
    FROM `spheric-engine-432411-p0.case_study_2.minute_sleep`
    WHERE value = 1
    GROUP BY Id, week_day_num, week_day
)
SELECT
  Id, week_day, week_day_num, AVG(activity_count) AS avg_minute_sleep
FROM week_day_table
GROUP BY Id, week_day, week_day_num
ORDER BY week_day_num ASC;
```
✅ **Computed average sleep minutes per weekday.**

---

## 5️⃣ Fixing Date Format in `hourly_steps` Table
**Issue:** Year **2016 imported as 0016**  
**Fix:** Adding **2000 years** to correct incorrect timestamps.
```
UPDATE `spheric-engine-432411-p0.case_study_2.hourly_steps` 
SET ActivityHour = TIMESTAMP(DATETIME_ADD(CAST(ActivityHour AS DATETIME), INTERVAL 2000 YEAR))
WHERE EXTRACT(YEAR FROM ActivityHour) < 1900;
```
✅ **Date format corrected in `hourly_steps` table.**

---

## 6️⃣ Viewing the Cleaned Data
```
SELECT * FROM `spheric-engine-432411-p0.case_study_2.daily_activity_cleaned`;
```
✅ **Final cleaned dataset ready for analysis.**

---

## 🎯 Summary of Fixes & Data Preparation
  
| Task | Status |
|------|--------|
| Removed 17 invalid records from `daily_activity` | ✅ Done |
| Categorized users by activity level | ✅ Done |
| Fixed incorrect year formatting in `minute_sleep` | ✅ Done |
| Computed average sleep minutes per weekday | ✅ Done |
| Fixed incorrect year formatting in `hourly_steps` | ✅ Done |
| Final cleaned dataset is ready for analysis | ✅ Done |

---
