SELECT DISTINCT a.name
FROM movie AS m, actor AS a
WHERE m.mid = a.mid AND m.title = 'The Dark Knight'
ORDER BY a.name ASC;
