SELECT
	t.town_id,
	t.name AS town_name,
	a.address_text
FROM
	towns AS t
		JOIN addresses AS a
			USING (town_id)
WHERE name IN ('San Francisco', 'Sofia', 'Carnation')
ORDER BY town_id, address_id