--Display CustomerName, CustomerPhone, and CustomerEmail for every customer whose name does not contains more than one word.
select CustomerName, CustomerPhone, CustomerEmail
from Customer
where CustomerName not like '% %'

--Display CustomerName, EmployeeName, and HeaderSalesTransactionDate for every transaction which occurs on Tuesday.
select c.CustomerName, e.EmployeeName, hst.HeaderSalesTransactionDate
from Customer c join HeaderSalesTransaction hst
on c.CustomerID = hst.CustomerID
join Employee e on hst.EmployeeID = e.EmployeeID
where datename(weekday, hst.HeaderSalesTransactionDate) = 'Tuesday'

--Display AlbumName, Album Price (obtained by adding ‘Rp’ in front of AlbumPrice), and Total Album Purchased (obtained from the total
--of quantity) for every Album which name is more than five characters length.
select a.AlbumName, 'Album Price' = 'Rp' + cast(a.AlbumPrice as varchar),
'Total Album Purchased' = sum(dst.Quantity)
from Album a join DetailSalesTransaction dst
on a.AlbumID = dst.AlbumID
where len(a.AlbumName) > 5
group by a.AlbumName, a.AlbumPrice

--Display Customer Name (obtained by adding 'Mr. ' in front of CustomerName), Total of Album Type (obtained from the total number of album),
--Total of Quantity (obtained from the total quantity), and HeaderSalesTransactionDate for every Customer whose gender is ‘Male’.
--Then, combine with Customer Name (obtained by adding 'Mrs. ' in front of CustomerName), Total of Album Type (obtained from the total number of album),
--Total of Quantity (obtained from total quantity), and HeaderSalesTransactionDate for every Customer whose gender is ‘Female’. Sort the data based on Total of Quantity in ascending order.

select 'Customer Name' = 'Mr. ' + c.CustomerName,
'Total of Album Type' = count(a.AlbumID),
'Total of Quantity' = sum(dst.Quantity), hst.HeaderSalesTransactionDate
from Customer c join HeaderSalesTransaction hst
on c.CustomerID = hst.CustomerID
join DetailSalesTransaction dst on hst.HeaderSalesTransactionID = dst.HeaderSalesTransactionID
join Album a on dst.AlbumID = a.AlbumID
where c.CustomerGender like 'Male'
group by c.CustomerName, hst.HeaderSalesTransactionDate
union
select 'Customer Name' = 'Mrs. ' + c.CustomerName,
'Total of Album Type' = count(a.AlbumID),
'Total of Quantity' = sum(dst.Quantity), hst.HeaderSalesTransactionDate
from Customer c join HeaderSalesTransaction hst
on c.CustomerID = hst.CustomerID
join DetailSalesTransaction dst on hst.HeaderSalesTransactionID = dst.HeaderSalesTransactionID
join Album a on dst.AlbumID = a.AlbumID
where c.CustomerGender like 'Female'
group by c.CustomerName, hst.HeaderSalesTransactionDate
order by 'Total of Quantity'

--Display all the Customer data for every customer who has transaction on an even day of TransactionDate and purchase album which name is ‘CALM’.
select c.CustomerID, c.CustomerName, c.CustomerGender, c.CustomerAddress,
c.CustomerPhone, c.CustomerEmail
from Customer c join HeaderSalesTransaction hst
on c.CustomerID = hst.CustomerID
join DetailSalesTransaction dst on hst.HeaderSalesTransactionID = dst.HeaderSalesTransactionID
join Album a on dst.AlbumID = a.AlbumID
where hst.HeaderSalesTransactionDate in(hst.HeaderSalesTransactionDate)
and day(hst.HeaderSalesTransactionDate) % 2 = 0
and a.AlbumName like 'CALM'

--Display CustomerID, Customer Name (obtained from the first word of CustomerName), CustomerPhone,
--and CustomerEmail for every customer who has purchased more than one album.
select CustomerID, 'Customer Name' = substring(CustomerName, 1, charindex(' ', CustomerName)),
CustomerPhone, CustomerEmail
from Customer,
(select [CountAlbum] = count(AlbumID)
from DetailSalesTransaction) as [CountOfAlbum]
where CountOfAlbum.CountAlbum > 1
group by CustomerID, CustomerName, CustomerPhone, CustomerEmail

--Create a view named ‘UpdatedCustomerData’ to display CustomerName, CustomerGender, CustomerPhone, and Customer Email
--(obtained by replacing ‘.co.id’ with .com on CustomerEmail) for every customer whose email contains  ‘yahoo’ domain.
create view UpdatedCustomerData as
select CustomerName, CustomerGender, CustomerPhone,
'Customer Email' = replace(CustomerEmail, '.co.id', '.com')
from Customer
where CustomerEmail like '%yahoo%'

select * from UpdatedCustomerData
drop view UpdatedCustomerData

--Create a view named ‘TransactionDataOfPopAlbum’ to display HeaderSalesTransactionID, Day of Transaction (obtained from day of HeaderSalesTransactionDate),
--HeaderSalesTransactionDate, and Total of Quantity (obtained from the total of Quantity) for every transaction which sold album that genre name is ‘Pop’.
create view TransactionDataOfPopAlbum as
select hst.HeaderSalesTransactionID,
'Day of Transaction' = datename(weekday, hst.HeaderSalesTransactionDate),
hst.HeaderSalesTransactionDate,
'Total of Quantity' = sum(dst.Quantity)
from HeaderSalesTransaction hst join DetailSalesTransaction dst
on hst.HeaderSalesTransactionID = dst.HeaderSalesTransactionID
join Album a on dst.AlbumID = a.AlbumID
join AlbumGenre ag on a.AlbumGenreID = ag.AlbumGenreID 
where ag.AlbumGenreName = 'Pop'
group by hst.HeaderSalesTransactionID, hst.HeaderSalesTransactionDate

select * from TransactionDataOfPopAlbum
drop view TransactionDataOfPopAlbum

--Add a column named ‘CustomerInstagram’ on Customer table with varchar (20) data type and add a
--constraint named ‘CheckInstagram’ to check the CustomerInstagram must starts with ‘@’.
alter table Customer add CustomerInstagram varchar(20)
alter table Customer add constraint CheckInstagram check (CustomerInstagram like '@')

--Delete from Album table data for every album which price less than 350000 and album name contains at least three words.
delete from Album
where AlbumPrice < 350000
and AlbumName like '% % %'

select * from Album