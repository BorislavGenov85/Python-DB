create table search_results(
    id serial PRIMARY KEY,
    first_name VARCHAR(30),
    salary float
);


create procedure sp_increase_salaries(
    IN department_name VARCHAR(30)
) AS
$$
  BEGIN
      TRUNCATE TABLE search_results;

      update employees
        set salary =  salary * 1.05
        WHERE department_id = (select
                                    d.department_id
                                from departments AS d
                                where d.name = department_name
                                order by first_name, salary) ;

      INSERT INTO search_results(
                first_name,
                salary
      )
        select
            first_name,
            salary
        from
            employees AS e
        WHERE department_id = ( select
                                    d.department_id
                                from departments AS d
                                where d.name = 'Finance')
        order by first_name , salary ;
end;
$$
LANGUAGE plpgsql;