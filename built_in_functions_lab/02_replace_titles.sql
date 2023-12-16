SELECT
    replace(title, 'The', '***')
FROM
    books
WHERE title ILIKE 'The%'
ORDER BY id;