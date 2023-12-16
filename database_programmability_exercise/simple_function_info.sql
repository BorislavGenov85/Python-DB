--Simple function
CREATE OR REPLACE FUNCTION fn_full_name(VARCHAR, VARCHAR)
RETURNS VARCHAR AS
$$
BEGIN
    RETURN concat($1, ' ', $2);
END;
$$
LANGUAGE plpgsql;   plpgsql = Procedurel LANGUAGE PostGresSQL

-- Function with alias
CREATE OR REPLACE FUNCTION fn_full_name(VARCHAR, VARCHAR)
RETURNS VARCHAR AS
$$
    DECLARE
        first_name ALIAS FOR $1;
        last_name ALIAS FOR $2;
BEGIN
    RETURN concat(first_name, ' ', last_name);
END;
$$
LANGUAGE plpgsql;

SELECT fn_full_name('Cvetan', 'Tomov') AS "Full Name"

-- Function with if else
CREATE OR REPLACE FUNCTION fn_full_name(first_name VARCHAR, last_name VARCHAR)
RETURNS VARCHAR AS
$$
    DECLARE
        full_name VARCHAR;
BEGIN
    IF first_name IS NULL AND last_name IS NULL THEN
        full_name := NULL;
    ELSIF first_name IS NULL THEN
        full_name := last_name;
    ELSIF last_name IS NULL THEN
        full_name := first_name;
    ELSE
        full_name := concat(first_name, ' ', last_name);
    END IF;
    RETURN full_name;
END;
$$
LANGUAGE plpgsql;

-- Function with named parameters
CREATE OR REPLACE FUNCTION fn_get_city_id(city_name VARCHAR)
RETURNS INT AS
$$
    DECLARE
        city_id INT;

    BEGIN
        SELECT id FROM cities WHERE LOWER(NAME) = LOWER(city_name)
        INTO  city_id;

        IF city_id IS NULL
            THEN RETURN 17;
        ELSE
            RETURN city_id;
        END IF;
    END;
$$
LANGUAGE plpgsql;

INSERT INTO persons(first_name, last_name, city_id)
VALUES ('Pencho', 'Kubadinski', fn_get_city_id('Plovdiv'));

-- Function with in out parameters
CREATE OR REPLACE FUNCTION fn_get_city_id(IN city_name VARCHAR, OUT city_id INT)
AS
$$
    BEGIN
        SELECT id FROM cities WHERE LOWER(NAME) = LOWER(city_name)
        INTO  city_id;
    END;
$$
LANGUAGE plpgsql;

SELECT fn_get_city_id('Varna')

-- Function with two out parameters
CREATE OR REPLACE FUNCTION fn_get_city_id(
    IN city_name VARCHAR,
    OUT city_id INT,
    OUT status INT
    )
AS
$$
    DECLARE
        temp_id INT;
    BEGIN
        SELECT id FROM cities WHERE LOWER(NAME) = LOWER(city_name)
        INTO  temp_id;

        IF temp_id IS NULL THEN
            SELECT 100 INTO status;
        ELSE
            SELECT temp_id, 0 INTO city_id, status;
        END IF;
    END;
$$
LANGUAGE plpgsql;

SELECT * FROM fn_get_city_id('Varna');

-- Procedure transfer money
CREATE OR REPLACE PROCEDURE p_transfer_money(
    IN sender_id INT,
    IN receiver_id INT,
    IN transfer_amount FLOAT,
    OUT status VARCHAR
)
AS
$$
    DECLARE
        sender_amount FLOAT;
        receiver_amount FLOAT;
        temp_val FLOAT;
    BEGIN
        SELECT b.amount FROM bank AS b WHERE id = sender_id INTO sender_amount;
        IF sender_amount < transfer_amount THEN
            status := 'Not enough money';
            RETURN;
        END IF;
        SELECT b.amount FROM bank AS b WHERE id = receiver_id INTO receiver_amount;
        UPDATE bank SET amount = amount - transfer_amount WHERE id = sender_id;
        UPDATE bank SET amount = amount + transfer_amount WHERE id = receiver_id;
        SELECT b.amount FROM bank AS b WHERE id = sender_id INTO temp_val;
        IF sender_amount - transfer_amount <> temp_val THEN
            status = 'Error in sender';
            ROLLBACK;
            RETURN;
        END IF;
        SELECT b.amount FROM bank AS b WHERE id = receiver_id INTO temp_val;
        IF receiver_amount + transfer_amount <> temp_val THEN
            status := 'Error in receiver';
            ROLLBACK ;
            RETURN;
        END IF;
        status := 'Transfer done';
--         COMMIT;
        RETURN;
    END;
$$
LANGUAGE plpgsql;

call p_transfer_money(1, 2, 800.0, NULL);

-- Create trigger to log data in another table

DROP TABLE IF EXISTS items;
CREATE TABLE items(
    id SERIAL PRIMARY KEY,
    status INT,
    created DATE
);

DROP TABLE IF EXISTS item_logs;
CREATE TABLE item_logs(
    id SERIAL PRIMARY KEY,
    status INT,
    created DATE
);

CREATE FUNCTION log_items()
RETURNS TRIGGER
LANGUAGE plpgsql
AS
$$
    BEGIN
        INSERT INTO item_logs (status, created)
        VALUES (NEW.status, NEW.created);
        RETURN NEW;
    END;
$$
;

CREATE TRIGGER log_items_trigger
AFTER INSERT ON items
FOR EACH ROW
EXECUTE PROCEDURE log_items();

INSERT INTO items(status, created)
VALUES
    (4, NOW()),
    (5, NOW()),
    (6, NOW()),
    (7, NOW())
;

SELECT * FROM item_logs;

-- Create trigger to keep only 10 records in log table

CREATE OR REPLACE FUNCTION delete_last_item_log()
RETURNS TRIGGER
AS
$$
BEGIN
    WHILE (SELECT COUNT(*) FROM item_logs) > 10 LOOP
        DELETE FROM item_logs WHERE id = (SELECT MIN(id) FROM item_logs);
    END LOOP;
    RETURN NEW;
END;
$$
LANGUAGE plpgsql;


CREATE OR REPLACE TRIGGER clear_item_logs
AFTER INSERT ON item_logs
FOR EACH STATEMENT
EXECUTE PROCEDURE delete_last_item_log();