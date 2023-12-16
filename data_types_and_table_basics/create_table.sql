CREATE TABLE
	employees(
		id serial PRIMARY key,
		first_name varchar(30),
		last_name varchar(50),
		hiring_date date DEFAULT '2023-01-01',
		salary NUMERIC(10,2),
		devices_number int
	);

CREATE TABLE
	departments(
		id serial PRIMARY key,
		"name" VARCHAR(30),
		code CHARACTER(3),
		description TEXT
	);

CREATE TABLE
	issues(
		id serial PRIMARY key UNIQUE,
		description VARCHAR(30),
		"date" date,
		"start" timestamp
	);