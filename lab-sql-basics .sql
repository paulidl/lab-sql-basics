USE bank;

-- Query 1: Get the id values of the first 5 clients from district_id with a value equals to 1.
SELECT * 
FROM bank.client 
ORDER BY district_id ASC 
LIMIT 5;	-- client_id: 22, 2, 3, 28, 23.

-- Query 2: In the client table, get an id value of the last client where the district_id equals to 72.
SELECT max(client_id) 
FROM bank.client 
WHERE district_id = "72";	-- id_value: 13576.

-- Query 3: Get the 3 lowest amounts in the loan table.
SELECT * 
FROM bank.loan 
ORDER BY amount ASC
LIMIT 3;	-- Amount: 4980, 5148, 7656.

-- Query 4: What are the possible values for status, ordered alphabetically in ascending order in the loan table?
SELECT DISTINCT status 
FROM bank.loan 
ORDER BY status ASC;	-- A, B. C, D.

-- Query 5: What is the loan_id of the highest payment received in the loan table?
SELECT loan_id, payments 
FROM bank.loan 
ORDER BY payments DESC 
LIMIT 1;	-- 6415.

SELECT * 
FROM bank.loan 
WHERE loan_id = "6312";	-- This is the loan_id of the lowest payment received in the loan table.

-- Query 6: What is the loan amount of the lowest 5 account_ids in the loan table? Show the account_id and the corresponding amount.
SELECT account_id, amount 
FROM bank.loan 
ORDER BY account_id ASC 
LIMIT 5;	-- account_id: 2, 19, 25, 37, 38.

-- Query 7: What are the account_ids with the lowest loan amount that have a loan duration of 60 in the loan table?
SELECT account_id 
FROM bank.loan 
WHERE duration = "60" 
ORDER BY amount ASC;	-- First 5: 10954, 938, 10711, 1766, 10799.

-- Query 8: What are the unique values of k_symbol in the order table?
-- Note: There shouldn't be a table name order, since order is reserved from the ORDER BY clause. You have to use backticks to escape the order table name.
SELECT DISTINCT k_symbol 
FROM bank.order;	-- 'SIPO', 'UVER', ' ', 'POJISTNE', 'LEASING'.

-- Query 9: In the order table, what are the order_ids of the client with the account_id 34?
SELECT account_id, order_id 
FROM bank.order 
WHERE account_id = "34";	-- 29445, 29446, 29447.

-- Query 10: In the order table, which account_ids were responsible for orders between order_id 29540 and order_id 29560 (inclusive)?
SELECT DISTINCT (account_id)
FROM bank.order 
WHERE order_id BETWEEN 29540 AND 29560;	-- 88, 90, 96, 97.	

-- Query 11: In the order table, what are the individual amounts that were sent to (account_to) id 30067122?
SELECT amount 
FROM bank.order 
WHERE account_to = "30067122";	-- 5123.

-- Query 12: In the trans table, show the trans_id, date, type and amount of the 10 first transactions from account_id 793 
-- in chronological order, from newest to oldest.
SELECT trans_id, date, type, amount 
FROM bank.trans 
WHERE account_id = "793" 
ORDER BY date DESC 
LIMIT 10;

-- Query 13: In the client table, of all districts with a district_id lower than 10, how many clients are from each district_id? 
-- Show the results sorted by the district_id in ascending order.
SELECT district_id, count(client_id) AS number_of_clients 
FROM bank.client 
WHERE district_id < 10 
GROUP BY district_id  
ORDER BY district_id ASC;	-- 1:663, 2:46, 3:63, 4:50, 5:71, 6:53, 7:45, 8:69, 9:60.

-- Query 14: In the card table, how many cards exist for each type? Rank the result starting with the most frequent type.
SELECT type, count(card_id) AS number_of_cards 
FROM bank.card 
GROUP BY type 
ORDER BY number_of_cards DESC; -- classic:659, junior:145, gold:88.

-- Query 15: Using the loan table, print the top 10 account_ids based on the sum of all of their loan amounts.
SELECT account_id, sum(amount) AS total_amount 
FROM bank.loan 
GROUP BY account_id 
ORDER BY total_amount DESC 
LIMIT 10;	-- account_id: 7542, 8926, 2335, 817, 2936, 7049, 10451, 6950, 7966, 339.

-- Query 16: In the loan table, retrieve the number of loans issued for each day, before (excl) 930907, ordered by date in descending order.
SELECT date, count(loan_id) AS number_of_loans 
FROM bank.loan 
WHERE date < 930907 
GROUP BY date ORDER 
BY date DESC;

-- Query 17: In the loan table, for each day in December 1997, count the number of loans issued for each unique loan duration, 
-- ordered by date and duration, both in ascending order. You can ignore days without any loans in your output.
SELECT date, duration, count(loan_id) AS number_of_loans 
FROM bank.loan 
WHERE date BETWEEN "971201" AND "971231" 
GROUP BY duration, date 
ORDER BY date ASC, duration ASC;

-- Query 18: In the trans table, for account_id 396, sum the amount of transactions for each type (VYDAJ = Outgoing, PRIJEM = Incoming). 
-- Your output should have the account_id, the type and the sum of amount, named as total_amount. Sort alphabetically by type.
SELECT account_id, type, sum(amount) AS total_amount 
FROM bank.trans 
WHERE account_id = "396" 
GROUP BY type 
ORDER BY type ASC;	-- For incoming_id = 396 : PRIJEM:1.028.138,6999740601, VYDAJ: 1.485.814,400024414.

-- Query 19: From the previous output, translate the values for type to English, rename the column to transaction_type, round total_amount down to an integer.
SELECT trans.account_id, FLOOR(SUM(trans.amount)) AS total_amount,
CASE WHEN type = "VYDAJ" THEN "Outgoing" WHEN type = "PRIJEM" THEN "Incoming" END AS "transaction_type"
FROM bank.trans
WHERE trans.account_id = "396"
group by trans.type
ORDER BY type ASC; 	-- For incoming_id = 396 : Incoming:1.028.138, Outgoing: 1.485.814.

-- Query 20: From the previous result, modify your query so that it returns only one row, with a column for incoming amount, outgoing amount and the difference.
SELECT
ROUND(SUM(CASE WHEN type = "PRIJEM" THEN amount ELSE 0 END)) AS total_incoming,
ROUND(SUM(CASE WHEN type = "VYDAJ" THEN amount ELSE 0 END)) AS total_outgoing,
ROUND(SUM(CASE WHEN type = "PRIJEM" THEN amount ELSE 0 END)) - ROUND(SUM(CASE WHEN type = "VYDAJ" THEN amount ELSE 0 END)) AS balance
FROM bank.trans
WHERE account_id = "396";	-- Total incoming: 1.028.139, Total outgoing: 1.485.814, Balance: -457.675

-- Query 21: Continuing with the previous example, rank the top 10 account_ids based on their difference.
SELECT account_id,
ROUND(SUM(CASE WHEN type = "PRIJEM" THEN amount ELSE 0 END)) - ROUND(SUM(CASE WHEN type = "VYDAJ" THEN amount ELSE 0 END)) AS balance
FROM bank.trans
GROUP BY account_id
ORDER BY balance DESC
LIMIT 10;	-- Account_ids: 9707, 3424, 3260, 2486, 1801, 4470, 3674, 9656, 2227, 6473.
