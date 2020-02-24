SELECT DISTINCT a.name, (max(m.year) - min(m.year)) AS year_interval
FROM actor AS a, movie AS m
WHERE a.mid = m.mid
GROUP BY a.name
ORDER BY year_interval DESC;
