\! echo ===================================================================
\! echo 9 Для обработки табличных данных необходимо разработать следующие 
\! echo представления и продемонстрировать их выполнение: сложный синтаксис
\! echo скрывает сложный синтаксис запроса из пункта 8
\! echo запрос - CREATE VIEW fullTable AS 
\! echo  *запрос из пункта 8*
\! echo ===================================================================

CREATE VIEW fullTable AS 
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
from_supplier, cost AS price, prime_cost, cost - prime_cost AS profit  
FROM f_sales_by_models LEFT OUTER JOIN named_dates 
ON f_sales_by_models.documentnumber = named_dates.documentnumber;

\! echo ===================================================================
\! echo 9 Для обработки табличных данных необходимо разработать следующие 
\! echo представления и продемонстрировать их выполнение: скрытие столбцов и строк
\! echo запрос - CREATE VIEW modelsNames AS
\! echo SELECT model_name FROM models;
\! echo ===================================================================

CREATE VIEW modelsNames AS
SELECT model_name FROM models;

\! echo ===================================================================
\! echo 10 Создание триггеров в PostgreSQL.Необходимо создать два разных триггера 
\! echo с точки зрения их типов и выполняемых функций.
\! echo предваряющий триггер запускающий функцию проверки бизнес правила:
\! echo "Стоимость продажи должна быть выше себестоимости"
\! echo функция - CREATE OR REPLACE FUNCTION cost_check()
\! echo	RETURNS trigger AS $cost_check$
\! echo	BEGIN
\! echo		IF NEW.cost < NEW.prime_cost THEN
\! echo			RAISE EXCEPTION 'Цена  не может быть ниже себестоимости';
\! echo			RETURN NULL;
\! echo		END IF;
\! echo		RETURN NEW;
\! echo	END;
\! echo	$cost_check$ LANGUAGE plpgsql;
\! echo запрос создания триггера -
\! echo CREATE TRIGGER cost_check
\! echo		BEFORE INSERT ON price_of_models
\! echo		FOR EACH ROW EXECUTE PROCEDURE cost_check();
\! echo ===================================================================

CREATE OR REPLACE FUNCTION cost_check()
	RETURNS trigger AS $cost_check$
	BEGIN
		IF NEW.cost < NEW.prime_cost THEN
			RAISE EXCEPTION 'Цена  не может быть ниже себестоимости';
			RETURN NULL;
		END IF;
	
		RETURN NEW;
	END;
	$cost_check$ LANGUAGE plpgsql;
	
	CREATE TRIGGER cost_check
		BEFORE INSERT ON price_of_models
		FOR EACH ROW EXECUTE PROCEDURE cost_check();
		
\! echo ===================================================================
\! echo 10 Создание триггеров в PostgreSQL.Необходимо создать два разных триггера 
\! echo с точки зрения их типов и выполняемых функций.
\! echo замещающий триггер обновляющий таблицу price_of_models на основании которой построено представление	
\! echo CREATE OR REPLACE FUNCTION fullTable_update()
\! echo		RETURNS trigger AS $fullTable_update$
\! echo	BEGIN
\! echo		UPDATE price_of_models pom
\! echo		SET from_supplier = NEW.from_supplier, cost = NEW.cost, prime_cost = NEW.prime_cost, name = (SELECT id FROM models WHERE model_name = NEW.name)
\! echo		WHERE pom.id = OLD.id; 
\! echo		RETURN NEW;
\! echo	END;
\! echo	$fullTable_update$ LANGUAGE plpgsql;
\! echo	CREATE TRIGGER fullTable_update
\! echo		INSTEAD OF UPDATE ON fullTable
\! echo		FOR EACH ROW EXECUTE PROCEDURE fullTable_update();		
\! echo ===================================================================

CREATE OR REPLACE FUNCTION fullTable_update()
		RETURNS trigger AS $fullTable_update$
	BEGIN
		UPDATE price_of_models pom
		SET from_supplier = NEW.from_supplier, cost = NEW.price, prime_cost = NEW.prime_cost, name = (SELECT id FROM models WHERE model_name = NEW.name)
		WHERE name = (SELECT id FROM models WHERE model_name = OLD.name) AND category = (SELECT id FROM categories WHERE category = OLD.category) AND from_supplier = OLD.from_supplier; 
		RETURN NEW;
END;
$fullTable_update$ LANGUAGE plpgsql;
	CREATE TRIGGER fullTable_update
		INSTEAD OF UPDATE ON fullTable
		FOR EACH ROW EXECUTE PROCEDURE fullTable_update();

		
		
