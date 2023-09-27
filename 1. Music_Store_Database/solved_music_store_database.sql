-- Q1: Who is most senior employee based on job title?

select * from employee
order by levels desc
limit 1

-- Q2: which country has the most invoices ?

select count(*) as c, billing_country from invoice
group by billing_country
order by c desc

-- Q3: What are top 3 values of totat invoice

SELECT total from invoice
order by total desc
limit 3

-- Q4: Which city has the best customers? We would like to throw a
--	   promotional Music Festival in the city we made the most money. Write a
--	   query that returns one city that has the highest sum of invoice totals.
--	   Return both the city name & sum of all invoice totals

select SUM(total) as invoice_total, billing_city 
from invoice
group by billing_city
order by invoice_total desc
limit 1

-- Q5: Who is the best customer? The customer who has spent the most
--	   money will be declared the best customer. Write a query that returns
--	   the person who has spent the most money.

select c.customer_id as id, CONCAT(c.first_name,c.last_name), sum(i.total) as total_invoice 
from customer as c
join invoice as i
on c.customer_id = i.customer_id
group by id
order by total_invoice desc
limit 1

						----------Moderate------------

-- Q1: Write query to return the email, first name, last name, & Genre
-- 	   of all Rock Music listeners. Return your list ordered alphabetically
--     by email starting with A

select distinct c.email,c.first_name,c.last_name, 'Rock' as genre from customer as c
join invoice as i on c.customer_id = i.customer_id
join invoice_line as il on i.invoice_id=il.invoice_id
where il.track_id in (
		select track_id from track
		join genre on track.genre_id = genre.genre_id
		where genre.name like 'Rock'
		)
order by c.email;

--	Q2: Let's invite the artists who have written the most rock music in
--		our dataset. Write a query that returns the Artist name and total
--		track count of the top 10 rock bands

select ar.artist_id, ar.name, count(tr.track_id) as total_songs 
from artist as ar
join album as al on ar.artist_id = al.artist_id
join track as tr on al.album_id = tr.album_id
join genre as gn on tr.genre_id = gn.genre_id
where gn.name like 'Rock'
group by ar.artist_id
order by total_songs desc
limit 10;

--	Q3: Return all the track names that have a song length longer than
--		the average song length. Return the Name and Milliseconds for
--		each track. Order by the song length with the longest songs listed
--		first.

select name, milliseconds
from track
where milliseconds >
	(select avg(milliseconds)
	 from track)
order by milliseconds desc


						----------Advance------------

--  Q1: Find how much amount spent by each customer on artists? Write a
--		query to return customer name, artist name and total spent

WITH best_selling_artist AS (
	SELECT artist.artist_id as artist_id, artist.name as artist_name, 
	SUM(invoice_line.unit_price*invoice_line.quantity) as total_sales
	from invoice_line
	join track on track.track_id=invoice_line.track_id
	join album on track.album_id=album.album_id
	join artist on artist.artist_id=album.artist_id
	GROUP by 1
	ORDER BY 3 DESC	
)
SELECT c.customer_id,c.first_name,c.last_name, bsa.artist_name,
SUM(il.unit_price*il.quantity)
from invoice as i
join customer as c on c.customer_id=i.customer_id
join invoice_line as il on il.invoice_id=i.invoice_id
join track as t on t.track_id=il.track_id
join album as alb on alb.album_id=t.album_id
join best_selling_artist as bsa on bsa.artist_id=alb.artist_id
GROUP BY 1,2,3,4
ORDER BY 5 DESC


--	Q2: We want to find out the most popular music Genre for each country.
--		We determine the most popular genre as the genre with the highest
--		amount of purchases. Write a query that returns each country along with
--		the top Genre. For countries where the maximum number of purchases
--		is shared return all Genres.













