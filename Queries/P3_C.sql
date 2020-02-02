SELECT g.genre, COUNT(*)
FROM movie AS m, genre AS g
WHERE m.mid = g.mid
GROUP BY g.genre
HAVING COUNT(*) > 1000
ORDER BY g.genre ASC;