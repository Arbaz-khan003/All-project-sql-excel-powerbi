
                        segment 1: --Database - Tables, Columns, Relationships

--What are the different tables in the database and how are they connected to each other in the database?
--Find the total number of rows in each table of the schema.
--Identify which columns in the movie table have null values.

QUESTION 1)--What are the different tables in the database and how are they connected to each other in the database?
ANSWER 1)   There are six table in databases i.e movie,genre,director_mapping,role_mapping,names,ratings.
            They may be connected by join,subquery on the behalf of primary id and other id of different table in the 
            same databases.


QUESTION 2)-- Find the total number of rows in each table of schema
ANSWER 2)

     select COUNT(*) as genre_count from genre;
     select COUNT(*) as name_count from names;
     select COUNT(*) as project_count from project;
       select COUNT(*) as rating_count from rating;
       select COUNT(*) as role_mapping_count from role_mapping;
       select COUNT(*) as movie_count from movie;

QUESTION 3)-- identify which column have null value in movies table
ANSWER 3)
--by using case STATEMENT 
         select 
         sum(case when year = ' ' then 1 else 0 end) as year_null,
          sum(case when title = ' ' then 1 else 0 end) as title_null,
          sum(case when country = '' then 1 else 0 end) as country_null,
           sum(case when languages = '' then 1 else 0 end) as language_null,
           sum(case when production_company = ' ' then 1 else 0 end) as production_null;
            sum(case when worlwide_gross_income = ' ' then 1 else 0) as worlwide_gross_income_null,
             sum(case when date_published = ' ' then 1 else 0 ) as date_published_null,
           from movie ;


                            segment 2: --MOVIE RELEASE
							  
QUESTION 1)--Determine the total number of movies released each year and analyse the month wise trend
ANSWER 1)
	
	select year,substr(date_published,4,2) as month_count,count(title) as number_of_movie_released 
    from movie
    group by year ,substr(date_published,4,2)
    order by year ,month_count ;
	
--	part-2 ANSWER
	
	select year,count(*) as number_of_movie_released
	from movie
	group by year
	order by year;
     
--	 part-2a ANSWER
	 
	 select substr(date_published,4,2) as month_count,count(*) as  number_of_movie_released
     from movie
     group by substr(date_published,4,2)
     order by month_count ;

        	
QUESTION 2) --calculate the number of  movies produced  in the USA  OR INDIA in the year 2019
  ANSWER 2)
  
   select count(id) as movie_produced_in_2019 
   from movie
   where (country like'%USA%' or country like '%India%') and year =2019;
   
                        --or
						
    select count(id) as movie_produced_in_2019
    from movie
	where  (lower(country like'%usa%' or LOWER(country) like'%india%') and year =2019;
	
						--or
     select count(*) as movie_produced_in_2019
     from movie
     where country in ('USA','India')	 and year in(2019);
                          
						  --or
	 select count(*) as movie_produced_in_2019
	 from movie
	 where year = '2019' and (country = 'USA' or country = 'India');
 

 
                              segment 3 :-- Production statistics  and genre analysis
 
 --Retrieve the unique list of genre present in the database
 --identify  genre with highest number of movie produced overall
 --Determine the count of movie that belong to only one genre
 --calculate the average duration of the movie in each genre
 --Find the rank of the thriller genre among all genres in terms of number of movies produced
 

 question 1 -	--Retrieve the unique list of genres present in the dataset.
 ANSWER 1)
 
                 select Distinct genre from genre;
                            
							--OR 
                          
                 select genre from genre
                   group by genre;
				   
question 2) identify the genre with highest number of movie produced overall
ANSWER 2)

              select genre,count(id) as highest_number_of_movie
              from genre g
              join movie m
              on m.id=g.movie_id 
              group by genre  
              order by count(id) desc
               limit 1;       
				 
						--or
			 
               select genre,count(movie_id) as  highest_number_of_movie
               from genre 
               group by genre
               order by count(movie_id) desc
			   limit 1;
               
			
                           --or

            with summary as   
            (
	         SELECT id, g.genre,count( genre)as genre_name FROM movie m
             left join genre g on m.id=g.movie_id
             group by id,g.genre
	        )
            select genre,
	        count(id) as movies 
	        from summary
            group by genre
             limit 1;

						   


question 3) --Determine the count of movie that belong to only one genre

  
                  select count(movie_id) from
              (
                  select movie_id,count(genre) AS genre_count
               from genre
              group by movie_id
              ) A
                 WHERE A.genre_count =1;

  
                              
  
  ASSIGNMENT--  --Determine the movie that belong to only one genre   
	   
	            
              select movie_id,count(genre)
               from genre 
              group by movie_id
              having count(genre)=1;
    
				
               
