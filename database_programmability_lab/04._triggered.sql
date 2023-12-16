
CREATE TABLE deleted_employees(
    employee_id serial primary key,
    first_name VARCHAR(20),
    last_name VARCHAR(20),
    middle_name VARCHAR(20),
    job_title VARCHAR(50),
    department_id int,
    salary numeric(19,4)
);

CREATE OR REPLACE FUNCTION backup_fired_employees()
RETURNS TRIGGER AS
$$
    BEGIN
        INSERT INTO deleted_employees(
                    first_name,
                    last_name,
                    middle_name,
                    job_title,
                    department_id,
                    salary
                )
        VALUES (
                old.first_name,
                old.last_name,
                old.middle_name,
                old.job_title,
                old.department_id,
                old.salary
               );
        return new;
    end;
$$
LANGUAGE plpgsql;


CREATE OR REPLACE TRIGGER backup_employees
AFTER DELETE ON employees
FOR EACH ROW
EXECUTE PROCEDURE backup_fired_employees();
