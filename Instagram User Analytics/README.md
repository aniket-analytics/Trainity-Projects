# SQL-Project-Instagram-User-Analytics

## Project Overview

**Project Title**: Instagram User Analytics  
**Level**: Beginner  
**Database**: `ig_clone`

This project demonstrates SQL skills and techniques used by data analysts to explore and analyze Instagram user behavior data. The project focuses on helping marketing teams launch effective campaigns and providing investors with insights into platform performance and user engagement patterns.

## Objectives

1. **Marketing Analysis**: Support marketing team campaigns by analyzing user behavior and engagement patterns.
2. **User Engagement Assessment**: Measure platform activity and user posting frequency.
3. **Contest Management**: Identify contest winners based on photo engagement metrics.
4. **Hashtag Strategy**: Research and recommend optimal hashtags for maximum reach.
5. **Ad Campaign Optimization**: Determine the best days for launching advertising campaigns.
6. **Platform Health**: Assess Instagram's performance and identify potential bot accounts.

## Project Structure

### 1. Database Setup

- **Database**: The project uses the `ig_clone` database containing Instagram-like user data.
- **Tables Used**: 
  - `users`: User information and registration data
  - `photos`: Photo posts and metadata
  - `likes`: User likes on photos
  - `photo_tags`: Photo-hashtag relationships
  - `tags`: Hashtag information

### 2. Marketing Analysis

The marketing team requires insights for campaign planning and user engagement strategies.

#### A. Rewarding Most Loyal Users
**Objective**: Find the 5 oldest users on the platform for loyalty rewards.

```sql
SELECT
    username,
    created_at
FROM
    ig_clone.users
ORDER BY created_at
LIMIT 5;
```

#### B. Reactivating Inactive Users
**Objective**: Identify users who have never posted photos for targeted email campaigns.

```sql
SELECT
    u.username
FROM
    ig_clone.users u
LEFT JOIN
    ig_clone.photos p ON u.id = p.user_id
WHERE
    p.user_id IS NULL
ORDER BY
    u.username;
```

#### C. Contest Winner Declaration
**Objective**: Find the user with the most likes on a single photo to declare contest winner.

```sql
SELECT username FROM
(
    SELECT
        likes.photo_id,
        users.username,
        COUNT(likes.user_id) AS like_count
    FROM
        ig_clone.likes likes
    INNER JOIN
        ig_clone.photos photos ON likes.photo_id = photos.id
    INNER JOIN
        ig_clone.users users ON photos.user_id = users.id
    GROUP BY
        likes.photo_id, users.username
    ORDER BY
        like_count DESC
    LIMIT 1
) base;
```

#### D. Hashtag Research
**Objective**: Identify top 5 most commonly used hashtags for brand partnership campaigns.

```sql
SELECT
    t.tag_name,
    COUNT(p.photo_id) AS usage_count
FROM
    ig_clone.photo_tags p
INNER JOIN
    ig_clone.tags t ON p.tag_id = t.id
GROUP BY
    tag_name
ORDER BY
    usage_count DESC
LIMIT 5;
```

#### E. Optimal Ad Campaign Timing
**Objective**: Determine the best day of the week to launch ad campaigns based on user registration patterns.

```sql
-- Day mapping: 0=Monday, 1=Tuesday, 2=Wednesday, 3=Thursday, 4=Friday, 5=Saturday, 6=Sunday
SELECT
    WEEKDAY(created_at) AS weekday,
    COUNT(username) AS registration_count
FROM
    ig_clone.users
GROUP BY 1
ORDER BY 2 DESC;
```

### 3. Investor Metrics

Investors need insights into platform performance and user engagement health.

#### A. User Engagement Analysis
**Objective**: Calculate average posts per user and overall platform activity metrics.

```sql
WITH user_photo_counts AS (
    SELECT
        u.id AS user_id,
        COUNT(p.id) AS photo_count
    FROM
        ig_clone.users u
    LEFT JOIN
        ig_clone.photos p ON u.id = p.user_id
    GROUP BY
        u.id
)
SELECT
    SUM(photo_count)/COUNT(user_id) AS photos_per_active_user
FROM
    user_photo_counts
WHERE
    photo_count > 0;

-- Overall platform metrics
SELECT
    SUM(photo_count) AS total_photos,
    COUNT(user_id) AS total_users,
    SUM(photo_count)/COUNT(user_id) AS photos_per_user_overall
FROM
    user_photo_counts;
```

#### B. Bot Detection Analysis
**Objective**: Identify potential bot accounts that have liked every photo on the platform.

```sql
WITH user_like_counts AS (
    SELECT
        user_id,
        COUNT(photo_id) AS total_likes
    FROM
        ig_clone.likes
    GROUP BY
        user_id
    ORDER BY
        total_likes DESC
)
SELECT *
FROM
    user_like_counts
WHERE
    total_likes = (SELECT COUNT(*) FROM ig_clone.photos);
```

## Key Findings

- **Loyal User Base**: Identified the 5 most loyal users based on account creation date for targeted reward campaigns.
- **Inactive Users**: Discovered users who haven't posted any photos, representing opportunities for re-engagement campaigns.
- **Contest Insights**: Successfully identified contest winner based on photo engagement metrics.
- **Hashtag Strategy**: Top 5 hashtags provide clear direction for brand partnerships and content strategy.
- **Peak Registration Days**: Identified optimal days for ad campaign launches based on historical user registration patterns.
- **User Engagement**: Calculated average posting frequency to assess platform health and user activity levels.
- **Bot Detection**: Identified potential bot accounts through abnormal liking patterns for platform integrity.

## Business Impact

### Marketing Team Benefits:
- **Targeted Campaigns**: Data-driven insights for user segmentation and campaign targeting
- **Content Strategy**: Hashtag recommendations for maximum reach and engagement
- **Timing Optimization**: Optimal ad campaign scheduling based on user behavior patterns
- **User Retention**: Identification of inactive users for re-engagement initiatives

### Investor Insights:
- **Platform Health**: User engagement metrics demonstrate platform vitality
- **Growth Potential**: Analysis of user posting behavior and platform activity
- **Quality Assurance**: Bot detection capabilities ensure authentic user base
- **Performance Benchmarks**: Clear metrics for comparing platform performance over time

## Technical Implementation

- **Database**: MySQL v8.0
- **Platform**: DB-Fiddle (https://www.db-fiddle.com/)
- **Query Techniques**: JOINs, CTEs, Window Functions, Aggregations, Subqueries
- **Analysis Focus**: User behavior patterns, engagement metrics, and platform health indicators

## Reports Generated

- **Marketing Report**: User loyalty, contest results, and hashtag recommendations
- **Engagement Report**: User activity levels and posting frequency analysis  
- **Platform Health Report**: Bot detection and user authenticity metrics
- **Campaign Optimization Report**: Timing recommendations and user segmentation insights

## Conclusion

This project demonstrates comprehensive SQL analysis capabilities for social media platform analytics. The insights generated support both marketing initiatives and investor decision-making by providing clear, data-driven recommendations for platform growth and user engagement optimization.

The analysis reveals Instagram's healthy user engagement patterns while identifying opportunities for improved marketing campaigns and platform integrity measures.

## Author - Aniket Yadav

This project is part of my portfolio to showcase data analysis using SQL for social media analytics.

- **LinkedIn**: [Connect with me professionally](https://www.linkedin.com/in/aniket-yadav-/)
- **Gmail**: [Connect with me professionally](mailto:andyyadav12@gmail.com)

Thank you for your support, and I look forward to connecting with you!