question 4) --calculate the average duration of the movie in each genre



        select genre,avg(duration)as avg_duration 
       from movie m 
       join genre g 
        on m.id=g.movie_id
        group by genre
        order by avg_duration desc;



question 5) --Find the rank of the thriller genre among all genres in terms of number of movies produced

      with rank_summary as
       (select genre,count(movie_id) as movie_count
        rank() over (order by count(movie_id) desc) as genre_rank
       from gerne
        group by genre  
       ) 
    select * from rank_summary
   where lower(genre)='thriller';



         
                   segment 4: --Rating analysis and crew members
 
 -- Retrieve the minimum and maximum value in each column of the rating  table(except movie_id)
 --Identify the top 10 movies based on the average rating
 -- Summarise the Rating table based on movie count by median rating.
 --identify the production house that has produced the most number of hit movies (average rating>0),
 -- Determin the number of movies released in each genre during  March 2017  in the USA  with more  than 1000 votes
 -- Retrieve movie of each genre starting  with the word 'The' and having  and average rating >8
 
 question 1)-- Retrieve the minimum and maximum value in each column of the rating  table(except movie_id)
answer 1)
 
           select max(avg_rating) as  maximum_average_rating,
             min(avg_rating) as  minimum_average_rating,
            max(total_votes) as maximum_total_votes, 
          min(total_votes) as minimum_total_votes,
           max(median_rating) as maximum_median_rating,
           min(median_rating) as minimum_median_rating
          from ratings;
 
 
 question 2) --Identify the top 10 movies based on the average rating
  answer 2) 
               select sum(avg_rating),title
                     from ratings r
                     join movie m
                     on r.movie_id=m.id
                 group by  title
                order by  sum(avg_rating) desc
                  limit 10;
                                
                         or
                         
          with top_movies as
          ( 
          select avg_rating,m.title
          Rank()  over (order by avg_rating desc) as movie_rank
          from movie m
          left join ratings r
          on r.movie_id=m.id
          )
          select * from top_movies
          where movie_rank <=10;
                      
                                      
                               or
              
              select avg_rating,title
                     from ratings r
                     join movie m
                     on r.movie_id=m.id
                order by  avg_rating desc
                  limit 10;
                                       



QUESTION 3) -- Summarise the Rating table based on movie count by median rating.
ANSWER 3)

           select median_rating,count(movie_id)as Num_of_Movies 
          from ratings
              group by median_rating
              order by median_rating desc;
             

QUESTION 4) --identify the production house that has produced the most number of hit movies (average rating>8),
ANSWER--4)            
            SELECT production_company,count(id)as movie_count ,avg_rating
            from movie m
                left join ratings r 
                on  m.id=r.movie_id
                where  production_company is not null and avg_rating > 8
                group by production_company ,avg_rating
              order by count(id) desc,avg_rating desc	;

                   or
 
            SELECT production_company,count(id)as movies 
            from movie m
                left join ratings r 
                on  m.id=r.movie_id
                where r.avg_rating>8 
                group by production_company 
              order by count(id) desc;	


QUESTION 5) --Determin the number of movies released in each genre during  March 2017  in the USA  with more  than 1000 votes

ANSWER 5--)

          SELECT g.genre,count(id) 
          from movie m
          left join genre g 
            on m.id=g.movie_id
          left join ratings r 
          on m.id=r.movie_id
        where year='2017' and lower(country) like '%usa%' AND total_votes>1000
         group by genre;


QUESTION 6) -- Retrieve movie of each genre starting  with the word 'The' and having  and average rating >8
answer 6) 
           SELECT g.genre,m.title 
          from movie m
          join genre g 
           on m.id=g.movie_id
           join ratings r 
        on m.id=r.movie_id
         where m.title  like 'The%' and r.avg_rating>8;


                                      SEGMENT 5: -- CREW ANALYSIS

--    
--1).Identify the columns in names table that have null values.
--2) Determin the top 3 directors in the top three genre with movies having an average rating> 8
--3) Find the top two actors whose movies have a median rating>=8
--4) Identify the top 3 production houses based on the  number of  votes received by their movies
--5) Rank actors based on their average ratings  in Indian  movies released  in India
--6) Identify the Top  five actress IN Hindi movies released in India based on their average rating


