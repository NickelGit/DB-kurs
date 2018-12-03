;
\! echo ===================================================================
\! echo ������ ���������� ��
\! echo ===================================================================

CREATE TABLE sales_by_customer(
documentNumber int PRIMARY KEY,
customer int NOT NULL,
Date1 date NOT NULL);
\! echo ===================================================================
\! echo ������� ������� 'sales_by_customer'
\! echo ===================================================================
CREATE TABLE sales_by_models(
id int PRIMARY KEY,
documentNumber int NOT NULL,
model int NOT NULL,
quantity int NOT NULL);
\! echo ===================================================================
\! echo ������� ������� 'sales_by_models'
\! echo ===================================================================
CREATE TABLE price_of_models(
id int PRIMARY KEY,
name int NOT NULL,
category int NOT NULL,
from_supplier boolean NOT NULL,
cost numeric(15,2) NOT NULL,
prime_cost numeric(15,2) NOT NULL);
\! echo ===================================================================
\! echo ������� ������� 'price_of_models'
\! echo ===================================================================
CREATE TABLE models(
id int PRIMARY KEY,
model_name varchar(255) NOT NULL);
\! echo ===================================================================
\! echo ������� ������� 'models'
\! echo ===================================================================
CREATE TABLE categories(
id int PRIMARY KEY,
category varchar(255) NOT NULL);
\! echo ===================================================================
\! echo ������� ������� 'categories'
\! echo ===================================================================
CREATE TABLE customers(
id int PRIMARY KEY,
customer varchar(255) NOT NULL);
\! echo ===================================================================
\! echo ������� ������� 'customers'
\! echo ===================================================================
ALTER TABLE price_of_models
	ADD CONSTRAINT price_of_models_name_FK
		FOREIGN KEY (name)
		REFERENCES models (id);
\! echo ===================================================================
\! echo ��������� ������� ���� ��� ������� 'price_of_models'
\! echo ===================================================================
ALTER TABLE price_of_models
	ADD CONSTRAINT price_of_models_category_FK
		FOREIGN KEY (category)
		REFERENCES categories (id);
\! echo ===================================================================
\! echo ��������� ������� ���� ��� ������� 'price_of_models'
\! echo ===================================================================
ALTER TABLE sales_by_models
	ADD CONSTRAINT sales_by_models_model_FK
		FOREIGN KEY (model)
		REFERENCES price_of_models (id);
\! echo ===================================================================
\! echo ��������� ������� ���� ��� ������� 'sales_by_models'
\! echo ===================================================================
ALTER TABLE sales_by_models
	ADD CONSTRAINT sales_by_models_documentnumber_FK
		FOREIGN KEY (documentnumber)
		REFERENCES sales_by_customer (documentnumber);
\! echo ===================================================================
\! echo ��������� ������� ���� ��� ������� 'sales_by_models'
\! echo ===================================================================
ALTER TABLE sales_by_customer
	ADD CONSTRAINT sales_by_customers_customer_FK
		FOREIGN KEY (customer)
		REFERENCES customers (id);
