--create tables (DDL Statements)

CREATE TABLE salesperson (
	salesperson_id serial PRIMARY KEY,
	first_name VARCHAR(50) NOT NULL,
	last_name VARCHAR(50) NOT NULL
);

select *
from salesperson;

CREATE TABLE customer(
	customer_id serial PRIMARY KEY,
	first_name VARCHAR(50),
	last_name VARCHAR(50),
	phone_number VARCHAR(12),
	email VARCHAR(100),
	address VARCHAR(150),
	purchased_car BOOLEAN,
	serviced_car BOOLEAN
);

select *
from Customer;


CREATE TABLE car(
	car_id serial PRIMARY KEY, 
	make VARCHAR(50) NOT NULL,
	model VARCHAR(50) NOT NULL,
	color VARCHAR(50) NOT NULL,
	year_ VARCHAR(4) NOT NULL,
	for_sale BOOLEAN NOT NULL,
	salesperson_id INTEGER,
	FOREIGN KEY(salesperson_id) REFERENCES salesperson(salesperson_id),
	customer_id INTEGER,
	FOREIGN KEY(customer_id) REFERENCES customer(customer_id)
);


select *
from car;

CREATE TABLE sales_invoice(
	sales_invoice_id serial PRIMARY KEY,
	sales_price NUMERIC(8,2) NOT NULL,
	date_of_sale VARCHAR(10) NOT NULL,
	Car_id INTEGER NOT NULL,
	FOREIGN KEY(car_id) REFERENCES car(car_id),
	customer_id INTEGER NOT NULL, 
	FOREIGN KEY(customer_id) REFERENCES customer(customer_id),
	Salesperson_id INTEGER NOT NULL,
	FOREIGN KEY(salesperson_id) REFERENCES salesperson(salesperson_id)
);

select *
from sales_invoice;

CREATE TABLE mechanic(
	mechanic_id serial PRIMARY KEY,
	first_name VARCHAR(50),
	last_name VARCHAR(50)
);

select *
FROM mechanic;

CREATE TABLE service_ticket(
	service_ticket_id serial PRIMARY KEY,
	service_price NUMERIC(8,2),
	date_received VARCHAR(10),
	date_completed VARCHAR(10),
	car_id INTEGER NOT NULL, 
	FOREIGN KEY(car_id) REFERENCES car(car_id),
	customer_id INTEGER NOT NULL, 
	FOREIGN KEY(customer_id) REFERENCES customer(customer_id),
	mechanic_id INTEGER NOT NULL, 
	FOREIGN KEY(mechanic_id) REFERENCES mechanic(mechanic_id)
);

SELECT * 
FROM service_ticket;

CREATE TABLE service_records(
	car_id INTEGER NOT NULL,
	FOREIGN KEY(car_id) REFERENCES car(car_id),
	service_ticket_id INTEGER NOT NULL, 
	FOREIGN KEY(service_ticket_id) REFERENCES service_ticket(service_ticket_id)
);

SELECT *
FROM service_records;


--insert data (DML Statements)

--Adding data to salesperson table:

INSERT INTO salesperson(
	first_name,
	last_name
) VALUES (
	'Laila',
	'Schnazuer'
), (
	'Lucy',
	'Schnauzer'
);

SELECT *
FROM salesperson;

--Adding data to customer table:

INSERT INTO customer(
	first_name,
	last_name,
	phone_number,
	email,
	address,
	purchased_car,
	serviced_car
) VALUES (
	'Rachel',
	'Tucker',
	'123-456-1234',
	'racheltucker@spoofymail.com',
	'1 happy ln, happy, CO, 80863',
	'1',
	'0'
), (
	'Brian',
	'Tucker',
	'111-111-1111',
	'briantucker@spoofymail.com',
	'2 jolly dr, jolly, CO, 80863',
	'0',
	'1'
); 

--Adding more customers..

INSERT INTO customer(
	first_name,
	last_name,
	phone_number,
	email,
	address,
	purchased_car,
	serviced_car
) VALUES (
	'Jack',
	'Russell',
	'333-333-3333',
	'jackrussell@spoofymail.com',
	'123 wag tail dr. woof, NM, 88042',
	'1',
	'1'
), (
	'Shepard', 
	'German', 
	'000-000-0000',
	'shepardgerman@spoofymail.com',
	'333 dog treat cir, rainbow, CA, 90011', 
	'1',
	'0'
);

