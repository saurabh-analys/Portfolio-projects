Q1.who is the senior most employee based on the job title?


select*from employee
order by levels desc
limit 1

Q2. which country have the most invoices?

select count (*) as countary ,billing_country 
from invoice 
group by billing_country 
order by countary desc;

Q3.what are top 3 values total invoice ?

select total from invoice
order by total desc
limit 3

Q4.which countary has the best customer ?



select sum(total) as invoice_total,billing_city
from invoice
group by billing_city
order by invoice_total desc

--Q5. who is the best customer? the cutomer who has spend the most money will be declare best customer
-- write a query that returns the person who has spent the most money.

 select  customer.customer_id ,customer.first_name ,customer.last_name, sum( invoice.total ) as total
 from customer
 join invoice on customer.customer_id = invoice.customer_id
 group by customer.customer_id 
 order by total desc
 limit 1
 
 --Q6. write a queary to the email ,first name,last name ,Genre of all Rock music listners
 --Return your list order alphabetically email starting with A.
 

 select distinct first_name,last_name ,email
 from customer 
 join invoice on customer.customer_id = invoice.customer_id  
 join invoice_line on invoice.invoice_id = invoice_line.invoice_id
 where track_id in(select track_id from track
				   join genre on track.genre_id = genre.genre_id
				  where track.name like'rock')
				  order by email 
				  
--Q7. lets invite the artist who have written the most rock music in our dataset write a queary
-- that returns the artist name and the total track count of the top 10 rock bands.

select  artist.artist_id, artist.name, count(artist.artist_id) as number_of_songs 
from track
join album on album.album_id=track.album_id 
join artist on artist.artist_id = album.artist_id
join genre on genre.genre_id=track.genre_id
where genre.name like 'rock'
group by artist.artist_id
order by number_of_songs desc

--Q8.Return all the track names that have a song length longer than the average song lenth
-- Return the name and milisecond for each track. order by the song length with the longest
--song listed first.

select name , milliseconds
from track 
where milliseconds>(select avg(milliseconds) as avg_track_lenth
				   from track )
				   order by  milliseconds desc
				   
 --Q9.Find how much amount spend by each customer on artists? write a query to return
 --customer name ,artist name and total spend
 
 with best_selling_artist as( 
  select artist.artist_id as artist_id,artist.name as artist_name,sum (invoice_line.unit_price*invoice_line.quantity)
	as total_sales
	 from invoice_line
	 join track on track.track_id = invoice_line.track_id
	 join album on album.album_id = track.album_id
	 join artist on artist.artist_id = album.artist_id
	 group by 1 
	 order by 3 desc
	 limit 1
	 )
	 select c.customer_id,c.first_name ,c.last_name ,bsa.artist_name,sum (il.unit_price*il.quantity)
	 as amount_spend
	 from invoice i
	 join customer c on c.customer_id = i.customer_id
	 join invoice_line il on il.invoice_id = i.invoice_id
	 join track t on t.track_id = il.track_id
	 join album alb on alb.album_id = t.album_id
	 join best_selling_artist bsa on bsa.artist_id = alb.artist_id
	 group by 1,2,3,4
	 order by 5 desc
	 
	 --Q10.we want to find out the most popular music genre for each country.
	 --we determine the most popular genre as the genre with the highest amount of purchases.
	 --write  a query that returns each country along with the top genre. for countries where maximum 
	 --number of purchase is shared return all genres.
	 
	 with popular_genre as
	 (select count(invoice_line.quantity) as purchase , customer.country,genre.name,genre.genre_id,
	 row_number () over (partition by customer.country order by count (invoice_line.quantity)desc) as 
	 rowno 
	 from invoice_line
	 join invoice on invoice.invoice_id = invoice_line.invoice_id
	 join customer on customer.customer_id = invoice.customer_id
	 join track on track.track_id = invoice_line.track_id
	 join genre on genre.genre_id = track.genre_id
	 group by 2,3,4
	 order by 2 asc,1 desc)
	 
	 select * from popular_genre where rowno <= 1
	 
	 --Q10. write a query that determines the customer that has spent the most on music for each country.
	 --write a query that returns the country along with the top customers and how much they spent.for 
	 --countries where the top amount spent is shared, provide all customers who spent this amount 
	 
	 
	 with customer_with_country as (
	 select customer.customer_id,first_name,last_name,billing_country,sum(total) as total_spending,
	 row_number () over (partition by billing_country order by sum(total)desc ) as rowno
		 from invoice
		 join customer on customer.customer_id = invoice.customer_id
		 group by 1,2,3,4
		 order by 4 asc, 5 desc )
		 select * from customer_with_country where rowno <= 1
		 
		 
		 