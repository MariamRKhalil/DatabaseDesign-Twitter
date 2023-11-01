
drop database if exists Users;

create database if not exists Users;


USE Users;

CREATE TABLE Users (
  user_id INT PRIMARY KEY AUTO_INCREMENT,
  full_name VARCHAR(255) NOT NULL,
  username VARCHAR(50) UNIQUE NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL,
  password VARCHAR(255) NOT NULL,
  profile VARCHAR(255),
  is_private BOOLEAN DEFAULT FALSE
);

CREATE TABLE Tweet (
   tweet_id INT
   PRIMARY KEY,
   user_id INT,
   content VARCHAR(160) NOT NULL,
   time_tweeted DATETIME NOT NULL,
   FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

CREATE TABLE Hashtag (
  hashtag_id INT PRIMARY KEY,
  hashtag_name VARCHAR(50) UNIQUE NOT NULL  
);

CREATE TABLE Follow (
  follower_id INT,
  followee_id INT,
  PRIMARY KEY (follower_id, followee_id), 
  FOREIGN KEY (follower_id) REFERENCES Users(user_id),
  FOREIGN KEY (followee_id) REFERENCES Users(user_id)
);

CREATE TABLE LikeTweet (
  like_id INT PRIMARY KEY,
  user_id INT,
  tweet_id INT,
  FOREIGN KEY (user_id) REFERENCES Users(user_id),
  FOREIGN KEY (tweet_id) REFERENCES Tweet(tweet_id)
);

CREATE TABLE TweetHashtag (
  tweet_id INT,
  hashtag_id INT,
  FOREIGN KEY (tweet_id) REFERENCES Tweet(tweet_id), 
  FOREIGN KEY (hashtag_id) REFERENCES Hashtag(hashtag_id)
);

-- Example users 
INSERT INTO Users VALUES
  (1, 'Mariam Khalil', 'mariamkhalil', 'khalil@email.com', 'password123', 'I love tweeting!', FALSE),
  (2, 'Mel Smith', 'melsmith', 'smith@email.com', 'password456', 'Tweeting enthusiast', FALSE),
  (3, 'Bob Johnson', 'bobjohnson', 'bob@email.com', 'password789', NULL, TRUE);

-- Example hashtags 
INSERT INTO Hashtag VALUES
  (1, 'newusertoKhourytwitter'),
  (2, 'mondaymotivation');
    
-- Example tweets
INSERT INTO Tweet VALUES
  (1, 1, 'My first tweet! #newusertotwitter', '2023-10-01 12:00:00'),
  (2, 2, 'Good morning everyone! #MondayMotivation', '2023-02-06 09:15:00');

-- Example follows
INSERT INTO Follow VALUES 
  (1, 2), -- Mariam follows Jane
  (2, 1); -- Jane follows Mariam
  
  
-- Which user has the most followers?
SELECT follower_id, COUNT(*) AS followers_count
FROM Follow
GROUP BY follower_id
ORDER BY followers_count DESC
LIMIT 1;


-- For one user, list the five most recent tweets by that user, from newest to oldest. 
-- Include only tweets containing the hashtag "#NEU".
SELECT tweet_id, content, time_tweeted
FROM Tweet
WHERE user_id = 1 -- Replace with the user_id of your choice
AND tweet_id IN (SELECT tweet_id FROM TweetHashtag WHERE hashtag_id = (SELECT hashtag_id FROM Hashtag WHERE hashtag_name = '#NEU'))
ORDER BY time_tweeted DESC
LIMIT 5;

-- what are the most popular hashtags (by count)?
SELECT hashtag_id, COUNT(*) AS usage_count
FROM TweetHashtag
GROUP BY hashtag_id
ORDER BY usage_count DESC;


-- How many tweets have exactly 1 hashtag? Your query output should be a single number.
SELECT COUNT(*) AS tweet_count
FROM (
    SELECT tweet_id, COUNT(*) AS hashtag_count
    FROM TweetHashtag
    GROUP BY tweet_id
    HAVING hashtag_count = 1
) AS SingleHashtagTweets;

-- What is the most liked tweet?

SELECT T.*
FROM Tweet T
WHERE T.tweet_id = (
    SELECT tweet_id
    FROM LikeTweet
    GROUP BY tweet_id
    ORDER BY COUNT(*) DESC
    LIMIT 1
);

-- Use a subquery or subqueries to display a particular user's home timeline.
-- That is, list tweets posted by users that a selected user follows

SELECT tweet_id, content, time_tweeted
FROM Tweet
WHERE user_id IN (
    SELECT followee_id
    FROM Follow
    WHERE follower_id = 1 -- Replace with selected user_id
)
ORDER BY time_tweeted DESC; 

