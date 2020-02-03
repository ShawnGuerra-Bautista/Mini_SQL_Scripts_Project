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