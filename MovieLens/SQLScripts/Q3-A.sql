SELECT DISTINCT m.title
FROM movie AS m, actor AS a
WHERE m.mid = a.mid AND a.name = 'Daniel Craig'
ORDER BY m.title ASC;
