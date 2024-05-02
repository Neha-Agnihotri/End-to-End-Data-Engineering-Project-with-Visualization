#Trend analysis:

#1. Average movie runtime change over the years
SELECT
    Year,
    AVG(runtimeMinutes) AS AverageRuntime
FROM
    Fact_Movie_Details fmd
INNER JOIN
    DimDate dd ON fmd.DateID = dd.DateID
WHERE
    runtimeMinutes IS NOT NULL AND runtimeMinutes > 0
GROUP BY
    Year
ORDER BY
    Year;

#2. Correlation between the average movie rating and the year of release
SELECT
    Year,
    AVG(averageRating) AS AverageRating
FROM
    Fact_Movie_Details fmd
INNER JOIN
    DimDate dd ON fmd.DateID = dd.DateID
WHERE
    averageRating IS NOT NULL AND averageRating > 0
GROUP BY
    Year
ORDER BY
    Year;

#3. Visualization of the distribution of movie releases per year
SELECT
    Year,
    COUNT(DISTINCT fmd.MovieID) AS NumberOfMoviesReleased
FROM
    Fact_Movie_Details fmd
INNER JOIN
    DimDate dd ON fmd.DateID = dd.DateID
WHERE
    fmd.MovieID IS NOT NULL
GROUP BY
    Year
ORDER BY
    Year;

#Genre Analysis:

#1. Which genres have seen the most significant ratings in popularity over the past decade
SELECT
    GenreName,
    AVG(averageRating) AS AverageRating
FROM
    MovieGenre mg
INNER JOIN
    Fact_Movie_Details fmd ON mg.MovieID = fmd.MovieID
INNER JOIN
    DimDate dd ON fmd.DateID = dd.DateID
WHERE
    Year >= YEAR(CURRENT_DATE) - 10
    AND averageRating IS NOT NULL AND averageRating > 0
GROUP BY
    GenreName
ORDER BY
    AverageRating DESC;

#2. Show the top 5 genres as compared to gross earnings for the 9 box office movies
SELECT
    GenreName,
    SUM(Total_Gross) AS TotalGrossEarnings
FROM
    MovieGenre mg
INNER JOIN
    Fact_Movie_Financials fmf ON mg.MovieID = fmf.MovieID
WHERE
    mg.MovieID IN ('tt0499549', 'tt0120338', ...) -- List the 9 box office movie IDs here
    AND Total_Gross IS NOT NULL AND Total_Gross > 0
GROUP BY
    GenreName
ORDER BY
    TotalGrossEarnings DESC
LIMIT 5;

#Performance Metrics:

#1. Correlation between the movie's runtime and its average rating
SELECT
    CORR(runtimeMinutes, averageRating) AS RuntimeRatingCorrelation
FROM
    Fact_Movie_Details
WHERE
    runtimeMinutes IS NOT NULL AND runtimeMinutes > 0
    AND averageRating IS NOT NULL AND averageRating > 0;

#2. Correlation between the movie's runtime and its average gross
SELECT
    CORR(runtimeMinutes, Total_Gross) AS RuntimeGrossCorrelation
FROM
    Fact_Movie_Financials
WHERE
    runtimeMinutes IS NOT NULL AND runtimeMinutes > 0
    AND Total_Gross IS NOT NULL AND Total_Gross > 0;

#3. Relationship between the number of votes and the average rating of movies
SELECT
    CORR(numVotes, averageRating) AS VotesRatingCorrelation
FROM
    Fact_Movie_Details
WHERE
    numVotes IS NOT NULL AND numVotes > 0
    AND averageRating IS NOT NULL AND averageRating > 0;

#Director Success Metrics:

#1. Identify directors with the most films rated above 7
SELECT
    dd.Director_Name,
    COUNT(DISTINCT fmd.MovieID) AS FilmsAbove7
FROM
    DimDirector dd
INNER JOIN
    Fact_Director_Performance fdp ON dd.DirectorID = fdp.DirectorID
INNER JOIN
    Fact_Movie_Details fmd ON fdp.MovieID = fmd.MovieID
WHERE
    fmd.averageRating > 7
GROUP BY
    dd.Director_Name
ORDER BY
    FilmsAbove7 DESC;

#2. Determine the directors who have directed the highest number of films overall and their respective gross earnings trends
SELECT
    dd.Director_Name,
    COUNT(DISTINCT fmd.MovieID) AS TotalFilmsDirected,
    SUM(ff.Total_Gross) AS TotalGrossEarnings
FROM
    DimDirector dd
INNER JOIN
    Fact_Director_Performance fdp ON dd.DirectorID = fdp.DirectorID
INNER JOIN
    Fact_Movie_Financials ff ON fdp.MovieID = ff.MovieID
WHERE
    dd.Director_Name IS NOT NULL
    AND TotalGrossEarnings IS NOT NULL AND TotalGrossEarnings > 0
GROUP BY
    dd.Director_Name
ORDER BY
    TotalFilmsDirected DESC;

#Actor & Actress

#1. List the top 10 actors/actresses with the most films rated between 4 and 7
SELECT
    da.Actor_Name,
    COUNT(DISTINCT fmd.MovieID) AS FilmsRatedBetween4And7
FROM
    DimActor da
INNER JOIN
    Fact_Actor_Performance fap ON da.ActorID = fap.ActorID
INNER JOIN
    Fact_Movie_Details fmd ON fap.MovieID = fmd.MovieID
WHERE
    fmd.averageRating BETWEEN 4 AND 7
GROUP BY
    da.Actor_Name
ORDER BY
    FilmsRatedBetween4And7 DESC
LIMIT 10;

#Seasonal Analysis:

#1. How does movie performance vary across different seasons of the year? (based on gross earnings)
SELECT
    Season,
    SUM(ff.Total_Gross) AS TotalGrossEarnings
FROM
    DimDate dd
INNER JOIN
    Fact_Movie_Financials ff ON dd.DateID = ff.DateID
WHERE
    TotalGrossEarnings IS NOT NULL AND TotalGrossEarnings > 0
GROUP BY
    Season;

#2. Top 3 movies based on the season (spring, summer, fall)
SELECT
    Season,
    dm.Title AS MovieTitle,
    MAX(ff.Total_Gross) AS HighestGross
FROM
    DimDate dd
INNER JOIN
    Fact_Movie_Financials ff ON dd.DateID = ff.DateID
INNER JOIN
    DimMovie dm ON ff.MovieID = dm.MovieID
WHERE
    HighestGross IS NOT NULL AND HighestGross > 0
GROUP BY
    Season
HAVING
    HighestGross IS NOT NULL
ORDER BY
    Season, HighestGross DESC
LIMIT 3;

#Region Releases:

#1. Identify movies that have had the widest release across multiple regions
SELECT
    dm.Title AS MovieTitle,
    GROUP_CONCAT(DISTINCT mr.RegionName ORDER BY mr.RegionName ASC) AS WidestReleaseRegions
FROM
    DimMovie dm
INNER JOIN
    MovieRegion mr ON dm.MovieID = mr.MovieID
GROUP BY
    dm.Title
HAVING
    COUNT(DISTINCT mr.RegionName) > 1;
