# 📊 Instagram User Analytics – SQL Project

## 🧾 Project Overview

**Project Title**: Instagram User Analytics
**Level**: Beginner
**Database**: `ig_clone`

This project demonstrates SQL skills for analyzing user activity and engagement on a simulated Instagram-like platform. The focus is on answering business questions relevant to marketing and investor teams, using SQL queries to extract insights from user, post, like, and hashtag data.

---

## 🎯 Objectives

1. **Database Setup**: Create and populate an Instagram-style database using raw data.
2. **Marketing Insights**: Help the marketing team with user retention, campaign planning, and hashtag analysis.
3. **Investor Metrics**: Provide metrics on user engagement, platform health, and potential fake activity.
4. **SQL Query Practice**: Solve realistic business problems using SQL joins, aggregations, and filtering.

---

## 🗂️ Project Structure

### 1. Database Setup

* **Database**: A MySQL database named `ig_clone` was used.
* **Tables**: Key tables include:

  * `users` – User info like username and account creation date.
  * `photos` – Posts made by users.
  * `likes` – Likes made by users on photos.
  * `tags` & `photo_tags` – Hashtags associated with photos.

The project was executed using [db-fiddle.com](https://www.db-fiddle.com) with MySQL 8.0.

---

## 🔍 Marketing Use Cases & Queries

### 📌 Q1: Find the 5 oldest (most loyal) users

```sql
SELECT username, created_at
FROM ig_clone.users
ORDER BY created_at
LIMIT 5;
```

### 📌 Q2: Find users who have never posted a photo

```sql
SELECT u.username
FROM ig_clone.users u
LEFT JOIN ig_clone.photos p ON u.id = p.user_id
WHERE p.user_id IS NULL
ORDER BY u.username;
```

### 📌 Q3: Identify contest winner (most likes on a single photo)

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
) base;
```

### 📌 Q4: Top 5 most used hashtags

```sql
SELECT t.tag_name, COUNT(p.photo_id) AS num_tags
FROM ig_clone.photo_tags p
INNER JOIN ig_clone.tags t ON p.tag_id = t.id
GROUP BY t.tag_name
ORDER BY num_tags DESC
LIMIT 5;
```

### 📌 Q5: Find best day of the week to launch ad campaigns

```sql
SELECT WEEKDAY(created_at) AS weekday, COUNT(username) AS num_users
FROM ig_clone.users
GROUP BY 1
ORDER BY 2 DESC;
```

> Days: 0 = Monday, ..., 6 = Sunday

---

## 📈 Investor Metrics & Queries

### 📌 Q1: Average number of posts per user

```sql
WITH CTE AS (
  SELECT u.id AS userid, COUNT(p.id) AS photoid
  FROM ig_clone.users u
  LEFT JOIN ig_clone.photos p ON u.id = p.user_id
  GROUP BY u.id
)
SELECT SUM(photoid)/COUNT(userid) AS photo_per_user
FROM CTE
WHERE photoid > 0;
```

### 📌 Q2: Total photos, users, and average photos per user

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

### 📌 Q3: Detect possible bot accounts (users who liked all photos)

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

## 📊 Findings

* **Loyal Users**: The oldest users are early adopters, useful for loyalty campaigns.
* **Inactive Users**: Several users have never posted, which can be targeted via reminders.
* **Engagement Leader**: Contest winners can be identified based on like count per photo.
* **Hashtag Strategy**: Top 5 hashtags provide direction for better content reach.
* **Ad Timing**: Most user registrations happen on a specific day of the week—ideal for campaign launches.
* **Platform Activity**: Healthy average post count per user; useful metric for investors.
* **Bot Detection**: SQL can help identify suspicious user patterns like liking every photo.

---

## 📝 Reports

* **User Report**: Oldest users, inactive users, and top contest winner.
* **Hashtag Report**: Top-performing hashtags.
* **Ad Campaign Report**: Best day to launch ads based on user registration trends.
* **Engagement Report**: Average posts per user, total photos, and bot detection.

---

## ✅ Conclusion

This project showcases how SQL can be applied to real-world social media analytics. It covers:

* Data extraction & joining
* Aggregations & filtering
* Answering marketing and investor queries
* Detecting suspicious activity

The insights derived are valuable for marketing teams, business strategy, and platform growth monitoring.

---

## 👨‍💻 Author – Aniket Yadav

This project is part of my SQL portfolio demonstrating data analysis for social media platforms.

* **LinkedIn**: [Connect with me](https://www.linkedin.com/in/aniket-yadav-/)
* **Gmail**: [andyyadav12@gmail.com](mailto:andyyadav12@gmail.com)

---

Let me know if you'd like this in `.docx` or `.pdf` format or want a `README.md` file generated for direct download.
