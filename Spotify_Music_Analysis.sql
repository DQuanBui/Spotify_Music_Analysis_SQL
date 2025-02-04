-- SQL Script for Spotify Music Analysis
-- Author: Dang Quan Bui

-- Create table and Importing the data
DROP TABLE IF EXISTS spotify;
CREATE TABLE spotify (
    artist VARCHAR(255),
    track VARCHAR(255),
    album VARCHAR(255),
    album_type VARCHAR(50),
    danceability FLOAT,
    energy FLOAT,
    loudness FLOAT,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    duration_min FLOAT,
    title VARCHAR(255),
    channel VARCHAR(255),
    views FLOAT,
    likes BIGINT,
    comments BIGINT,
    licensed BOOLEAN,
    official_video BOOLEAN,
    stream BIGINT,
    energy_liveness FLOAT,
    most_played_on VARCHAR(50)
);

SELECT 
	*
FROM 
	spotify;
	
-- ================
-- Data Exploration
-- ================

-- Data Overview
SELECT 
	COUNT(*) AS Total_Entries,
	COUNT(DISTINCT artist) AS Unique_Artists,
	COUNT(DISTINCT track) AS Unique_Track,
	COUNT(DISTINCT album) AS Unique_Album,
	COUNT(DISTINCT album_type) AS Unique_Album_Type,
	COUNT(DISTINCT channel) AS Unique_Channels
FROM 
	spotify;

SELECT 
	DISTINCT(most_played_on) AS Platform
FROM 
	spotify;

SELECT 
	DISTINCT(channel)
FROM 
	spotify;
	
-- ===================
-- Data Cleaning Stage
-- ===================

-- Check the maximum and minimum of duration of track in minutes
SELECT 
	MAX(duration_min) AS max_duration_min,
	MIN(duration_min) AS min_duration_min
FROM 
	spotify;

-- Clean the data by removing the track with 0 duration minute
SELECT
	*
FROM 
	spotify
WHERE
	duration_min = 0;

DELETE FROM spotify
WHERE duration_min = 0;

-- ==============================
-- Dataset Problems and Solutions 
-- ==============================

-- 1/ Look at the name of all tracks that have more than 1 billion streams
SELECT 
	track
FROM 
	spotify
WHERE 	
	stream > 1000000000; 

-- 2/ Look at the albums along with their respective artists
SELECT 
	DISTINCT(album),
	artist
FROM 
	spotify; 

-- 3/ Look at the total number of comments for tracks where license = TRUE
SELECT 
	SUM(comments) AS Total_Comments
FROM 
	spotify
WHERE 
	licensed = 'true'; 

-- 4/ Look at all tracks that belong to the album type 'single'
SELECT
	track
FROM 
	spotify 
WHERE 
	album_type = 'single'; 

-- 5/ Look at the total number of tracks by each artist 
SELECT 
	artist,
	COUNT(track) AS total_track
FROM 
	spotify
GROUP BY 
	artist
ORDER BY 
	total_track DESC; 

-- 6/ Look at the average danceability of tracks in each album
SELECT 
	AVG(danceability) AS Average_Danceability
	album
FROM 
	spotify
GROUP BY 
	album
ORDER BY 
	AVG(danceability) DESC

-- 7/ Look at the top 10 tracks with the highest energy values
SELECT 
	track,
	MAX(energy)
FROM 
	spotify
GROUP BY 
	track
ORDER BY 
	MAX(energy) DESC
LIMIT 10; 

-- 8/ Look at all tracks along with their views and likes where official_video = TRUE
SELECT 
	track,
	SUM(views) AS Total_Views,
	SUM(likes) AS Total_Likes
FROM 
	spotify
WHERE 
	official_video = 'true'
GROUP BY 
	track
ORDER BY 
	SUM(views) DESC;

-- 9/ Look at the total views of all associated track in each album
SELECT 
	album,
	track,
	SUM(views) AS Total_Views
