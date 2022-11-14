#Lab | SQL basics (selection and aggregation)
#Query 1. Get the id values of the first 5 clients from district_id with a value equals to 1.
select * from bank.client;
select client_id from bank.client
where  district_id = '1' limit 5;
#Query 2. In the client table, get an id value of the last client where the district_id equals to 72.
select client_id from bank.client
where  district_id = '72' ORDER BY client_id DESC LIMIT 1;
#Query 3. Get the 3 lowest amounts in the loan table.
select * from bank.loan;
SELECT * FROM bank.loan ORDER BY amount asc LIMIT 3;
#Query 4. What are the possible values for status, ordered alphabetically in ascending order in the loan table?
select distinct status from bank.loan
order by status asc;
#Query 5. What is the loan_id of the highest payment received in the loan table?
SELECT loan_id
FROM   bank.loan
WHERE  payments=(SELECT MAX(payments) FROM bank.loan);

#Query 6. What is the loan amount of the lowest 5 account_ids in the loan table? Show the account_id and the corresponding amount
select account_id, amount from bank.loan order by account_id asc limit 5;

#Query 7. What are the account_ids with the lowest loan amount that have a loan duration of 60 in the loan table?
select account_id from bank.loan 
where duration = 60
order by amount asc limit 5;

#Query 8. What are the unique values of k_symbol in the order table?
select * from bank.order;
select distinct k_symbol from bank.order
order by k_symbol asc;

#Query 9. In the order table, what are the order_ids of the client with the account_id 34?
select order_id from bank.order
where account_id=34;

#Query 10. In the order table, which account_ids were responsible for orders between order_id 29540 and order_id 29560 (inclusive)?
SELECT account_id
FROM bank.order
WHERE order_id BETWEEN 29540 AND 29560;

#Query 11. In the order table, what are the individual amounts that were sent to (account_to) id 30067122?
select amount from bank.order
where account_to=30067122;

#Query 12. In the trans table, show the trans_id, date, type and amount of the 10 first transactions from account_id 793 in chronological order, from newest to oldest.
select * from bank.trans;
select trans_id, date, type, amount 
from bank.trans
where account_id= 793
order by date desc; 

#Query 13. In the client table, of all districts with a district_id lower than 10, how many clients are from each district_id? Show the results sorted by the district_id in ascending order.
select * from bank.client;
SELECT DISTINCT district_id, count(client_id)
from bank.client
where district_id < 10
group by district_id
order by count(client_id) desc;

#Query 14. In the card table, how many cards exist for each type? Rank the result starting with the most frequent type.
select * from bank.card; 
SELECT DISTINCT type, count(card_id)
from bank.card
group by type
order by count(card_id) desc;

#Query 15.Using the loan table, print the top 10 account_ids based on the sum of all of their loan amounts.
select * from bank.loan;
SELECT account_id, SUM(amount)
FROM bank.loan
GROUP BY account_id
order by sum(amount) desc;

#Query 16. In the loan table, retrieve the number of loans issued for each day, before (excl) 930907, ordered by date in descending order.
select * from bank.loan;
SELECT date, count(loan_id)
FROM bank.loan
where date < 930907
GROUP BY date
order by date desc;

#Query 17. In the loan table, for each day in December 1997, count the number of loans issued for each unique loan duration, ordered by date and duration, both in ascending order. You can ignore days without any loans in your output.
select * from bank.loan;
SELECT date, duration, count(loan_id)
FROM bank.loan
where date like '9712%'
GROUP BY date, duration
order by date, duration asc ;

#Query 18. In the trans table, for account_id 396, sum the amount of transactions for each type (VYDAJ = Outgoing, PRIJEM = Incoming). Your output should have the account_id, the type and the sum of amount, named as total_amount. Sort alphabetically by type.
select * from bank.trans;

SELECT account_id, type, sum(amount)
FROM bank.trans
where account_id=396
GROUP BY type, account_id;

#Query 19. From the previous output, translate the values for type to English, rename the column to transaction_type, round total_amount down to an integer.
select 
account_id, 
sum(amount),
case
	when type = 'VYDAJ' then 'Outgoing'
	else 'Incoming'
end as 'transaction_type'
from bank.trans
where account_id=396
GROUP BY type, account_id;

#Query 20. From the previous result, modify your query so that it returns only one row, with a column for incoming amount, outgoing amount and the difference.
select 
account_id,
FLOOR(SUM(CASE
 WHEN type = 'PRIJEM' THEN amount END)) AS 'INCOMING',
FLOOR(SUM(CASE
 WHEN type = 'VYDAJ' THEN amount END)) AS 'OUTGOING',

FLOOR(SUM(CASE
 WHEN type = 'PRIJEM' THEN amount END) ) -
 
FLOOR(SUM(CASE
 WHEN type = 'VYDAJ' THEN amount end)) as 'DIFFERENCE'
from bank.trans
where account_id=396
GROUP BY account_id;

#Query 21. Continuing with the previous example, rank the top 10 account_ids based on their difference.
select 
account_id,

FLOOR(SUM(CASE
 WHEN type = 'PRIJEM' THEN amount END) ) -
 
FLOOR(SUM(CASE
 WHEN type = 'VYDAJ' THEN amount end)) as DIFFERENCE
from bank.trans
group by account_id order by DIFFERENCE desc limit 10;