\! echo ===================================================================
\! echo ��������� ������� ���� ��� ������� 'sales_by_customer'
\! echo ===================================================================
CREATE SEQUENCE SEQ_SBC
INCREMENT BY 1
START WITH 1
MINVALUE 1;
\! echo ===================================================================
\! echo ������� ������������������ ��� id ������� 'sales_by_customer'
\! echo ===================================================================
CREATE SEQUENCE SEQ_SBM
INCREMENT BY 1
START WITH 1
MINVALUE 1;
\! echo ===================================================================
\! echo ������� ������������������ ��� id ������� 'sales_by_models'
\! echo ===================================================================
CREATE SEQUENCE seq_pom
INCREMENT BY 1
START WITH 1
MINVALUE 1;
\! echo ===================================================================
\! echo ������� ������������������ ��� id ������� 'price_of_models'
\! echo ===================================================================
CREATE SEQUENCE SEQ_Models
INCREMENT BY 1
START WITH 1
MINVALUE 1;
\! echo ===================================================================
\! echo ������� ������������������ ��� id ������� 'models'
\! echo ===================================================================
CREATE SEQUENCE SEQ_Categories
INCREMENT BY 1
START WITH 1
MINVALUE 1;
\! echo ===================================================================
\! echo ������� ������������������ ��� id ������� 'categories'
\! echo ===================================================================
CREATE SEQUENCE SEQ_Customers
INCREMENT BY 1
START WITH 1
MINVALUE 1;
\! echo ===================================================================
\! echo ������� ������������������ ��� id ������� 'customers'
\! echo ===================================================================
INSERT INTO categories VALUES (nextval('seq_categories'), '������� ��������� ����');
INSERT INTO categories VALUES (nextval('seq_categories'), '������� ��������� ����');
INSERT INTO categories VALUES (nextval('seq_categories'), '�������� ��������� ����');
INSERT INTO categories VALUES (nextval('seq_categories'), '���������');
\! echo ===================================================================
\! echo ������� 'categories' ���������� �������
\! echo ===================================================================
INSERT INTO models VALUES (nextval('seq_models'), 'HP pro desk 007');
INSERT INTO models VALUES (nextval('seq_models'), 'Home PC 002');
INSERT INTO models VALUES (nextval('seq_models'), 'Game PC 3000');
INSERT INTO models VALUES (nextval('seq_models'), 'HP LJ 1002');
INSERT INTO models VALUES (nextval('seq_models'), 'HP MFP 400');
INSERT INTO models VALUES (nextval('seq_models'), 'HP KB 1010');
INSERT INTO models VALUES (nextval('seq_models'), 'HP M 1');
INSERT INTO models VALUES (nextval('seq_models'), 'Razor X7');
INSERT INTO models VALUES (nextval('seq_models'), 'Baikal');
\! echo ===================================================================
\! echo ������� 'models' ���������� �������
\! echo ===================================================================
INSERT INTO customers VALUES (nextval('seq_customers'), '��������� ����������');
INSERT INTO customers VALUES (nextval('seq_customers'), '�� ������');
INSERT INTO customers VALUES (nextval('seq_customers'), '���� ����� ������');
INSERT INTO customers VALUES (nextval('seq_customers'), '��� �������');
INSERT INTO customers VALUES (nextval('seq_customers'), '�� ������');
INSERT INTO customers VALUES (nextval('seq_customers'), '�������');
\! echo ===================================================================
\! echo ������� 'customers' ���������� �������
\! echo ===================================================================
INSERT INTO price_of_models VALUES (nextval('seq_pom'), 1, 1, true, 40000, 35000);
INSERT INTO price_of_models VALUES (nextval('seq_pom'), 1, 1, false, 40000, 30000);
INSERT INTO price_of_models VALUES (nextval('seq_pom'), 2, 3, true, 30000, 25000);
INSERT INTO price_of_models VALUES (nextval('seq_pom'), 2, 3, false, 30000, 20000);
INSERT INTO price_of_models VALUES (nextval('seq_pom'), 3, 2, true, 120000, 100000);
INSERT INTO price_of_models VALUES (nextval('seq_pom'), 4, 4, true, 12000, 10000);
INSERT INTO price_of_models VALUES (nextval('seq_pom'), 5, 4, true, 20000, 17000);
INSERT INTO price_of_models VALUES (nextval('seq_pom'), 6, 4, true, 700, 500);
INSERT INTO price_of_models VALUES (nextval('seq_pom'), 7, 4, true, 300, 200);
INSERT INTO price_of_models VALUES (nextval('seq_pom'), 8, 4, true, 3500, 3000);
\! echo ===================================================================
\! echo ������� 'price_of_models' ���������� �������
\! echo ===================================================================
INSERT INTO sales_by_customer VALUES (nextval('seq_sbc'), 2, date '2018-02-01');
INSERT INTO sales_by_customer VALUES (nextval('seq_sbc'), 3, date '2018-02-08');
INSERT INTO sales_by_customer VALUES (nextval('seq_sbc'), 3, date '2018-02-15');
INSERT INTO sales_by_customer VALUES (nextval('seq_sbc'), 1, date '2018-02-15');
INSERT INTO sales_by_customer VALUES (nextval('seq_sbc'), 1, date '2018-02-22');
INSERT INTO sales_by_customer VALUES (nextval('seq_sbc'), 1, date '2018-02-22');
INSERT INTO sales_by_customer VALUES (nextval('seq_sbc'), 1, date '2018-02-22');
INSERT INTO sales_by_customer VALUES (nextval('seq_sbc'), 4, date '2018-02-23');
INSERT INTO sales_by_customer VALUES (nextval('seq_sbc'), 5, date '2018-02-23');
INSERT INTO sales_by_customer VALUES (nextval('seq_sbc'), 6, date '2018-02-23');
\! echo ===================================================================
\! echo ������� 'sales_by_customer' ���������� �������
\! echo ===================================================================
INSERT INTO sales_by_models VALUES (nextval('seq_sbm'), 1, 1, 2);
INSERT INTO sales_by_models VALUES (nextval('seq_sbm'), 1, 2, 2);
INSERT INTO sales_by_models VALUES (nextval('seq_sbm'), 2, 1, 6);
INSERT INTO sales_by_models VALUES (nextval('seq_sbm'), 2, 2, 4);
INSERT INTO sales_by_models VALUES (nextval('seq_sbm'), 3, 8, 10);
INSERT INTO sales_by_models VALUES (nextval('seq_sbm'), 3, 9, 10);
INSERT INTO sales_by_models VALUES (nextval('seq_sbm'), 3, 7, 4);
INSERT INTO sales_by_models VALUES (nextval('seq_sbm'), 4, 4, 1);
INSERT INTO sales_by_models VALUES (nextval('seq_sbm'), 5, 10, 1);
INSERT INTO sales_by_models VALUES (nextval('seq_sbm'), 6, 10, 1);
INSERT INTO sales_by_models VALUES (nextval('seq_sbm'), 7, 10, 1);
INSERT INTO sales_by_models VALUES (nextval('seq_sbm'), 7, 5, 1);
INSERT INTO sales_by_models VALUES (nextval('seq_sbm'), 8, 5, 10);
INSERT INTO sales_by_models VALUES (nextval('seq_sbm'), 8, 8, 10);
INSERT INTO sales_by_models VALUES (nextval('seq_sbm'), 8, 10, 10);
INSERT INTO sales_by_models VALUES (nextval('seq_sbm'), 9, 9, 4);
INSERT INTO sales_by_models VALUES (nextval('seq_sbm'), 9, 8, 4);
INSERT INTO sales_by_models VALUES (nextval('seq_sbm'), 9, 2, 4);
INSERT INTO sales_by_models VALUES (nextval('seq_sbm'), 9, 6, 4);
INSERT INTO sales_by_models VALUES (nextval('seq_sbm'), 10, 6, 2);
\! echo ===================================================================
\! echo ������� 'sales_by_models' ���������� �������
\! echo ===================================================================


