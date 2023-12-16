CREATE TABLE
	mountains(
		id SERIAL PRIMARY KEY,
		name VARCHAR(50)
	);

CREATE TABLE peaks(
	id serial PRIMARY KEY,
	name VARCHAR(50),
	mountain_id int
);

ALTER TABLE peaks
ADD CONSTRAINT fk_peaks_mountains
FOREIGN KEY (mountain_id)
REFERENCES mountains(id);