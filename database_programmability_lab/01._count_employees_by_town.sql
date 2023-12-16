create function fn_count_employees_by_town(town_name VARCHAR(20))
returns int as
$$
    declare e_count int;
    begin
        select
            count(e.employee_id) INTO e_count
        from
            towns as t
        join
            addresses AS a
        ON t.town_id = a.town_id
        join
            employees AS e
        on a.address_id = e.address_id
        WHERE t.name = town_name;
        return e_count;
    end;
$$
language plpgsql;


