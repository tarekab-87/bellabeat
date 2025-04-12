# 📊 Data Exploration

## 1️⃣ Exploring the `daily_activity` Table
### 1.1 View All Data
```  
SELECT * FROM `spheric-engine-432411-p0.case_study_2.daily_activity`;
```

### 1.2 Check for Null Values Across Columns
```
SELECT
  COUNT(*) - COUNT(Id) AS id_null,
  COUNT(*) - COUNT(ActivityDate) AS activity_date_null_count,
  COUNT(*) - COUNT(TotalSteps) AS total_steps_null_count,
  COUNT(*) - COUNT(TotalDistance) AS total_distance_null_count,
  COUNT(*) - COUNT(TrackerDistance) AS tracker_distance_null_count,
  COUNT(*) - COUNT(LoggedActivitiesDistance) AS logged_distance_null_count,
  COUNT(*) - COUNT(VeryActiveDistance) AS very_active_distance_null_count,
  COUNT(*) - COUNT(ModeratelyActiveDistance) AS moderate_active_distance_null_count,
  COUNT(*) - COUNT(LightActiveDistance) AS light_active_distance_null_count,
  COUNT(*) - COUNT(SedentaryActiveDistance) AS sedentary_active_distance_null_count,
  COUNT(*) - COUNT(VeryActiveMinutes) AS very_active_minute_null_count,
  COUNT(*) - COUNT(FairlyActiveMinutes) AS fairly_active_minutes_null_count,
  COUNT(*) - COUNT(LightlyActiveMinutes) AS lightly_active_minutes_null_count,
  COUNT(*) - COUNT(SedentaryMinutes) AS sedentary_minutes_null_count,
  COUNT(*) - COUNT(Calories) AS calories_null_count
FROM `spheric-engine-432411-p0.case_study_2.daily_activity`;
```
✅ **No null values found.**

### 1.3 Check for Duplicate Records
```
SELECT
  Id, ActivityDate, TotalDistance, TrackerDistance, LoggedActivitiesDistance, 
  VeryActiveDistance, ModeratelyActiveDistance, LightActiveDistance, 
  SedentaryActiveDistance, VeryActiveMinutes, FairlyActiveMinutes,
  LightlyActiveMinutes, SedentaryMinutes, Calories, 
  COUNT(*) AS duplicate_count
FROM `spheric-engine-432411-p0.case_study_2.daily_activity`
GROUP BY
  Id, ActivityDate, TotalDistance, TrackerDistance, LoggedActivitiesDistance, 
  VeryActiveDistance, ModeratelyActiveDistance, LightActiveDistance, 
  SedentaryActiveDistance, VeryActiveMinutes, FairlyActiveMinutes,
  LightlyActiveMinutes, SedentaryMinutes, Calories
HAVING duplicate_count > 1;
```
✅ **No duplicate records found.**

### 1.4 Check `Id` Column for Data Consistency
```s
SELECT COUNT(*) AS invalid_count
FROM `spheric-engine-432411-p0.case_study_2.daily_activity`
WHERE SAFE_CAST(Id AS FLOAT64) IS NULL;
```
✅ **No inconsistencies found.**

### 1.5 Check `ActivityDate` Column for Valid Date Range
```
SELECT COUNT(*) AS invalid_count
FROM `spheric-engine-432411-p0.case_study_2.daily_activity`
WHERE NOT ActivityDate BETWEEN DATE('2016-03-12') AND DATE('2016-05-12');
```
✅ **All values are within the expected range.**

