

CREATE TABLE DimDate (
    DateID INT Primary Key,
    Full_Date Date,
    `Year` INT,
    `Month` INT,
    `Quarter` INT,
    `Day` INT,
    Day_Name Varchar(50),
    Season VARCHAR(255)
);
use imdb_src_movie;
CREATE TABLE DimMovie (
    MovieID varchar(50) Primary key,
    Title VARCHAR(255),
    `Type` VARCHAR(50),
    isAdult BOOLEAN,
    startYear INT,
    scd_version int,
    scd_active int,
    scd_start datetime,
    scd_end datetime
);
CREATE TABLE DimDirector (
    DirectorID varchar(50) Primary key,
    Director_Name VARCHAR(255),
    Number_of_films_directed INT
);
CREATE TABLE DimGenre (
    GenreID INT PRIMARY KEY,
    Genre_Name VARCHAR(255)
);

CREATE TABLE DimActor (
    ActorID varchar(50) PRIMARY KEY,
    Actor_Name VARCHAR(255),
    Number_of_films_acted INT
);

CREATE TABLE DimReleaseRegion (
    RegionID INT PRIMARY KEY,
    RegionName VARCHAR(255)
);
CREATE TABLE MovieGenre (
    MovieGenreID INT Primary key,
    MovieID VARCHAR(50),
    GenreID INT,
    GenreName varchar(255),
    DI_CreatedDate datetime,
    DI_FileName varchar(255),
    ProcessID varchar(50),
    FOREIGN KEY (MovieID) REFERENCES DimMovie(MovieID),
    FOREIGN KEY (GenreID) REFERENCES DimGenre(GenreID)
);
CREATE TABLE MovieRegion (
    MovieRegionID INT Primary Key,
    MovieID VARCHAR(50),
    RegionID INT,
    RegionName varchar(50),
    DI_CreatedDate datetime,
    DI_FileName varchar(255),
    ProcessID varchar(50),
    FOREIGN KEY (MovieID) REFERENCES DimMovie(MovieID),
    FOREIGN KEY (RegionID) REFERENCES DimReleaseRegion(RegionID)
);
use imdb_src_movie;
CREATE TABLE Fact_Movie_Details (
    ID INT Primary Key,
    MovieID varchar(50),
    DateID int,
    runtimeMinutes int null,
    averageRating FLOAT null,
    numVotes INT null,
    DI_CreatedDate datetime,
    DI_FileName varchar(255),
    ProcessID varchar(50),
    FOREIGN KEY (MovieID) REFERENCES DimMovie(MovieID),
    FOREIGN KEY (DateID) REFERENCES DimDate(DateID)
);
CREATE TABLE Fact_Movie_Financials (
    ID INT Primary Key,
    MovieID varchar(50),
    DateID INT,
    Total_Gross bigint null,
    number_of_theaters INT null,
    FOREIGN KEY (MovieID) REFERENCES DimMovie(MovieID),
    FOREIGN KEY (DateID) REFERENCES DimDate(DateID)
);

CREATE TABLE Fact_Director_Performance (
    ID INT Primary key,
    DirectorID varchar(50),
    MovieID varchar(50),
    average_rating FLOAT null,
    Total_Gross bigint null,
    DI_CreatedDate datetime,
    DI_FileName varchar(255),
    ProcessID varchar(50),
    FOREIGN KEY (DirectorID) REFERENCES DimDirector(DirectorID),
    FOREIGN KEY (MovieID) REFERENCES DimMovie(MovieID)
);

use imdb_src_movie;
CREATE TABLE Fact_Actor_Performance (
    ID INT Primary key,
    ActorID varchar(50),
    MovieID varchar(50),
    average_rating FLOAT null,
    DI_CreatedDate datetime,
    DI_FileName varchar(255),
    ProcessID varchar(50),
    FOREIGN KEY (ActorID) REFERENCES DimActor(ActorID),
    FOREIGN KEY (MovieID) REFERENCES DimMovie(MovieID)
);

