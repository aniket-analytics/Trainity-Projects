CREATE DATABASE ig_clone;
USE ig_clone;

/*Users*/
CREATE TABLE users(
	id INT AUTO_INCREMENT UNIQUE PRIMARY KEY,
	username VARCHAR(255) NOT NULL,
	created_at TIMESTAMP DEFAULT NOW()
);

/*Photos*/
CREATE TABLE photos(
	id INT AUTO_INCREMENT PRIMARY KEY,
	image_url VARCHAR(355) NOT NULL,
	user_id INT NOT NULL,
	created_dat TIMESTAMP DEFAULT NOW(),
	FOREIGN KEY(user_id) REFERENCES users(id)
);

/*Comments*/
CREATE TABLE comments(
	id INT AUTO_INCREMENT PRIMARY KEY,
	comment_text VARCHAR(255) NOT NULL,
	user_id INT NOT NULL,
	photo_id INT NOT NULL,
	created_at TIMESTAMP DEFAULT NOW(),
	FOREIGN KEY(user_id) REFERENCES users(id),
	FOREIGN KEY(photo_id) REFERENCES photos(id)
);

/*Likes*/
CREATE TABLE likes(
	user_id INT NOT NULL,
	photo_id INT NOT NULL,
	created_at TIMESTAMP DEFAULT NOW(),
	FOREIGN KEY(user_id) REFERENCES users(id),
	FOREIGN KEY(photo_id) REFERENCES photos(id),
	PRIMARY KEY(user_id,photo_id)
);

/*follows*/
CREATE TABLE follows(
	follower_id INT NOT NULL,
	followee_id INT NOT NULL,
	created_at TIMESTAMP DEFAULT NOW(),
	FOREIGN KEY (follower_id) REFERENCES users(id),
	FOREIGN KEY (followee_id) REFERENCES users(id),
	PRIMARY KEY(follower_id,followee_id)
);

/*Tags*/
CREATE TABLE tags(
	id INTEGER AUTO_INCREMENT PRIMARY KEY,
	tag_name VARCHAR(255) UNIQUE NOT NULL,
	created_at TIMESTAMP DEFAULT NOW()
);

/*junction table: Photos - Tags*/
CREATE TABLE photo_tags(
	photo_id INT NOT NULL,
	tag_id INT NOT NULL,
	FOREIGN KEY(photo_id) REFERENCES photos(id),
	FOREIGN KEY(tag_id) REFERENCES tags(id),
	PRIMARY KEY(photo_id,tag_id)
);

-- Find the 5 oldest (most loyal) users

SELECT username, created_at
FROM ig_clone.users
ORDER BY created_at
LIMIT 5;

-- Find users who have never posted a photo

SELECT u.username
FROM ig_clone.users u
LEFT JOIN ig_clone.photos p ON u.id = p.user_id
WHERE p.user_id IS NULL
ORDER BY u.username;

-- Identify contest winner (most likes on a single photo)

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

-- Top 5 most used hashtags

SELECT t.tag_name, COUNT(p.photo_id) AS num_tags
FROM ig_clone.photo_tags p
INNER JOIN ig_clone.tags t ON p.tag_id = t.id
GROUP BY t.tag_name
ORDER BY num_tags DESC
LIMIT 5;

-- Find best day of the week to launch ad campaigns

SELECT WEEKDAY(created_at) AS weekday, COUNT(username) AS num_users
FROM ig_clone.users
GROUP BY 1
ORDER BY 2 DESC;

-- Provide how many times does average user posts on Instagram. 
-- Also, provide the total number of photos on Instagram/total number of users
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

-- Detect possible bot accounts (users who liked all photos)

WITH photo_count AS (
  SELECT user_id, COUNT(photo_id) AS num_like
  FROM ig_clone.likes
  GROUP BY user_id
)
SELECT * 
FROM photo_count
WHERE num_like = (SELECT COUNT(*) FROM ig_clone.photos);
