\! echo ===================================================================
\! echo 7.1 ������� ����� �����, ��������������� ������������� �������
\! echo ��� ������ �� ������� models ��� ��� ������ ���������� � HP
\! echo ������ - SELECT * FROM models WHERE model_name LIKE 'HP%';
\! echo ===================================================================

SELECT * FROM models WHERE model_name LIKE 'HP%';



\! echo ===================================================================
\! echo 7.2 ������� ����� �����, ��������������� �� ������������� ���� �� �����������
\! echo ��� ������ �� ������� customers ��������������� �� ���� customer
\! echo ������ - SELECT * FROM customers ORDER BY customer;
\! echo ===================================================================

SELECT * FROM customers ORDER BY customer;



\! echo ===================================================================
\! echo 7.2 ������� ����� �����, ��������������� �� ������������� ���� �� ��������
\! echo ��� ������ �� ������� customers ��������������� �� ���� id
\! echo ������ - SELECT * FROM customers ORDER BY id DESC;
\! echo ===================================================================

SELECT * FROM customers ORDER BY id DESC;



\! echo ===================================================================
\! echo 7.3 ������������������ ��������� �����������
\! echo ���������� ������� �� ����������� �� �������
\! echo ������ - SELECT customer, COUNT(*) AS count_of_sales FROM sales_by_customer  WHERE customer IN
\! echo		(SELECT DISTINCT customer FROM sales_by_customer WHERE date1 BETWEEN '2018-02-01' AND '2018-02-28') GROUP BY customer;
\! echo ===================================================================

SELECT customer, COUNT(*) AS count_of_sales FROM sales_by_customer  WHERE customer IN 
(SELECT DISTINCT customer FROM sales_by_customer WHERE date1 BETWEEN '2018-02-01' AND '2018-02-28') GROUP BY customer;



\! echo ===================================================================
\! echo 7.4 ������������ ����� ������ �� ���������� ������ � ������� ��������� ���������� (������������ �����������)
\! echo ���������� ������� price_of_models � model_name ��� ������������ ���������� � ������� ������ ��������
\! echo ������ - SELECT price_of_models.id , model_name AS Name, from_supplier, cost , prime_cost
\! echo 	FROM price_of_models LEFT OUTER JOIN models ON price_of_models.name = models.id;
\! echo ===================================================================

SELECT price_of_models.id , model_name AS Name, from_supplier, cost , prime_cost  
FROM price_of_models LEFT OUTER JOIN models ON price_of_models.name = models.id;



\! echo ===================================================================
\! echo 7.4 ������������ ����� ������ �� ���������� ������ � ������� ��������� ���������� (������������� ����������)
\! echo ���������� ������� price_of_models � model_name ��� ������������ ���������� � ������� ������ ��������
\! echo Baikal �� ������� � ������� price_of_models ��� ������������ ������� ����� ������������� � ������������� ������������
\! echo ��� ������ �� ������� models ��� ��� ������ ���������� � HP
\! echo ������ - SELECT price_of_models.id , model_name AS Name, from_supplier, cost , prime_cost
\! echo 	FROM price_of_models RIGHT OUTER JOIN models ON price_of_models.name = models.id;
\! echo ===================================================================

SELECT price_of_models.id , model_name AS Name, from_supplier, cost , prime_cost  
FROM price_of_models RIGHT OUTER JOIN models ON price_of_models.name = models.id;



\! echo ===================================================================
\! echo 8 ������������ ����� ������ �� ���������� ������ � ������� ��������� ��������
\! echo ��������� ������ ������� � ������� �� ���� ��
\! echo ������: 
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

