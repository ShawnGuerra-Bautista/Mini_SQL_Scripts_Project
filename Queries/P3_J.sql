-- WARNING: There is an actor with no name (Exclusion might be needed)
-- 1
CREATE VIEW co_actors AS
    (SELECT DISTINCT a2.name
    FROM actor AS a1, movie AS m1, actor AS a2
    WHERE a1.name = 'Annette Nicole' AND a1.mid = m1.mid
      AND a2.mid = m1.mid AND a2.name <> 'Annette Nicole');

SELECT COUNT(*) FROM co_actors;

-- 2
CREATE VIEW all_combinations AS
    (SELECT c.name, m.mid
    FROM co_actors AS c, movie AS m, actor AS a
    WHERE m.mid = a.mid AND a.name = 'Annette Nicole');

SELECT COUNT(*) FROM all_combinations;

-- 3
CREATE VIEW non_existent AS
    (SELECT ac.name, ac.mid
    FROM all_combinations AS ac EXCEPT
         (SELECT a.name, a.mid FROM actor AS a));

SELECT COUNT(*) FROM non_existent;

-- 4
-- No need to specify c.name <> 'Annette Nicole' as co_actors already exclude her
SELECT c.name
FROM co_actors AS c EXCEPT (SELECT DISTINCT n.name FROM non_existent AS n);