### 1.6 Check for Negative or Null Values in Key Activity Columns
```
SELECT column_name, COUNT(*) AS null_or_negative_count FROM (
  SELECT 'TotalSteps' AS column_name, TotalSteps FROM `spheric-engine-432411-p0.case_study_2.daily_activity` WHERE TotalSteps IS NULL OR TotalSteps < 0
  UNION ALL
  SELECT 'TrackerDistance', TrackerDistance FROM `spheric-engine-432411-p0.case_study_2.daily_activity` WHERE TrackerDistance IS NULL OR TrackerDistance < 0
  UNION ALL
  SELECT 'LoggedActivitiesDistance', LoggedActivitiesDistance FROM `spheric-engine-432411-p0.case_study_2.daily_activity` WHERE LoggedActivitiesDistance IS NULL OR LoggedActivitiesDistance < 0
  UNION ALL
  SELECT 'VeryActiveDistance', VeryActiveDistance FROM `spheric-engine-432411-p0.case_study_2.daily_activity` WHERE VeryActiveDistance IS NULL OR VeryActiveDistance < 0
  UNION ALL
  SELECT 'ModeratelyActiveDistance', ModeratelyActiveDistance FROM `spheric-engine-432411-p0.case_study_2.daily_activity` WHERE ModeratelyActiveDistance IS NULL OR ModeratelyActiveDistance < 0
  UNION ALL
  SELECT 'LightActiveDistance', LightActiveDistance FROM `spheric-engine-432411-p0.case_study_2.daily_activity` WHERE LightActiveDistance IS NULL OR LightActiveDistance < 0
  UNION ALL
  SELECT 'Calories', Calories FROM `spheric-engine-432411-p0.case_study_2.daily_activity` WHERE Calories IS NULL OR Calories < 0
) AS temp;
```
✅ **No null or negative values found.**

### 1.7 Check for Invalid Records (Sedentary Users with Distance/Steps Logged)
```
SELECT COUNT(*) AS invalid_count
FROM `spheric-engine-432411-p0.case_study_2.daily_activity`
WHERE SedentaryMinutes = 1440 AND TotalDistance <> 0 AND TotalSteps <> 0;
```
⚠️ **17 invalid records found.**

---

## 2️⃣ Exploring the `minute_sleep` Table
### 2.1 View All Data
```
SELECT * FROM `spheric-engine-432411-p0.case_study_2.minute_sleep`;
```
⚠️ **Date format issue detected (Year 2016 interpreted as 0016).**

### 2.2 Check `Id` Column for Validity
```
SELECT COUNT(*) AS invalid_count
FROM `spheric-engine-432411-p0.case_study_2.minute_sleep`
WHERE SAFE_CAST(id AS INT64) IS NULL;
```
✅ **No invalid records found.**

### 2.3 Check for Date Consistency
```
SELECT COUNT(*) AS invalid_count
FROM `spheric-engine-432411-p0.case_study_2.minute_sleep`
WHERE SAFE_CAST(date AS TIMESTAMP) IS NULL;
```
✅ **No format inconsistencies found.**

---

## 3️⃣ Exploring the `hourly_steps` Table
### 3.1 View All Data
```
SELECT * FROM `spheric-engine-432411-p0.case_study_2.hourly_steps`;
```
⚠️ **ActivityHour column contains incorrect year format (0016 instead of 2016).**

### 3.2 Check for Timestamp Consistency
```
SELECT COUNT(*) AS invalid_count
FROM `spheric-engine-432411-p0.case_study_2.hourly_steps`
WHERE SAFE_CAST(ActivityHour AS TIMESTAMP) IS NULL;
```
✅ **No inconsistencies found.**

---

## ✅ Summary of Findings
  
| Issue | Status |
|-------|--------|
| Null values in `daily_activity` | ✅ No null values found |
| Duplicate records in `daily_activity` | ✅ No duplicates found |
| Incorrect `Id` values in `daily_activity` | ✅ No issues found |
| Date range validation | ✅ All values are within range |
| Negative values in key columns | ✅ No negative values found |
| Sedentary users logging distance/steps | ⚠️ 17 invalid records found |
| `minute_sleep` table date format issue | ⚠️ Year 2016 imported as 0016 |
| `hourly_steps` incorrect year format | ⚠️ Year 2016 imported as 0016 |

---
