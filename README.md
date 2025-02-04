# Spotify_Music_Analysis_SQL

![](https://github.com/DQuanBui/Spotify_Music_Analysis_SQL/blob/main/logo.jpg)

## Project Overview
This project provides a detailed analysis of Spotify's music data, covering its objectives, key findings, and insights into track performance, artist influence, and streaming trends. Using advanced query techniques, the project explores patterns in listener engagement, music attributes, and platform-specific streaming metrics. By leveraging data-driven insights, this analysis helps uncover factors influencing track popularity, artist success, and user behavior, contributing to a deeper understanding of music consumption trends.

The data for this project is sourced from the Kaggle dataset:
- **Dataset Link:** [Spotify_Music_Dataset](https://www.kaggle.com/datasets/sanjanchaudhari/spotify-dataset)

The dataset contains attributes such as:
- `Artist`: The performer of the track.
- `Track`: The name of the song.
- `Album`: The album to which the track belongs.
- `Album_type`: The type of album (e.g., single or album).
- Other metrics such as `danceability`, `energy`, `loudness`, `tempo`, and more.

## Tools 
- Language: SQL
- Tools: PostgreSQL

## Objectives
- Analyze Spotify track, artist, and album data to uncover trends in streaming, popularity, and engagement.
- Use advanced query techniques to identify patterns in music attributes, listener preferences, and platform performance.
- Optimize data retrieval to explore relationships between track features, user interactions, and streaming success.

## Schema
### Create the Spotify table and Importing the Data
```sql
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
```

## Data Exploration Stage
### Dataset Overview
```sql
SELECT 
	COUNT(*) AS Total_Entries,
	COUNT(DISTINCT artist) AS Unique_Artists,
	COUNT(DISTINCT track) AS Unique_Track,
	COUNT(DISTINCT album) AS Unique_Album,
	COUNT(DISTINCT album_type) AS Unique_Album_Type,
	COUNT(DISTINCT channel) AS Unique_Channels
FROM 
	spotify;
```

``` sql
SELECT 
	DISTINCT(most_played_on) AS Platform
FROM 
	spotify;
``` 

## Data Cleaning Stage
### 
```sql
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
```

## Problems/Questions

1. Retrieve the names of all tracks that have more than 1 billion streams.
2. List all albums along with their respective artists.
3. Get the total number of comments for tracks where `licensed = TRUE`.
4. Find all tracks that belong to the album type `single`.
5. Count the total number of tracks by each artist.
6. Calculate the average danceability of tracks in each album.
7. Find the top 10 tracks with the highest energy values.
8. List all tracks along with their views and likes where `official_video = TRUE`.
9. For each album, calculate the total views of all associated tracks.
10. Retrieve the track names that have been streamed on Spotify more than YouTube.
11. Find the top 3 most-viewed tracks for each artist.
12. Find the tracks and artists where the liveness score is above the average.
13. Calculate the difference between the highest and lowest energy values for tracks in each album.
14. Find tracks where the energy-to-liveness ratio is greater than 1.2.
15. List the top 5 artists that have the most albums.
16. Find the top 5 most-streamed tracks for each artist.
17. Retrieve the most-streamed tracks for each platform (Spotify and YouTube)
18. Get the total streams of the previous and next track for each track within an artist

## Solutions
**SQL Solutions:** [Spotify_Music_SQL_Scripts](https://github.com/DQuanBui/Spotify_Music_Analysis_SQL/blob/main/Spotify_Music_Analysis.sql)

## Contact
For any inquiries or questions regarding the project, please contact me at dbui10@fordham.edu
