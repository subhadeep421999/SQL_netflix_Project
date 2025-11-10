-- Netflix Project
create database project3;
use project3;
select * from netflix_titles;
select count(*) as total_content from netflix_titles;


-- Q1. Count the number of Movies vs TV Shows
select type, count(*) as total_content from netflix_titles group by type;


-- Q2. Find the most common rating for movies and TV shows
select type , rating from
(select type, rating, count(*), rank() over(partition by type order by count(*) desc) as ranking 
from netflix_titles group by type, rating) as NT
where ranking = 1;


-- Q3. List all movies released in a specific year(2020)
select title from 
(select * from netflix_titles where release_year = 2020 and type = 'Movie') as NT1;



-- Q4. Find the top 5 countries with the most content on Netflix
select trim(c.country) as new_country, count(nt.show_id) as total_content 
from netflix_titles nt 
join json_table(
concat('["',replace(coalesce(nt.country,''),',','","'),'"]'),
'$[*]' columns ( country varchar(100) path '$')) as c
where c.country <> ''
group by new_country
order by total_content desc limit 5;



-- Q5 Identify the longest movie.
select * from netflix_titles where type = 'movie' and duration = (select max(duration) from netflix_titles);


-- Q6. Find content added in the last 5 years
select * from netflix_titles where 
str_to_date(date_added, '%M %d,%Y' ) >= current_date - interval 5 year;


-- Q7. Find all the movies/TV shows By director 'Rajiv Chilaka'
select type from netflix_titles where director like '%Rajiv Chilaka%';


-- Q8. List all TV shows with more than 5 seasons
select * from netflix_titles
where type = 'TV show' and 
cast(substring_index(duration, ' ', 1) as unsigned) >5;



-- Q9. Count the number of content items in each genre
select trim(c.genre) as Genre, count(show_id) as total_content from netflix_titles join
json_table(concat('["',replace(listed_in, ',', '","'),'"]'), '$[*]' columns(genre varchar(100) path '$')) as c
group by Genre order by total_content desc;



-- Q10. Find each year and the average numbers of content release by India on netflix.
-- return top 5 year with highest avg content release 
select extract(year from str_to_date(date_added, '%M %d, %Y')) as year,
count(*) as total_content , count(*) /12 as avg_monthly_release from netflix_titles
where country = 'India'
group by year
order by total_content desc limit 5;



-- Q11.List all movies that are documentaries
select * from netflix_titles where listed_in like'%documentaries%';


-- Q12. Find all content without a diretor.
select * from netflix_titles where director is null;


-- Q13. Find how many movies actor 'Samlan Khan' appeared in the 10 years.
select * from netflix_titles where cast like '%Salman Khan%'
and release_year > extract(year from current_date) - 10;


-- Q14. Find the top 10 actors who have appeared in the highest number of movies produced in India.
select trim(jt.cast) as actor, count(*) from netflix_titles nt join
json_table(
concat('["',replace(coalesce(nt.cast,''),',','","'),'"]'),
'$[*]' columns (cast varchar(100) path '$')) as jt
where jt.cast <> '' and country like '%India%'
group by actor order by count(*) desc limit 10;



-- Q15. Categorize the content based on the presence of the keywords 'kill' and 'violence' in the description field.
-- lebel content containing these keywords as 'Bad' and all other content as 'Good'.
-- Count how items fall into each category.
select count(*) , 
case when description like '%Kill%' or description like '%violence%' then 'Bad Content'
else 'Good Content' end category 
from netflix_titles 
group by category;













