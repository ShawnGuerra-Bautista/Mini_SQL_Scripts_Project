CREATE MATERIALIZED VIEW co_actors_number AS
    (SELECT a1.name, COUNT(DISTINCT a2.name) as num_actor
    FROM actor AS a1, movie AS m1, actor AS a2
    WHERE a1.mid = m1.mid AND m1.mid = a2.mid AND a1.name <> a2.name
    GROUP BY a1.name);

-- 95199 rows affected in 8 s 374 ms

CREATE INDEX actor_name_index ON co_actors_number(name);
CREATE INDEX num_of_actor_index ON co_actors_number(num_actor);

SELECT cn1.name, cn1.num_actor
FROM co_actors_number as cn1
WHERE cn1.num_actor >= (SELECT MAX(cn2.num_actor) FROM co_actors_number as cn2)
ORDER BY cn1.name ASC;

-- Reported Time
-- 1 row retrieved starting from 1 in 25 ms (execution: 4 ms, fetching: 21 ms)
-- 1 row retrieved starting from 1 in 29 ms (execution: 4 ms, fetching: 25 ms)
-- 1 row retrieved starting from 1 in 32 ms (execution: 5 ms, fetching: 27 ms)