QUESTION 1)-- Identify the columns in names table that have null values.

  select 
   sum(case when id='' then 1 else 0 end) as Null_for_id,
    sum(case when name='' then 1 else 0 end) as Null_for_Name,
   sum(case when date_of_birth='' then 1 else 0 end) as Null_for_DOB,
   sum(case when known_for_movies='' then 1 else 0 end) as known_for_movies,
   sum(case when height='' then 1 else 0 end) as Null_for_height
from names
   
                          or
          
          select 
         count(case when id='' then id end) as Null_for_id,
         count(case when name='' then id end) as Null_for_Name,
         count(case when date_of_birth='' then id end) as Null_for_DOB,
         count(case when known_for_movies='' then id end) as known_for_movies,
         count(case when height='' then 1 else 0 end) as Null_for_height
        from names;
  
QUESTION 2)--Determine the top 3 directors in the top three genre with movies having an average rating> 8
answer 2)

             
             
          SELECT g.genre ,n.name,d.name_id,count(*)as movie_count
         from director_mapping d
              LEFT JOIN names n ON d.name_id = n.id
             LEFT JOIN movie m ON d.movie_id = m.id
             LEFT JOIN genre g ON m.id = g.movie_id
            LEFT JOIN ratings r ON m.id = r.movie_id
             where avg_rating > 8
             group by g.genre,n.name,d.name_id 
             order by  count(*) desc 
              limit 3;


                         or

WITH top_genre AS (
    SELECT  d.name_id, g.genre, n.name,COUNT(*) AS movie_count,
        Rank() OVER (ORDER BY COUNT(*) DESC) AS director_rank
    FROM director_mapping d
    LEFT JOIN names n ON d.name_id = n.id
    LEFT JOIN movie m ON d.movie_id = m.id
    LEFT JOIN genre g ON m.id = g.movie_id
    LEFT JOIN rating r ON m.id = r.movie_id
    WHERE  r.avg_rating > 8
    GROUP BY d.name_id, g.genre, n.name 
    order by movie_count desc
    )
SELECT genre, name,SUM(movie_count) AS total_movie_count, director_rank FROM top_genre
WHERE  director_rank <= 3
GROUP BY genre, name, director_rank;



QUESTION 3) Find the top two actors whose movies have a median rating>=8
answer 3)


        
                   SELECT ro.name_id,COUNT(r.movie_id) AS movie_count
                    FROM role_mapping ro
                    LEFT JOIN ratings r 
                    ON  ro.movie_id=r.movie_id 
                    WHERE ro.category = 'actor' AND r.median_rating > 8
                      GROUP BY ro.name_id ,r.median_rating
                      order by r.median_rating desc
                       limit 2;

                                    or
                                    

               select r.name_id,count(m.id) as movies ,s.median_rating
                from movie m
                left join role_mapping r 
                   on m.id=r.movie_id
                left join ratings s 
                     on m.id=s.movie_id
                 where r.category ='actor' and s.median_rating>8
                  group by r.name_id,s.median_rating 
                  order by s.median_rating desc
                  limit 2;	



QUESTION 4) --Identify the top 3 production houses based on the  number of  votes received by their movies
answer 4)

            SELECT DISTINCT PRODUCTION_COMPANY as Production_House ,SUM(TOTAL_VOTES)AS VOTES 
            FROM MOVIE M
                LEFT JOIN RATINGS R 
                ON R.MOVIE_ID=M.ID
                GROUP BY PRODUCTION_COMPANY
                 ORDER BY VOTES DESC 
                 LIMIT 3;



QUESTION 5)-- Rank actors based on their average rating  in Indian  movies released  in India

ANSWER 5)

    SELECT DISTINCT R.NAME_ID, AVG(S.AVG_RATING) AS AVERAGE
    FROM MOVIE M
    LEFT JOIN ROLE_MAPPING R ON M.ID = R.MOVIE_ID
    LEFT JOIN RATINGS S ON M.ID = S.MOVIE_ID
    WHERE M.COUNTRY = 'INDIA' and r .category='actor'
    GROUP BY R.NAME_ID
    ORDER  BY AVERAGE DESC;

                               OR
                               
 WITH RANK_ACTOR AS (
    SELECT DISTINCT R.NAME_ID, AVG(S.AVG_RATING) AS AVERAGE
    RANK() OVER (ORDER BY AVG(S.AVG_RATING) DESC) AS AVERAGE_RANK
    FROM MOVIE M
    LEFT JOIN ROLE_MAPPING R ON M.ID = R.MOVIE_ID
    LEFT JOIN RATINGS S ON M.ID = S.MOVIE_ID
    GROUP BY R.NAME_ID
)
SELECT * FROM RANK_ACTOR
WHERE M.COUNTRY = 'INDIA' and r .category='actor';




