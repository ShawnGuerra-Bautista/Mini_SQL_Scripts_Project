-- 1
CREATE VIEW high_ratings AS
    (SELECT DISTINCT a.name
    FROM actor AS a, movie AS m
    WHERE a.mid = m.mid AND m.rating >= 4.0);

CREATE VIEW low_ratings AS
    (SELECT DISTINCT a.name
    FROM actor AS a, movie AS m
    WHERE a.mid = m.mid AND m.rating <= 4.0);
-- 2
SELECT COUNT(*)
FROM ((SELECT * FROM high_ratings) EXCEPT (SELECT * FROM low_ratings)) AS no_flop_actors;

-- 3
SELECT no_flop_actors.name, COUNT(*) AS acting_times
FROM ((SELECT * FROM high_ratings) EXCEPT (SELECT * FROM low_ratings)) AS no_flop_actors, actor AS a, movie AS m
WHERE no_flop_actors.name = a.name AND a.mid = m.mid
GROUP BY no_flop_actors.name
ORDER BY acting_times DESC, no_flop_actors.name ASC
LIMIT 10;