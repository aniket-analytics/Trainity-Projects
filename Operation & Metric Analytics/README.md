# ⚙️ SQL Project – Operation Analytics & Investigating Metric Spike

## 🧾 Project Overview

**Project Title**: Operation Analytics and Investigating Metric Spike  
**Level**: Intermediate  
**Database**: `job_data`, `tutorial.yammer_events`, `tutorial.yammer_users`, `tutorial.yammer_emails`  

This project focuses on **operation analytics** — analyzing end-to-end company operations — and **investigating metric spikes**, which are critical for monitoring platform health. Using SQL, we derived insights to track throughput, engagement, growth, retention, and anomalies in operational data.

---

## 🎯 Objectives

1. **Job Analytics**: Understand job reviews and throughput trends.  
2. **User Engagement**: Track how users interact weekly and across devices.  
3. **Growth Analysis**: Measure user growth and retention.  
4. **Anomaly Detection**: Investigate duplicate rows and metric spikes.  
5. **Email Engagement**: Analyze open and click-through rates.  

---

## 🛠️ Tech Stack

| Tool / Platform              | Purpose                                |
|-------------------------------|----------------------------------------|
| PostgreSQL v14               | SQL queries & analysis                 |

---

## 🗂 Project Structure

### 1️⃣ Job Analytics

#### a. 📋 Jobs Reviewed  
**Goal**: Number of jobs reviewed per hour in November 2020.  
```sql
SELECT COUNT(DISTINCT job_id)/(30*24)
FROM job_data
WHERE ds BETWEEN '2020-11-01' AND '2020-11-30';
````

#### b. ⚡ Throughput (7-Day Rolling Avg)

**Goal**: Calculate 7-day rolling average of throughput.

```sql
SELECT ds, jobs_reviewed,
       AVG(jobs_reviewed) OVER(ORDER BY ds ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS throughput_7
FROM (
  SELECT ds, COUNT(DISTINCT job_id) AS jobs_reviewed
  FROM job_data
  WHERE ds BETWEEN '2020-11-01' AND '2020-11-30'
  GROUP BY ds
  ORDER BY ds
) a;
```

#### c. 🌍 Language Share

**Goal**: Percentage share of each language over last 30 days.

```sql
SELECT language, num_jobs, 100.0 * num_jobs/total_jobs AS pct_jobs
FROM (
  SELECT language, COUNT(DISTINCT job_id) AS num_jobs
  FROM job_data
  GROUP BY language
) a
CROSS JOIN (SELECT COUNT(DISTINCT job_id) AS total_jobs FROM job_data) b;
```

#### d. 🪞 Duplicate Rows

**Goal**: Identify duplicate records by job\_id.

```sql
SELECT * FROM (
  SELECT *, ROW_NUMBER() OVER(PARTITION BY job_id) AS rownum
  FROM job_data
) a
WHERE rownum > 1;
```

---

### 2️⃣ User Metrics

#### a. 📈 Weekly User Engagement

**Goal**: Count distinct active users per week.

```sql
SELECT EXTRACT(week FROM occurred_at) AS weeknum,
       COUNT(DISTINCT user_id)
FROM tutorial.yammer_events
GROUP BY weeknum;
```

#### b. 🌱 User Growth

**Goal**: Track cumulative growth of active users.

```sql
SELECT year, weeknum, num_active_user,
       SUM(num_active_user) OVER(ORDER BY year, weeknum ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
FROM (
  SELECT EXTRACT(year FROM a.activated_at) AS year,
         EXTRACT(week FROM a.activated_at) AS weeknum,
         COUNT(DISTINCT user_id) AS num_active_user
  FROM tutorial.yammer_users a
  WHERE state='active'
  GROUP BY year, weeknum
  ORDER BY year, weeknum
) a;
```

#### c. 🔄 Weekly Retention

**Goal**: Cohort analysis of user retention.

```sql
SELECT COUNT(user_id),
       SUM(CASE WHEN retention_week = 1 THEN 1 ELSE 0 END) AS week_1
FROM (
  SELECT a.user_id, a.signup_week, b.engagement_week,
         b.engagement_week - a.signup_week AS retention_week
  FROM (
    SELECT DISTINCT user_id, EXTRACT(week FROM occurred_at) AS signup_week
    FROM tutorial.yammer_events
    WHERE event_type = 'signup_flow' AND event_name = 'complete_signup'
      AND EXTRACT(week FROM occurred_at) = 18
  ) a
  LEFT JOIN (
    SELECT DISTINCT user_id, EXTRACT(week FROM occurred_at) AS engagement_week
    FROM tutorial.yammer_events
    WHERE event_type = 'engagement'
  ) b
  ON a.user_id = b.user_id
) c;
```

#### d. 📱 Weekly Engagement per Device

**Goal**: User engagement segmented by device.

```sql
SELECT EXTRACT(year FROM occurred_at) AS year,
       EXTRACT(week FROM occurred_at) AS week,
       device,
       COUNT(DISTINCT user_id)
FROM tutorial.yammer_events
WHERE event_type='engagement'
GROUP BY 1,2,3
ORDER BY 1,2,3;
```

---

### 3️⃣ Email Metrics

#### a. 📧 Email Engagement

**Goal**: Calculate open and click-through rates.

```sql
SELECT 
  100.0*SUM(CASE WHEN email_cat = 'email_open' THEN 1 ELSE 0 END)/
        SUM(CASE WHEN email_cat = 'email_sent' THEN 1 ELSE 0 END) AS email_open_rate,
  100.0*SUM(CASE WHEN email_cat = 'email_clicked' THEN 1 ELSE 0 END)/
        SUM(CASE WHEN email_cat = 'email_sent' THEN 1 ELSE 0 END) AS email_clicked_rate
FROM (
  SELECT *,
         CASE 
           WHEN action IN('sent_weekly_digest','sent_reengagement_email') THEN 'email_sent'
           WHEN action IN('email_open') THEN 'email_open'
           WHEN action IN('email_clickthrough') THEN 'email_clicked'
         END AS email_cat
  FROM tutorial.yammer_emails
) a;
```

---

## 📌 Key Findings

* **Jobs & Throughput**: Throughput shows variability — rolling averages provide a smoother trend for monitoring.
* **Language Distribution**: Certain languages dominate content share, guiding localization strategies.
* **Data Quality**: Duplicate job rows can be identified and flagged.
* **User Engagement**: Weekly active users reveal seasonality patterns.
* **Growth & Retention**: Cohort analysis highlights long-term product stickiness.
* **Email Effectiveness**: Open and click-through rates help optimize marketing communication.

---

## 🧠 Learnings

* Using **window functions** effectively for rolling averages, retention, and cumulative growth.
* Applying **cohort analysis** for user retention tracking.
* Differentiating **daily vs rolling metrics** for operational monitoring.
* Performing **end-to-end operational analytics** using SQL only.

---

## 👨‍💻 Author

**Aniket Yadav**
📧 [Email me](mailto:andyyadav12@gmail.com)
🔗 [LinkedIn Profile](https://www.linkedin.com/in/aniket-yadav-/)

---

> *This project demonstrates advanced SQL for operations and metric investigation — showcasing how data-driven decisions improve platform efficiency and user experience.*

```
