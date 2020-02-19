-- WARNING: There is an actor with no name (Exclusion might be needed)
CREATE VIEW co_actors_number AS
    (SELECT a1.name, COUNT(DISTINCT a2.name) as num_actor
    FROM actor AS a1, movie AS m1, actor AS a2
    WHERE a1.mid = m1.mid AND m1.mid = a2.mid AND a1.name <> a2.name
    GROUP BY a1.name);

SELECT cn1.name, cn1.num_actor
FROM co_actors_number as cn1
WHERE cn1.num_actor >= (SELECT MAX(cn2.num_actor) FROM co_actors_number as cn2)
ORDER BY cn1.name ASC;
