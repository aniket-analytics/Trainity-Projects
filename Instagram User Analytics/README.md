# 📊 SQL Project – Instagram User Analytics

## 🧾 Project Overview

**Project Title**: Instagram User Analytics  
**Level**: Beginner  
**Database**: `ig_clone`  

This project showcases SQL skills for analyzing social media user behavior on Instagram. Using raw user-generated data, we extract actionable insights to support business decisions across marketing, investor relations, and platform optimization. The project includes database setup, exploratory analysis, business-specific queries, and performance metrics.

---

## 🎯 Objectives

1. **Database Setup**: Create and populate the `ig_clone` database with user, photo, like, and tag data.
2. **User & Engagement Insights**: Track user activity, loyalty, and engagement patterns.
3. **Marketing Campaign Support**: Identify top users, hashtags, and optimal ad launch days.
4. **Investor Metrics**: Evaluate platform health via user posting activity and detect potential bot accounts.

---

## 🗂 Project Structure

### 1️⃣ Database Setup

- **Database**: `ig_clone`
- **Tables**:
  - `users` – user profiles and registration info
  - `photos` – user-uploaded content
  - `likes` – user likes on photos
  - `tags` – hashtag definitions
  - `photo_tags` – mapping between photos and hashtags

---

### 2️⃣ Marketing Team Queries

These queries support the marketing team in campaign planning and engagement initiatives.

#### a. 🏆 Rewarding Most Loyal Users  
**Goal**: Identify the 5 oldest registered users.

```sql
SELECT username, created_at
FROM ig_clone.users
ORDER BY created_at
LIMIT 5;
````

#### b. 📩 Remind Inactive Users

**Goal**: Find users who have never posted a photo.

```sql
SELECT u.username
FROM ig_clone.users u
LEFT JOIN ig_clone.photos p ON u.id = p.user_id
WHERE p.user_id IS NULL
ORDER BY u.username;
```

#### c. 🎉 Declare Contest Winner

**Goal**: User whose single photo received the highest likes.

```sql
SELECT username
FROM (
  SELECT likes.photo_id, users.username, COUNT(likes.user_id) AS like_user
  FROM ig_clone.likes
  INNER JOIN ig_clone.photos ON likes.photo_id = photos.id
  INNER JOIN ig_clone.users ON photos.user_id = users.id
  GROUP BY likes.photo_id, users.username
  ORDER BY like_user DESC
  LIMIT 1
) AS base;
```

#### d. 🔍 Hashtag Research

**Goal**: Top 5 most frequently used hashtags.

```sql
SELECT t.tag_name, COUNT(p.photo_id) AS num_tags
FROM ig_clone.photo_tags p
INNER JOIN ig_clone.tags t ON p.tag_id = t.id
GROUP BY t.tag_name
ORDER BY num_tags DESC
LIMIT 5;
```

#### e. 📆 Best Day to Launch Ads

**Goal**: Determine the day of the week when most users register.

```sql
SELECT WEEKDAY(created_at) AS weekday, COUNT(username) AS num_users
FROM ig_clone.users
GROUP BY weekday
ORDER BY num_users DESC;
```

> *Note: MySQL `WEEKDAY()` returns 0 = Monday … 6 = Sunday.*

---

### 3️⃣ Investor Metrics

These queries help investors assess platform activity and detect anomalies like fake accounts.

#### a. 📸 User Engagement

**Goal**: Calculate average photos per user and total counts.

```sql
WITH CTE AS (
  SELECT u.id AS userid, COUNT(p.id) AS photoid
  FROM ig_clone.users u
  LEFT JOIN ig_clone.photos p ON u.id = p.user_id
  GROUP BY u.id
)
SELECT 
  SUM(photoid) AS total_photos,
  COUNT(userid) AS total_users,
  SUM(photoid)/COUNT(userid) AS photo_per_user
FROM CTE;
```

#### b. 🤖 Detect Bot Accounts

**Goal**: Find users who liked *every* photo — a sign of bot-like behavior.

```sql
WITH photo_count AS (
  SELECT user_id, COUNT(photo_id) AS num_like
  FROM ig_clone.likes
  GROUP BY user_id
)
SELECT *
FROM photo_count
WHERE num_like = (SELECT COUNT(*) FROM ig_clone.photos);
```

---

## 📌 Key Findings

* **Loyalty**: The platform has long-time users still active since early registration dates.
* **Inactive Users**: A segment of users have never posted, representing re-engagement potential.
* **Top Hashtags**: Identified high-reach hashtags for better brand targeting.
* **Contest Winner**: Most-liked photo owner can be rewarded in campaigns.
* **Peak Registration Day**: The weekday with highest new user registrations is optimal for ad launches.
* **Engagement Health**: On average, each user posts multiple photos — indicating healthy engagement.
* **Bot Detection**: Potential fake accounts liking every post can be flagged for review.

---

## 📊 Reports Generated

| 📑 Report Name               | 🔍 Description                      |
| ---------------------------- | ----------------------------------- |
| 👥 User Loyalty Report       | Oldest users & active timeframes    |
| 💤 Inactive User Report      | Users with zero posted photos       |
| 🏷 Hashtag Popularity        | Top 5 hashtags with usage counts    |
| 🗓 Registration Trend Report | Weekday-wise user signup counts     |
| 📸 Engagement Report         | Avg. photos per user and totals     |
| 🤖 Bot Detection Report      | Users with suspicious like behavior |
| 🏆 Contest Winner Report     | User with highest-liked photo       |

---

## 🧠 Learnings

* Setting up and querying relational databases using MySQL.
* Applying SQL joins, aggregations, and CTEs to solve real-world business problems.
* Understanding how social media analytics can drive marketing, investor confidence, and product decisions.
* Gaining exposure to anomaly detection (e.g., fake accounts).

---

## 🛠️ Tech Stack

| Tool          | Purpose                           |
| ------------- | --------------------------------- |
| MySQL v8.0    | SQL queries & database operations |
---

## 👨‍💻 Author

**Aniket Yadav**
📧 [Email me](mailto:andyyadav12@gmail.com)
🔗 [LinkedIn Profile](https://www.linkedin.com/in/aniket-yadav-/)

---

> *Thank you for reading! This project is part of my data analytics portfolio showcasing SQL-based analysis on social media user data.*
