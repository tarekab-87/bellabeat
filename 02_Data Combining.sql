# 🏋️‍♂️ Merging Tables in SQL for Case Study 2

## 📌 Overview
This script merges datasets from two time periods (**03/12/2016 – 04/11/2016** and **04/12/2016 – 05/12/2016**) into unified tables for analysis.

---

## 🗂 Merge Daily Activity Tables
Combines `daily_activity_1` and `daily_activity_2` into a single `daily_activity` table.

CREATE TABLE `spheric-engine-432411-p0.case_study_2.daily_activity` AS 
(
  SELECT * FROM `spheric-engine-432411-p0.case_study_2.daily_activity_1` 
  UNION ALL
  SELECT * FROM `spheric-engine-432411-p0.case_study_2.daily_activity_2` 
);

---

## 🗂  Merge Minute-Level Sleep Data
Combines minute_sleep_1_v1 and minute_sleep_2_v1 into a unified minute_sleep table.

CREATE TABLE `spheric-engine-432411-p0.case_study_2.minute_sleep` AS 
(
  SELECT * FROM `spheric-engine-432411-p0.case_study_2.minute_sleep_1_v1`
  UNION ALL
  SELECT * FROM `spheric-engine-432411-p0.case_study_2.minute_sleep_2_v1`
);

---

## 🗂 Merge Hourly Steps Data
Combines hourly_steps_1 and hourly_steps_2 into a single hourly_steps table for step activity tracking.

CREATE TABLE `spheric-engine-432411-p0.case_study_2.hourly_steps` AS 
(
  SELECT * FROM `spheric-engine-432411-p0.case_study_2.hourly_steps_1`
  UNION ALL
  SELECT * FROM `spheric-engine-432411-p0.case_study_2.hourly_steps_2`
);

  

