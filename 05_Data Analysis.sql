# 📊 Data Analysis 

## 1️⃣ Counting Total Users
```
SELECT COUNT(DISTINCT(Id)) AS users_count
FROM `spheric-engine-432411-p0.case_study_2.daily_activity_cleaned`;
```
✅ **Total Users:** 35

---

## 2️⃣ Average Daily Steps & Calories Per Weekday
```
WITH week_day_table AS (
    SELECT
      Id,
      TotalSteps,
      Calories,
      FORMAT_TIMESTAMP('%A', ActivityDate) AS week_day,
      EXTRACT(DAYOFWEEK FROM ActivityDate) AS week_day_number
    FROM `spheric-engine-432411-p0.case_study_2.daily_activity_cleaned`
)
SELECT
  Id,
  week_day,
  week_day_number,
  ROUND(AVG(TotalSteps), 2) AS avg_daily_steps,
  ROUND(AVG(Calories), 2) AS avg_daily_calories
FROM week_day_table
GROUP BY Id, week_day, week_day_number
ORDER BY week_day_number ASC;
```
✅ **Average Daily Steps:** Below recommended range (8000-10000)  
✅ **Average Calories Burned:** Within adult range (1200-2400)

---

## 3️⃣ Categorizing Users by Activity Level
**Classifications:**
- **Sedentary Active:** `< 5000` steps
- **Lightly Active:** `5000 - 7499` steps
- **Fairly Active:** `7500 - 9999` steps
- **Very Active:** `>= 10000` steps

### 📝 Method 1: Using CROSS JOIN
```
WITH average_steps_table AS (
    SELECT Id, ROUND(AVG(TotalSteps), 2) AS average_steps
    FROM `spheric-engine-432411-p0.case_study_2.daily_activity_cleaned`
    WHERE NOT (SedentaryMinutes = 1440 AND TotalDistance = 0 AND TotalSteps = 0)
    GROUP BY Id
)
SELECT * 
FROM (
  SELECT ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM average_steps_table), 2) AS sedentary_active_percentage FROM average_steps_table WHERE average_steps < 5000
) sedentary_active_users
CROSS JOIN (
  SELECT ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM average_steps_table), 2) AS lightly_active_percentage FROM average_steps_table WHERE average_steps BETWEEN 5000 AND 7499
) lightly_active_users
CROSS JOIN (
  SELECT ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM average_steps_table), 2) AS fairly_active_percentage FROM average_steps_table WHERE average_steps BETWEEN 7500 AND 9999
) fairly_active_users
CROSS JOIN (
  SELECT ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM average_steps_table), 2) AS very_active_percentage FROM average_steps_table WHERE average_steps >= 10000
) very_active_users;
```

### 📝 Method 2: Using CASE Statement
```
WITH average_steps_table AS (
    SELECT Id, ROUND(AVG(TotalSteps), 2) AS average_steps
    FROM `spheric-engine-432411-p0.case_study_2.daily_activity_cleaned`
    WHERE NOT (SedentaryMinutes = 1440 AND TotalDistance = 0 AND TotalSteps = 0)
    GROUP BY Id
)
SELECT
  ROUND(SUM(CASE WHEN average_steps < 5000 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS sedentary_active_percentage,
  ROUND(SUM(CASE WHEN average_steps BETWEEN 5000 AND 7499 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS lightly_active_percentage,
  ROUND(SUM(CASE WHEN average_steps BETWEEN 7500 AND 9999 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS fairly_active_percentage,
  ROUND(SUM(CASE WHEN average_steps >= 10000 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS very_active_percentage
FROM average_steps_table;
```
✅ **Sedentary Users:** 37.14%  
✅ **Lightly Active Users:** 20.0%  
✅ **Fairly Active Users:** 22.86%  
✅ **Very Active Users:** 20.0%  

---

## 4️⃣ Hourly Steps per Weekday
```
SELECT
  Id,
  FORMAT_TIMESTAMP('%A', ActivityHour) AS week_day,
  EXTRACT(DAYOFWEEK FROM ActivityHour) AS week_day_num,  
  ROUND(AVG(StepTotal),2) AS avg_steps,
  EXTRACT(HOUR FROM ActivityHour) AS day_hour
FROM `spheric-engine-432411-p0.case_study_2.hourly_steps`
GROUP BY Id, week_day, week_day_num, day_hour
ORDER BY week_day_num, day_hour ASC;
```

---

## 5️⃣ Correlation Between Steps, Sleep, and Calories
```
WITH steps_table AS (
  SELECT
    Id,
    FORMAT_TIMESTAMP('%A', ActivityHour) AS week_day,
    EXTRACT(DAYOFWEEK FROM ActivityHour) AS week_day_num,
    ROUND(AVG(StepTotal), 2) AS avg_steps_per_hour,
    SUM(StepTotal) AS total_daily_steps,
    EXTRACT(DATE FROM ActivityHour) AS activity_date
  FROM `spheric-engine-432411-p0.case_study_2.hourly_steps`
  GROUP BY Id, week_day, week_day_num, activity_date
),
sleep_table AS (
  SELECT
    Id,
    FORMAT_TIMESTAMP('%A', date) AS week_day,
    EXTRACT(DAYOFWEEK FROM date) AS week_day_num,
    SUM(value) AS total_sleep_minutes,
    EXTRACT(DATE FROM date) AS sleep_date
  FROM `spheric-engine-432411-p0.case_study_2.minute_sleep`
  GROUP BY Id, week_day, week_day_num, sleep_date
)
SELECT
  steps_table.Id,
  steps_table.week_day,
  steps_table.week_day_num,
  steps_table.total_daily_steps,
  sleep_table.total_sleep_minutes
FROM steps_table
LEFT JOIN sleep_table
ON steps_table.Id = sleep_table.Id AND steps_table.activity_date = sleep_table.sleep_date
ORDER BY steps_table.week_day_num;
```

---

## 5️⃣ Device Usage Distribution (Low, Moderate, High Use)
```sql
WITH user_usage_counts AS (
  SELECT Id, COUNT(*) AS usage_count
  FROM `spheric-engine-432411-p0.case_study_2.daily_activity_cleaned`
  GROUP BY Id
),
usage_levels AS (
  SELECT Id,
    CASE 
      WHEN usage_count >= 45 THEN 'High Use'
      WHEN usage_count BETWEEN 16 AND 44 THEN 'Moderate Use'
      ELSE 'Low Use'
    END AS usage_level
  FROM user_usage_counts
)
SELECT usage_level, COUNT(*) AS count, ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM usage_levels), 2) AS percentage
FROM usage_levels
GROUP BY usage_level
ORDER BY percentage DESC;
```
✅ **Low Use:** 5.71%  
✅ **Moderate Use:** 77.15%  
✅ **High Use:** 17.14%

---
