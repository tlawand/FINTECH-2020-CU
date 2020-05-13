----QUERIES----
--isolate/group transactions for each cardholder--
SELECT
	"card_holder".name AS "cardholder_name",
	"transaction".amount,
	"transaction".date,
	"transaction".card,
	"merchant".name AS "merchant_name"
FROM
	"transaction"
INNER JOIN "credit_card" ON "transaction".card = "credit_card".card
INNER JOIN "card_holder" ON "credit_card".id_card_holder = "card_holder".id
INNER JOIN "merchant" ON "transaction".id_merchant = "merchant".id

GROUP BY
	"card_holder".name,
	"transaction".id,
	"merchant".id
ORDER BY
	"card_holder".name,
	"amount"
;

--number of transactions (and average) for each cardholder--
SELECT
	"card_holder".name AS "cardholder_name",
	COUNT("transaction".id) AS "total_transactions",
	ROUND(AVG("transaction".amount)::numeric,2) AS "average_transaction"
FROM
	"transaction"
INNER JOIN "credit_card" ON "transaction".card = "credit_card".card
INNER JOIN "card_holder" ON "credit_card".id_card_holder = "card_holder".id

GROUP BY
	"card_holder".name
ORDER BY
	"card_holder".name,
	"total_transactions"
;

--transactions between 7.00am and 9.00am--
SELECT
	"card_holder".name,
	"transaction".amount,
	"transaction".date,
	"transaction".card,
	"merchant".name AS "merchant_name"

FROM
	"transaction"
INNER JOIN "credit_card" ON "transaction".card = "credit_card".card
INNER JOIN "card_holder" ON "credit_card".id_card_holder = "card_holder".id
INNER JOIN "merchant" ON "transaction".id_merchant = "merchant".id

WHERE
	"transaction".date::time BETWEEN '07:00:00' AND '09:00:00'
GROUP BY
	"card_holder".name,
	"transaction".id,
	"merchant".id
ORDER BY
	"card_holder".name
;

--100 highest transactions during the above time period--
SELECT
	"card_holder".name,
	"transaction".amount,
	"transaction".date,
	"transaction".card,
	"merchant".name AS "merchant_name"

FROM
	"transaction"
INNER JOIN "credit_card" ON "transaction".card = "credit_card".card
INNER JOIN "card_holder" ON "credit_card".id_card_holder = "card_holder".id
INNER JOIN "merchant" ON "transaction".id_merchant = "merchant".id

WHERE
	"transaction".date::time BETWEEN '07:00:00' AND '09:00:00'
GROUP BY
	"card_holder".name,
	"transaction".id,
	"merchant".id
ORDER BY
	"transaction".amount DESC
LIMIT
	100
;

--fraudulent or anomalous transactions--
"""
yes, there seems to be anomalous transactions, specifically the first 8 transactions seem to be too large and too early for usual business payments or regular purchases.

it looks like someone was executing fraudulent transactions before the cardholders wake up and notice the purchase on their card.
"""

--count transactions less than $2.00 per cardholder--
SELECT
	"card_holder".name,
	COUNT("transaction".amount) AS "transactions_below_2"

FROM
	"transaction"
INNER JOIN "credit_card" ON "transaction".card = "credit_card".card
INNER JOIN "card_holder" ON "credit_card".id_card_holder = "card_holder".id

WHERE
	"transaction".date::time BETWEEN '07:00:00' AND '09:00:00'
AND
	"transaction".amount < 2
GROUP BY
	"card_holder".name
ORDER BY
	"transactions_below_2" DESC
;

--top 5 merchants with small transactions--
SELECT
	"merchant".name AS "merchant_name",
	COUNT("transaction".amount) AS "transactions_below_2"

FROM
	"transaction"

INNER JOIN "merchant" ON "transaction".id_merchant = "merchant".id

WHERE
	"transaction".date::time BETWEEN '07:00:00' AND '09:00:00'
AND
	"transaction".amount < 2
GROUP BY
	"merchant".name
ORDER BY
	"transactions_below_2" DESC
LIMIT
	5
;
----QUERIES END----

--VIEWS--

