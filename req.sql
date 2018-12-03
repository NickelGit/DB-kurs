\! echo ===================================================================
\! echo 7.1 вывести набор строк, удовлетворяющих определенному условию
\! echo все строки из таблицы models где имя модели начинается с HP
\! echo запрос - SELECT * FROM models WHERE model_name LIKE 'HP%';
\! echo ===================================================================

SELECT * FROM models WHERE model_name LIKE 'HP%';



\! echo ===================================================================
\! echo 7.2 вывести набор строк, отсортированных по определенному полю по возрастанию
\! echo все строки из таблицы customers отсортированные по полю customer
\! echo запрос - SELECT * FROM customers ORDER BY customer;
\! echo ===================================================================

SELECT * FROM customers ORDER BY customer;



\! echo ===================================================================
\! echo 7.2 вывести набор строк, отсортированных по определенному полю по убыванию
\! echo все строки из таблицы customers отсортированные по полю id
\! echo запрос - SELECT * FROM customers ORDER BY id DESC;
\! echo ===================================================================

SELECT * FROM customers ORDER BY id DESC;



\! echo ===================================================================
\! echo 7.3 продемонстрировать результат группировки
\! echo группирует продажи по покупателям за февраль
\! echo запрос - SELECT customer, COUNT(*) AS count_of_sales FROM sales_by_customer  WHERE customer IN
\! echo		(SELECT DISTINCT customer FROM sales_by_customer WHERE date1 BETWEEN '2018-02-01' AND '2018-02-28') GROUP BY customer;
\! echo ===================================================================

SELECT customer, COUNT(*) AS count_of_sales FROM sales_by_customer  WHERE customer IN 
(SELECT DISTINCT customer FROM sales_by_customer WHERE date1 BETWEEN '2018-02-01' AND '2018-02-28') GROUP BY customer;



\! echo ===================================================================
\! echo 7.4 сформировать набор данных из нескольких таблиц с помощью оператора соединения (левосторонее объединение)
\! echo объединяет таблицы price_of_models и model_name для формирования прайслиста с именами вместо индексов
\! echo запрос - SELECT price_of_models.id , model_name AS Name, from_supplier, cost , prime_cost
\! echo 	FROM price_of_models LEFT OUTER JOIN models ON price_of_models.name = models.id;
\! echo ===================================================================

SELECT price_of_models.id , model_name AS Name, from_supplier, cost , prime_cost  
FROM price_of_models LEFT OUTER JOIN models ON price_of_models.name = models.id;



\! echo ===================================================================
\! echo 7.4 сформировать набор данных из нескольких таблиц с помощью оператора соединения (правосторонее соединение)
\! echo объединяет таблицы price_of_models и model_name для формирования прайслиста с именами вместо индексов
\! echo Baikal не включен в таблицу price_of_models для демонстрации разницы между правосторонни и левосторонним объединением
\! echo все строки из таблицы models где имя модели начинается с HP
\! echo запрос - SELECT price_of_models.id , model_name AS Name, from_supplier, cost , prime_cost
\! echo 	FROM price_of_models RIGHT OUTER JOIN models ON price_of_models.name = models.id;
\! echo ===================================================================

SELECT price_of_models.id , model_name AS Name, from_supplier, cost , prime_cost  
FROM price_of_models RIGHT OUTER JOIN models ON price_of_models.name = models.id;



\! echo ===================================================================
\! echo 8 сформировать набор данных из нескольких таблиц с помощью вложенных запросов
\! echo формирует единую таблицу с данными из всей БД
\! echo запрос: 
\! echo WITH named_price AS (
\! echo		SELECT price_of_models.id , models.model_name AS name, category, 
\! echo		from_supplier, cost, prime_cost 
\! echo		FROM price_of_models
\! echo		LEFT OUTER JOIN models ON price_of_models.name = models.id),
\! echo	 final_price AS (
\! echo		SELECT named_price.id , name, categories.category, from_supplier, 
\! echo		cost, prime_cost 
\! echo		FROM named_price
\! echo		LEFT OUTER JOIN categories ON named_price.category = categories.id),
\! echo	 named_dates AS (
\! echo		SELECT documentnumber, customers.customer, date1
\! echo		FROM sales_by_customer 
\! echo		LEFT OUTER JOIN customers ON sales_by_customer.customer = customers.id),
\! echo	 f_sales_by_models AS (
\! echo		SELECT sales_by_models.id, documentnumber, quantity, name, category, 
\! echo		from_supplier, cost, prime_cost
\! echo		FROM sales_by_models LEFT OUTER JOIN final_price 
\! echo		ON sales_by_models.documentnumber = final_price.id)
\! echo SELECT f_sales_by_models.id, date1, customer, quantity, name, category, 
\! echo from_supplier, cost, prime_cost  
\! echo FROM f_sales_by_models LEFT OUTER JOIN named_dates 
\! echo ON f_sales_by_models.documentnumber = named_dates.documentnumber;
\! echo ===================================================================

WITH named_price AS (
		SELECT price_of_models.id , models.model_name AS name, category, 
		from_supplier, cost, prime_cost 
		FROM price_of_models
		LEFT OUTER JOIN models ON price_of_models.name = models.id),
	 final_price AS (
		SELECT named_price.id , name, categories.category, from_supplier, 
		cost, prime_cost 
		FROM named_price
		LEFT OUTER JOIN categories ON named_price.category = categories.id),
	 named_dates AS (
		SELECT documentnumber, customers.customer, date1
		FROM sales_by_customer 
		LEFT OUTER JOIN customers ON sales_by_customer.customer = customers.id),
	 f_sales_by_models AS (
		SELECT sales_by_models.id, documentnumber, quantity, name, category, 
		from_supplier, cost, prime_cost
		FROM sales_by_models LEFT OUTER JOIN final_price 
		ON sales_by_models.documentnumber = final_price.id)
SELECT f_sales_by_models.id, date1, customer, quantity, name, category, 
from_supplier, cost, prime_cost  
FROM f_sales_by_models LEFT OUTER JOIN named_dates 
ON f_sales_by_models.documentnumber = named_dates.documentnumber;