SELECT *
FROM customer;

--Create a "discount_program" column to customer table:

ALTER TABLE customer
ADD COLUMN discount_program BOOLEAN DEFAULT FALSE;

--Show all customers that have purchased a car:

SELECT customer_id
FROM customer
GROUP BY customer_id
HAVING purchased_car = TRUE;

--All customers that have purchased a car are members of the discount_program:
UPDATE customer 
SET discount_program = TRUE 
WHERE customer_id IN (
	SELECT customer_id
	FROM customer
	GROUP BY customer_id
	HAVING purchased_car = TRUE
);

--put above actions into a stored procedureL

CREATE PROCEDURE update_discount_program(discount_requirement BOOLEAN DEFAULT FALSE)
LANGUAGE plpgsql
AS $$
BEGIN 
	UPDATE customer 
	SET discount_program = TRUE 
	WHERE customer_id IN (
		SELECT customer_id
		FROM customer
		GROUP BY customer_id
		HAVING purchased_car = TRUE
	);
END;
$$;

--call procedure 
CALL update_discount_program();

--Adding data to car table:

INSERT INTO car(
	make,
	model,
	color, 
	year_,
	for_sale,
	salesperson_id,
	customer_id
) VALUES (
	'Honda', 
	'Fit',
	'Yellow',
	'2018',
	'0',
	'6',
	'1'
), (
	'Toyota',
	'Tunda',
	'Silver',
	'2022',
	'0',
	'6',
	'2'
);

--adding more cars:

INSERT INTO car(make, model, color, year_, for_sale, salesperson_id, customer_id)
VALUES('Jeep', 'Patriot', 'blue', '2010', '0', '7', '3'), ('Hyundai', 'Santa Cruz', 'silver', '2023', '0', '7', '4');

SELECT *
FROM car;

--Adding data to mechanic table:

INSERT INTO mechanic(
	first_name,
	last_name
) VALUES (
	'Billy',
	'Bob'
), (
	'Bob',
	'Billy'
);

SELECT *
FROM mechanic;

--Adding data to service_ticket table:

INSERT INTO service_ticket(
	service_price,
	date_received, 
	date_completed,
	car_id, 
	customer_id, 
	mechanic_id
) VALUES (
	'95.00',
	'12/05/2022',
	'12/05/2022',
	'3',
	'3',
	'1'
) , (
	'125.00',
	'01/03/2023',
	'01/05/2023',
	'2',
	'2',
	'2'
);

SELECT *
FROM service_ticket;

--Query to get all customers who purchased a car:
SELECT customer_id
FROM customer 
WHERE discount_program = TRUE;

--update all customers service price to 15% off:
UPDATE service_ticket 
SET service_price = service_price * 0.85
WHERE customer_id IN (
	SELECT customer_id
	FROM customer 
	WHERE discount_program = TRUE
);

--put into stored procedure:
CREATE PROCEDURE apply_discount()
LANGUAGE plpgsql
AS $$
BEGIN 
	UPDATE service_ticket 
	SET service_price = service_price * 0.85
	WHERE customer_id IN (
		SELECT customer_id
		FROM customer 
		WHERE discount_program = TRUE
	);
END;
$$;

CALL apply_discount();


--Add data to service_records

INSERT INTO service_recods(
	car_id,
	service_ticket_id
) VALUES (
	3,
	1
), (
	2,
	2
);

SELECT *
FROM service_recods;

INSERT INTO sales_invoice(
	sales_price, 
	date_of_sale, 
	car_id, --1,3,4
	customer_id, 
	salesperson_id
) VALUES (
	'14000',
	'11/05/2022',
	'1', 
	'1', 
	'6'
), (
	'9000',
	'12/05/2022',
	'3',
	'3', 
	'7'
), (
	'30000',
	'01/06/2023',
	'4',
	'4',
	'7'
);

SELECT * 
FROM sales_invoice;
	   
	














