SELECT
	e.employee_id,
	concat(e.first_name, ' ', last_name) AS full_name,
	p.project_id,
	p.name AS project_name
FROM
	employees AS e
		JOIN employees_projects AS e_p
			USING (employee_id)
				JOIN projects AS p
					USING (project_id)
WHERE project_id = 1