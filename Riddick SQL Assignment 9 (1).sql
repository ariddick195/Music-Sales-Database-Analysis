use Audiosphere7;
-- Problem 1

select ordernumber, orderdate, total
from customerorder
where total < (
    select avg(total)
    from customerorder
)
order by total desc;
-- Problem 2

select songid, name, genrename, unitprice
from song
where unitprice <
(
    select min(unitprice)
    from song
    where genrename = 'opera'
)
order by unitprice asc;
-- Problem 3

select ordernumber, orderdate, total
from customerorder
where total < (
    select min(total)
    from customerorder
    where orderdate between '2021-01-01' and '2021-01-31'
)
order by ordernumber;
-- Problem 4a

select employeeid, firstname, lastname, title
from employee
where employeeid in (
    select supportrepid
    from customer
    where supportrepid is not null
)
order by employeeid;
-- Problem 4b

select employeeid, firstname, lastname, title
from employee
where employeeid not in (
    select supportrepid
    from customer
    where supportrepid is not null
)
order by employeeid;
-- Problem 5a

select distinct e.employeeid, e.firstname, e.lastname, e.title
from employee e
join customer c on e.employeeid = c.supportrepid
order by e.employeeid;
-- Problem 5b

select e.employeeid, e.firstname, e.lastname, e.title
from employee e
left join customer c on e.employeeid = c.supportrepid
where c.supportrepid is null
order by e.employeeid;
-- Problem 6a

select ordernumber, orderdate, total
from customerorder
where total > all (
    select o.total
    from customerorder o
    join customer c on o.customerid = c.customerid
    where c.country = 'USA'
)
order by total desc;
-- Problem 6b

select ordernumber, orderdate, total
from customerorder
where total > (
    select max(o.total)
    from customerorder o
    join customer c on o.customerid = c.customerid
    where c.country = 'USA'
)
order by total desc;
-- Problem 7

select c.customerid, c.firstname, c.lastname,
       (
           select count(*)
           from customerorder o
           where o.customerid = c.customerid
       ) as order_count
from customer c
order by order_count asc;
-- Problem 8 (create view)

create view customer_order_count_view as
select c.customerid, c.firstname, c.lastname,
       (
           select count(*)
           from customerorder o
           where o.customerid = c.customerid
       ) as order_count
from customer c;
-- Problem 8 (use view)

select *
from customer_order_count_view
where order_count >= 5
order by customerid asc;
-- Problem 9a

select o.ordernumber, o.orderdate, o.total
from customerorder o
where exists (
    select 1
    from lineitem
    where ordernumber = o.ordernumber
)
order by o.ordernumber;
-- Problem 9b

select o.ordernumber, o.orderdate, o.total
from customerorder o
where not exists (
    select 1
    from lineitem
    where ordernumber = o.ordernumber
)
order by o.ordernumber;
-- Problem 10

select s.songid, s.name, s.albumid, s.unitprice
from song s
where s.unitprice > (
    select avg(s2.unitprice)
    from song s2
    where s2.albumid = s.albumid
)
order by s.albumid, s.unitprice asc;
-- Problem 11

select t.albumid, count(*) as song_count
from (
    select s.songid, s.albumid, s.unitprice
    from song s
    where s.unitprice > (
        select avg(s2.unitprice)
        from song s2
        where s2.albumid = s.albumid
    )
) t
group by t.albumid
order by t.albumid asc;
-- Problem 12

with high_priced_songs_cte as (
    select s.songid, s.albumid, s.unitprice
    from song s
    where s.unitprice > (
        select avg(s2.unitprice)
        from song s2
        where s2.albumid = s.albumid
    )
)

select albumid, count(*) as song_count
from high_priced_songs_cte
group by albumid
order by albumid asc;
-- Problem 13

select o.ordernumber, o.orderdate, l.songid, l.unitprice, l.quantity
from customerorder o
join lineitem l on o.ordernumber = l.ordernumber
where o.ordernumber in (
    select l2.ordernumber
    from lineitem l2
    group by l2.ordernumber
    having sum(l2.unitprice) <= 20
)
order by o.ordernumber;