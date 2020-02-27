SELECT g.genre, COUNT(*) AS count
FROM movie AS m, genre AS g
WHERE m.mid = g.mid
GROUP BY g.genre
HAVING COUNT(*) > 1000
ORDER BY count ASC;
