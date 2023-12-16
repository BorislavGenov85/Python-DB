select
    first_name,
    last_name,
    to_char(born, 'YYYY') AS year
from
    authors