--isolate/group transactions for each cardholder--
CREATE VIEW "transactions_per_cardholder" AS
SELECT
	"card_holder".name AS "cardholder_name",
	"transaction".amount,
	"transaction".date,
	"transaction".card,
	"merchant".name AS "merchant_name"
FROM
	"transaction"
INNER JOIN "credit_card" ON "transaction".card = "credit_card".card
INNER JOIN "card_holder" ON "credit_card".id_card_holder = "card_holder".id
INNER JOIN "merchant" ON "transaction".id_merchant = "merchant".id

GROUP BY
	"card_holder".name,
	"transaction".id,
	"merchant".id
ORDER BY
	"card_holder".name,
	"amount"
;

--number of transactions (and average) for each cardholder--
CREATE VIEW "total_and_average_transactions_per_cardholder" AS
SELECT
	"card_holder".name AS "cardholder_name",
	COUNT("transaction".id) AS "total_transactions",
	ROUND(AVG("transaction".amount)::numeric,2) AS "average_transaction"
FROM
	"transaction"
INNER JOIN "credit_card" ON "transaction".card = "credit_card".card
INNER JOIN "card_holder" ON "credit_card".id_card_holder = "card_holder".id

GROUP BY
	"card_holder".name
ORDER BY
	"card_holder".name,
	"total_transactions"
;
--transactions between 7.00am and 9.00am--
CREATE VIEW "transactions_between_7_and_9" AS
SELECT
	"card_holder".name,
	"transaction".amount,
	"transaction".date,
	"transaction".card,
	"merchant".name AS "merchant_name"

FROM
	"transaction"
INNER JOIN "credit_card" ON "transaction".card = "credit_card".card
INNER JOIN "card_holder" ON "credit_card".id_card_holder = "card_holder".id
INNER JOIN "merchant" ON "transaction".id_merchant = "merchant".id

WHERE
	"transaction".date::time BETWEEN '07:00:00' AND '09:00:00'
GROUP BY
	"card_holder".name,
	"transaction".id,
	"merchant".id
ORDER BY
	"card_holder".name
;

--100 highest transactions during the above time period--
CREATE VIEW "100_highest_transactions_between_7_and_9" AS
SELECT
	"card_holder".name,
	"transaction".amount,
	"transaction".date,
	"transaction".card,
	"merchant".name AS "merchant_name"

FROM
	"transaction"
INNER JOIN "credit_card" ON "transaction".card = "credit_card".card
INNER JOIN "card_holder" ON "credit_card".id_card_holder = "card_holder".id
INNER JOIN "merchant" ON "transaction".id_merchant = "merchant".id

WHERE
	"transaction".date::time BETWEEN '07:00:00' AND '09:00:00'
GROUP BY
	"card_holder".name,
	"transaction".id,
	"merchant".id
ORDER BY
	"transaction".amount DESC
LIMIT
	100
;

--count transactions less than $2.00 per cardholder--
CREATE VIEW "transactions_less_than_2" AS
SELECT
	"card_holder".name,
	COUNT("transaction".amount) AS "transactions_below_2"

FROM
	"transaction"
INNER JOIN "credit_card" ON "transaction".card = "credit_card".card
INNER JOIN "card_holder" ON "credit_card".id_card_holder = "card_holder".id

WHERE
	"transaction".date::time BETWEEN '07:00:00' AND '09:00:00'
AND
	"transaction".amount < 2
GROUP BY
	"card_holder".name
ORDER BY
	"transactions_below_2" DESC
;

--top 5 merchants with small transactions--
CREATE VIEW "top5_merchants_with_small_transactions" AS
SELECT
	"merchant".name AS "merchant_name",
	COUNT("transaction".amount) AS "transactions_below_2"

FROM
	"transaction"

INNER JOIN "merchant" ON "transaction".id_merchant = "merchant".id

WHERE
	"transaction".date::time BETWEEN '07:00:00' AND '09:00:00'
AND
	"transaction".amount < 2
GROUP BY
	"merchant".name
ORDER BY
	"transactions_below_2" DESC
LIMIT
	5
;

----VIEWS END----