FROM 
	spotify
GROUP BY 
	album,
	track
ORDER BY 
	SUM(views) DESC;

-- 10/ Look at the track names that have been streamed on Spotify more than YouTube
SELECT 
	*
FROM (
	SELECT track,
	COALESCE(SUM(CASE WHEN most_played_on = 'Youtube' THEN stream END), 0) AS stream_on_youtube,
	COALESCE(SUM(CASE WHEN most_played_on = 'Spotify' THEN stream END), 0) AS stream_on_spotify
	FROM spotify
	GROUP BY track
) 
WHERE 
	stream_on_spotify > stream_on_youtube
	AND stream_on_youtube != 0

-- 11/ Look at  the top 3 most-viewed tracks for each artist
WITH ranking_view_track AS (
SELECT 
	artist,
	track,
	SUM(views) AS Total_Views,
	DENSE_RANK() OVER(PARTITION BY artist ORDER BY SUM(Views) DESC) AS rank
FROM 
	spotify
GROUP BY 
	artist,
	track 
ORDER BY 
	1, 3 DESC)
SELECT *
FROM 
	ranking_view_track
WHERE 
	rank BETWEEN 1 AND 3; 

-- 12/ Look at the tracks and artists where the liveness score is above the average
SELECT 
	artist,
	track,
	liveness
FROM 
	spotify
WHERE 
	liveness > (SELECT AVG(liveness) FROM spotify); 

-- 13/ Look at the difference between the highest and lowest energy values for tracks in each album
WITH album_energy AS(
SELECT 
	album,
	MAX(energy) AS highest_energy,
	MIN(energy) AS lowest_energy
FROM 
	spotify
GROUP BY 
	album)
SELECT 
	album,
	ROUND((highest_energy - lowest_energy)::NUMERIC, 2) AS energy_difference
FROM 
	album_energy
ORDER BY 
	ROUND((highest_energy - lowest_energy)::NUMERIC, 2) DESC;

-- 14/ Look at the tracks where the energy-to-liveness ratio is greater than 1.2
SELECT 
	track,
	ROUND((energy / liveness)::NUMERIC, 2) AS energy_to_liveness
FROM 
	spotify
WHERE 
	ROUND((energy / liveness)::NUMERIC, 2) > 1.2
ORDER BY 
	energy_to_liveness; 

-- 15/ Look at the top 5 artists that have the most albums
SELECT 
	artist,
	COUNT(DISTINCT album)
FROM 
	spotify
GROUP BY 
	artist 
ORDER BY 
	COUNT(DISTINCT album) DESC
LIMIT 5; 

-- 16/ Look at the top 5 most-streamed tracks for each artist
WITH stream_rank AS (
    SELECT artist, track, stream,
    	RANK() OVER (PARTITION BY artist ORDER BY stream DESC) AS track_rank
    FROM spotify
)
SELECT 
	artist, 
	track, 
	stream
FROM 
	stream_rank
WHERE 
	track_rank <= 5;

-- 17/ Look at the most-streamed tracks for each platform (Spotify and YouTube)
WITH platform_stream_rank AS (
    SELECT most_played_on, track, stream,
           RANK() OVER (PARTITION BY most_played_on ORDER BY stream DESC) AS platform_rank
    FROM spotify
)
SELECT 
	most_played_on, 
	track, 
	stream
FROM 
	platform_stream_rank
WHERE 
	platform_rank = 1;

-- 18/ Look at the streams of the previous and next track for each track within an artist
SELECT 
	artist, 
	track, 
	stream,
    LAG(stream) OVER (PARTITION BY artist ORDER BY stream DESC) AS previous_stream,
    LEAD(stream) OVER (PARTITION BY artist ORDER BY stream DESC) AS next_stream
FROM 
	spotify;

-- =========================================
-- The End of Spotify Music Analysis Project
-- =========================================