QUESTION 6)


ANSWER 6)--Identify the Top  five actress IN Hindi movies released in India based on their average rating

                                 
               SELECT DISTINCT R.NAME_ID, AVG(S.AVG_RATING) AS AVERAGE
                   FROM MOVIE M
                 LEFT JOIN ROLE_MAPPING R ON M.ID = R.MOVIE_ID
                 LEFT JOIN RATINGS S ON M.ID = S.MOVIE_ID 
                 WHERE M.COUNTRY = 'INDIA' AND R.CATEGORY='actress' AND M.LANGUAGES='Hindi'
                  GROUP BY R.NAME_ID
                 ORDER  BY AVERAGE DESC 
                 limit 5;


                                   OR

WITH TOP_ACTRESS AS 
    (
    SELECT DISTINCT R.NAME_ID, AVG(S.AVG_RATING) AS AVERAGE
    RANK() OVER (ORDER  BY AVG(S.AVG_RATING) DESC)AS AVERAGE_RANK
    FROM MOVIE M
    LEFT JOIN ROLE_MAPPING R ON M.ID = R.MOVIE_ID
    LEFT JOIN RATINGS S ON M.ID = S.MOVIE_ID
    GROUP BY R.NAME_ID
  )
SELECT *
FROM TOP_ACTRESS
WHERE M.COUNTRY = 'INDIA' AND R.CATEGORY='actress' AND M.LANGUAGES='Hindi'
LIMIT 5;

                          Segment 6: --Broader Understanding of Data
                            
--  classify thriller movies based on average ratings into different catagories.
--  Analysis the genre-wise running total and moving average of the average movie duration
--  identify the five highest grossing movies of each year that belong to top three GENRE 
-- Determin the Top two Production house that have produced highest number of hit among multilingual movies
-- Identify the top three actoress based on the number of Super hit movies (average rating > 8) in the drama genre
-- Retrieve details for the top nine directors based on the number of movies, including average inter-movie duration, 
 --ratings, and more. 

QUESTION 1) --  classify thriller movies based on average rating into different catagories.
ANSWER 1)


            SELECT m.id,r.AVG_RATING ,
          CASE
                WHEN r.avg_rating >= 8.0 THEN 'Hit'
                WHEN r.avg_rating >= 6.0 THEN 'Average'
                ELSE 'Flop' end as Movie_catagory
           FROM MOVIE M
         LEFT JOIN GENRE G ON M.ID=G.MOVIE_ID
           LEFT JOIN RATINGS R ON M.ID=R.MOVIE_ID
           WHERE G.GENRE='Thriller' ;

QUESTION 2) -- Analysis the genre-wise running total and moving average of the average movie duration
ANSWER 2)

       SELECT id ,genre,duration,
         sum(duration) over (partition by genre  order by id) duration_sum, 
          avg(duration) over (partition by genre  order by id) moving_Average
          from movie
            left join genre on movie.id=genre.movie_id ;



QUESTION 3) --identify the five highest grossing movies of each year that belong to top three GENRE

ANSWER3)









QUESTION 4)  --Determine the Top two Production house that have produced highest number of hits among multilingual movies.
ANSWER 4)

            SELECT production_company,languages, count(id) as Total_movies
             FROM movie 
             WHERE  languages like '%,%' 
             GROUP BY production_company,languages
             order by total_movies desc 
              limit 2 ;

QUESTION 5)--Identify the top three actoress based on the number of Super hit movies (average rating>8) IN THE DRAMA  GENRE
ANSWER 5)  SELF

            SELECT id,g.genre,count( m.id) as movie_produced
             FROM movie m
             left join ratings r on m.id=r.movie_id
            left join role_mapping ro on m.id=ro.movie_id
              left join genre g on m.id=g.movie_id
               where ro.category='actress' and r.avg_rating>8 and g.genre='Drama'
                group by id,g.genre order by movie_produced desc  
                limit 3;

QUESTION 6) -- Retrieve the details of top  nine directors bases on the number of movies,including average inter movie duration,rating,more
ANSWER 6)


            select d.name_id as director_id,n.name as director_name,count(m.id)as num_Movies_produced,
              avg(m.duration)as average_duration,avg(r.avg_rating) from movie m
               left join genre g on m.id=g.movie_id
              left join director_mapping d on m.id=d.movie_id
                left join ratings r on m.id=r.movie_id
                 LEFT join names n on d.name_id=n.id
                   where d.name_id is not null
                    group by d.name_id,n.name 
                    order by num_Movies_produced desc;

    









