-- ~* means case-insensitive + REGEX

SELECT m.title
FROM Movie m
WHERE m.mid IN (
    (SELECT t.mid
    FROM Tag t, Tag_Name tn
    WHERE t.tid = tn.tid AND tn.tag ~* '(bad|awful)')
    INTERSECT
    (SELECT t.mid
     FROM Tag t, Tag_Name tn
     WHERE t.tid = tn.tid AND tn.tag ~* '(good|awesome)'));

-- Without Indexing
-- 16 rows retrieved starting from 1 in 84 ms (execution: 67 ms, fetching: 17 ms)
-- 16 rows retrieved starting from 1 in 77 ms (execution: 59 ms, fetching: 18 ms)
-- 16 rows retrieved starting from 1 in 67 ms (execution: 43 ms, fetching: 24 ms)

-- With Indexing
-- 16 rows retrieved starting from 1 in 59 ms (execution: 40 ms, fetching: 19 ms)
-- 16 rows retrieved starting from 1 in 61 ms (execution: 43 ms, fetching: 18 ms)
-- 16 rows retrieved starting from 1 in 57 ms (execution: 39 ms, fetching: 18 ms)