\! echo ===================================================================
\! echo 11 Создание хранимых процедур и функций в PostgreSQL. 
\! echo Необходимо написать одну хранимую процедуру и одну функцию, 
\! echo обрабатывающие данные из таблиц и продемонстрировать их выполнение 
\! echo (например, путем вызова их из анонимного блока SQL Shell)
\! echo выводит данные за период между датами startDate и endDate (даты необходимо вводить в формате '20180212' - что будет равно 12 февраля 2018 года)
\! echo ===================================================================
\! echo ==============================
\! echo Прибыль в разрезах категорий техники:
\! echo создание типа данных для вывода в функции
\! echo CREATE TYPE sub_profit_C AS (
\! echo	category varchar,
\! echo	profit numeric		
\! echo );
\! echo создание функции отображающей прибыль в разрезах категорий за указанный период
\! echo CREATE OR REPLACE FUNCTION profit_C( startDate IN date, endDate IN date) 
\! echo RETURNS SETOF sub_profit_C AS $profit_C$
\! echo
\! echo	SELECT  * FROM (SELECT category, SUM(profit) AS profit FROM fullTable WHERE date1 BETWEEN startDate AND endDate GROUP BY category) sub ORDER BY profit DESC;	
\! echo
\! echo $profit_C$
\! echo language sql;
\! echo ==============================

CREATE TYPE sub_profit_C AS (
	category varchar,
	profit numeric		
);

CREATE OR REPLACE FUNCTION profit_C( startDate IN date, endDate IN date) 
RETURNS SETOF sub_profit_C AS $profit_C$

	SELECT  * FROM (SELECT category, SUM(profit) AS profit FROM fullTable WHERE date1 BETWEEN startDate AND endDate GROUP BY category) sub ORDER BY profit DESC;	

$profit_C$
language sql;

\! echo ==============================
\! echo Прибыль за период:
\! echo CREATE OR REPLACE FUNCTION profit_Per( startDate IN date, endDate IN date) 
\! echo RETURNS numeric AS $profit_Per$
\! echo	SELECT SUM(profit) FROM fullTable WHERE date1 BETWEEN startDate AND endDate;	
\! echo $profit_Per$
\! echo language sql;
\! echo ==============================

CREATE OR REPLACE FUNCTION profit_Per( startDate IN date, endDate IN date) 
RETURNS numeric AS $profit_Per$

	SELECT SUM(profit) FROM fullTable WHERE date1 BETWEEN startDate AND endDate;	

$profit_Per$
language sql;


\! echo ==============================
\! echo Сумма продаж за указанный период:
\! echo CREATE OR REPLACE FUNCTION sales_Summ( startDate IN date, endDate IN date) 
\! echo RETURNS numeric AS $sales_Summ$
\! echo	SELECT SUM(price) FROM fullTable WHERE date1 BETWEEN startDate AND endDate;	
\! echo $sales_Summ$
\! echo language sql;	
\! echo ==============================


CREATE OR REPLACE FUNCTION sales_Summ( startDate IN date, endDate IN date) 
RETURNS numeric AS $sales_Summ$

	SELECT SUM(price) FROM fullTable WHERE date1 BETWEEN startDate AND endDate;	

$sales_Summ$
language sql;

\! echo ==============================
\! echo Количество проданной за период техники с разбивкой по наименованиям техники за указанный период :
\! echo создание типа данных для вывода в функции:
\! echo CREATE TYPE sub_quanTech_name AS (
\! echo	name varchar,
\! echo	quantity bigint		
\! echo );	
\! echo создание функции:
\! echo CREATE OR REPLACE FUNCTION quanTech_name( startDate IN date, endDate IN date) 
\! echo RETURNS SETOF sub_quanTech_name AS $quanTech_name$
\! echo	SELECT * FROM (SELECT name, SUM(quantity) AS quantity FROM fullTable WHERE date1 BETWEEN startDate AND endDate GROUP BY name) sub ORDER BY quantity DESC;
\! echo $quanTech_name$
\! echo language sql;
\! echo ==============================

CREATE TYPE sub_quanTech_name AS (
	name varchar,
	quantity bigint		
);


CREATE OR REPLACE FUNCTION quanTech_name( startDate IN date, endDate IN date) 
RETURNS SETOF sub_quanTech_name AS $quanTech_name$

	SELECT * FROM (SELECT name, SUM(quantity) AS quantity FROM fullTable WHERE date1 BETWEEN startDate AND endDate GROUP BY name) sub ORDER BY quantity DESC;

$quanTech_name$
language sql;


\! echo ==============================
\! echo Количество проданной за период техники:
\! echo CREATE OR REPLACE FUNCTION quanTechP( startDate IN date, endDate IN date) 
\! echo RETURNS bigint AS $quanTechP$
\! echo	SELECT SUM(quantity) FROM fullTable WHERE date1 BETWEEN startDate AND endDate;	
\! echo $quanTechP$
\! echo language sql;		
\! echo ==============================


CREATE OR REPLACE FUNCTION quanTechP( startDate IN date, endDate IN date) 
RETURNS bigint AS $quanTechP$

	SELECT SUM(quantity) FROM fullTable WHERE date1 BETWEEN startDate AND endDate;	

$quanTechP$
language sql;	

	



