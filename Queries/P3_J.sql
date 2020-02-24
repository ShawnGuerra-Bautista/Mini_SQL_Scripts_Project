-- WARNING: There is an actor with no name (Exclusion might be needed)
-- 1
CREATE VIEW co_actors AS
    (SELECT DISTINCT a2.name
    FROM actor AS a1, movie AS m1, actor AS a2
    WHERE a1.name = 'Annette Nicole' AND a1.mid = m1.mid
      AND a2.mid = m1.mid AND a2.name <> 'Annette Nicole');

SELECT COUNT(*) FROM co_actors;

-- Without Indexing
-- 1 row retrieved starting from 1 in 53 ms (execution: 33 ms, fetching: 20 ms)
-- 1 row retrieved starting from 1 in 46 ms (execution: 31 ms, fetching: 15 ms)
-- 1 row retrieved starting from 1 in 36 ms (execution: 23 ms, fetching: 13 ms)

-- With Indexing
-- 1 row retrieved starting from 1 in 17 ms (execution: 4 ms, fetching: 13 ms)
-- 1 row retrieved starting from 1 in 21 ms (execution: 5 ms, fetching: 16 ms)
-- 1 row retrieved starting from 1 in 31 ms (execution: 8 ms, fetching: 23 ms)

-- 2
CREATE VIEW all_combinations AS
    (SELECT c.name, m.mid
    FROM co_actors AS c, movie AS m, actor AS a
    WHERE m.mid = a.mid AND a.name = 'Annette Nicole');

SELECT COUNT(*) FROM all_combinations;

-- Without Indexing
-- 1 row retrieved starting from 1 in 67 ms (execution: 47 ms, fetching: 20 ms)
-- 1 row retrieved starting from 1 in 91 ms (execution: 46 ms, fetching: 45 ms)
-- 1 row retrieved starting from 1 in 55 ms (execution: 41 ms, fetching: 14 ms)

-- With Indexing
-- 1 row retrieved starting from 1 in 23 ms (execution: 6 ms, fetching: 17 ms)
-- 1 row retrieved starting from 1 in 28 ms (execution: 6 ms, fetching: 22 ms)
-- 1 row retrieved starting from 1 in 33 ms (execution: 7 ms, fetching: 26 ms)

-- 3
CREATE VIEW non_existent AS
    (SELECT ac.name, ac.mid
    FROM all_combinations AS ac EXCEPT
         (SELECT a.name, a.mid FROM actor AS a));

SELECT COUNT(*) FROM non_existent;

-- Without Indexing
-- 1 row retrieved starting from 1 in 109 ms (execution: 95 ms, fetching: 14 ms)
-- 1 row retrieved starting from 1 in 102 ms (execution: 87 ms, fetching: 15 ms)
-- 1 row retrieved starting from 1 in 112 ms (execution: 95 ms, fetching: 17 ms)

-- With Indexing
-- 1 row retrieved starting from 1 in 64 ms (execution: 50 ms, fetching: 14 ms)
-- 1 row retrieved starting from 1 in 63 ms (execution: 51 ms, fetching: 12 ms)
-- 1 row retrieved starting from 1 in 71 ms (execution: 57 ms, fetching: 14 ms)

-- 4
-- No need to specify c.name <> 'Annette Nicole' as co_actors already exclude her
SELECT c.name
FROM co_actors AS c EXCEPT (SELECT DISTINCT n.name FROM non_existent AS n);

-- Without Indexing
-- 2 rows retrieved starting from 1 in 133 ms (execution: 109 ms, fetching: 24 ms)
-- 2 rows retrieved starting from 1 in 121 ms (execution: 107 ms, fetching: 14 ms)
-- 2 rows retrieved starting from 1 in 135 ms (execution: 118 ms, fetching: 17 ms)

-- With Indexing
-- 2 rows retrieved starting from 1 in 72 ms (execution: 55 ms, fetching: 17 ms)
-- 2 rows retrieved starting from 1 in 75 ms (execution: 53 ms, fetching: 22 ms)
-- 2 rows retrieved starting from 1 in 76 ms (execution: 59 ms, fetching: 17 ms)