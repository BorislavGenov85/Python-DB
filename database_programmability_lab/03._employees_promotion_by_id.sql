CREATE  PROCEDURE sp_increase_salary_by_id(id INT)
    AS
$$
    BEGIN
        if (select salary from employees where employee_id = id) is null then
            return;
        else
            update employees set salary = salary * 1.05 where employee_id = id;
        end if;
    end;
$$
language plpgsql;