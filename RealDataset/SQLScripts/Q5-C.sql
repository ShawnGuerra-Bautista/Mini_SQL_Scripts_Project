-- Top 10 exporters of energy
SELECT t.source, SUM(t.energy) AS total_energy
FROM transactions AS t
WHERE t.activity = 'Exports' AND t.source <> 'Total' AND t.destination <> 'Total'
GROUP BY t.source
ORDER BY total_energy DESC
LIMIT 10;

-- Bottom 10 importers of energy
SELECT t.destination, SUM(t.energy) AS total_energy
FROM transactions AS t
WHERE t.activity = 'Imports' AND t.destination <> 'Total' AND t.destination <> 'Total'
GROUP BY t.destination
ORDER BY total_energy ASC
LIMIT 10;
-----------------------------------------------------------------------------------------------------------------------
-- Importers with the most unique sources with the number of sources
SELECT t.destination, COUNT(DISTINCT t.source) AS num_sources
FROM transactions AS t
WHERE t.source <> 'Total' AND t.destination <> 'Total' AND t.activity = 'Imports'
GROUP BY t.destination
HAVING COUNT(DISTINCT t.source) >=
       ALL (SELECT COUNT(DISTINCT t.source) AS num_sources
       FROM transactions AS t
       WHERE t.source <> 'Total' AND t.destination <> 'Total' AND t.activity = 'Imports'
       GROUP BY t.destination) ;

-----------------------------------------------------------------------------------------------------------------------
-- Do the biggest exporters import at the highest price?
-- Answer: Yes!
CREATE VIEW total_energy_exports_per_loc AS
    (SELECT t.source AS name, SUM(t.energy) AS total_energy
    FROM transactions AS t
    WHERE t.activity = 'Exports' AND t.source <> 'Total' AND t.destination <> 'Total'
    GROUP BY t.source);

(SELECT t1.destination
FROM transactions AS t1
WHERE t1.price >=
      (SELECT MAX(t2.price)
      FROM transactions AS t2
      WHERE t2.activity = 'Imports' AND t2.destination <> 'Total' AND t2.source <> 'Total')
  AND t1.activity = 'Imports' AND t1.destination <> 'Total' AND t1.source <> 'Total')
INTERSECT
(SELECT t1.name
    FROM total_energy_exports_per_loc AS t1
    WHERE t1.total_energy >= (SELECT MAX(t2.total_energy) FROM total_energy_exports_per_loc AS t2));

-- Do the biggest importers export at the highest price?
-- Answer: Yes!
CREATE VIEW total_energy_imports_per_loc AS
    (SELECT t.destination AS name, SUM(t.energy) AS total_energy
    FROM transactions AS t
    WHERE t.activity = 'Imports' AND t.source <> 'Total' AND t.destination <> 'Total'
    GROUP BY t.destination);

(SELECT t1.source
FROM transactions AS t1
WHERE t1.price >=
      (SELECT MAX(t2.price)
      FROM transactions AS t2
      WHERE t2.activity = 'Exports' AND t2.destination <> 'Total' AND t2.source <> 'Total')
  AND t1.activity = 'Exports' AND t1.destination <> 'Total' AND t1.source <> 'Total')
INTERSECT
(SELECT t1.name
    FROM total_energy_imports_per_loc AS t1
    WHERE t1.total_energy >= (SELECT MAX(t2.total_energy) FROM total_energy_imports_per_loc AS t2));

-----------------------------------------------------------------------------------------------------------------------
-- Report the highest and lowest exporters for each year
CREATE VIEW total_energy_exporters_by_year AS
    (SELECT t.source, EXTRACT(year FROM t.date) AS export_year, SUM(t.energy) AS total_energy
    FROM transactions AS t
    WHERE t.activity = 'Exports' AND t.source <> 'Total' AND t.destination <> 'Total'
    GROUP BY t.source, export_year);

CREATE VIEW highest_energy_by_year AS
    (SELECT export_year, MAX(t.total_energy) AS total_energy
    FROM total_energy_exporters_by_year AS t
    GROUP BY export_year);

CREATE VIEW lowest_energy_by_year AS
    (SELECT export_year, MIN(t.total_energy) AS total_energy
    FROM total_energy_exporters_by_year AS t
    GROUP BY export_year);

SELECT t1.*
FROM (SELECT t.source, t.export_year, t.total_energy
    FROM total_energy_exporters_by_year AS t, lowest_energy_by_year AS e
    WHERE t.total_energy <= e.total_energy AND t.export_year = e.export_year) AS t1
UNION
SELECT t2.*
FROM (SELECT t.source, t.export_year, t.total_energy
    FROM total_energy_exporters_by_year AS t, highest_energy_by_year AS e
    WHERE t.total_energy >= e.total_energy AND t.export_year = e.export_year) AS t2
ORDER BY export_year ASC, total_energy DESC, source ASC;

-----------------------------------------------------------------------------------------------------------------------
-- Find Quebec’s most frequent customer when exporting and importing
((SELECT t.activity, t.destination AS location, COUNT(*) AS months_interact_num
FROM transactions AS t
WHERE t.source <> 'Total' AND t.destination <> 'Total' AND t.source = 'Québec' AND t.activity = 'Exports'
GROUP BY t.source, t.destination, t.activity
HAVING COUNT(*) >=
        ALL (SELECT COUNT(*) AS interact_num
        FROM transactions AS t
        WHERE t.source <> 'Total' AND t.destination <> 'Total' AND t.source = 'Québec' AND t.activity = 'Exports'
        GROUP BY t.source, t.destination, t.activity))
UNION
(SELECT t.activity, t.source AS location, COUNT(*) AS interact_num
FROM transactions AS t
WHERE t.source <> 'Total' AND t.destination <> 'Total' AND t.destination = 'Québec' AND t.activity = 'Imports'
GROUP BY t.source, t.destination, t.activity
HAVING COUNT(*) >=
        ALL (SELECT COUNT(*) AS interact_num
        FROM transactions AS t
        WHERE t.source <> 'Total' AND t.destination <> 'Total' AND t.destination = 'Québec' AND t.activity = 'Imports'
        GROUP BY t.source, t.destination, t.activity)));

-----------------------------------------------------------------------------------------------------------------------
-- Find the foreign locations that have been trading with Canada for the longest time
CREATE VIEW location_max_min_year AS
    ((SELECT t.source AS location, MAX(EXTRACT(year FROM t.date)) AS max_year, MIN(EXTRACT(year FROM t.date)) AS min_year
    FROM transactions AS t
    WHERE t.destination <> 'Total' AND t.source <> 'Total' AND t.activity = 'Imports'
    GROUP BY t.source)
    UNION
    (SELECT t.destination AS location, MAX(EXTRACT(year FROM t.date)) AS max_year,
            MIN(EXTRACT(year FROM t.date)) AS min_year
    FROM transactions AS t
    WHERE t.destination <> 'Total' AND t.source <> 'Total' AND t.activity = 'Exports'
    GROUP BY t.destination));

SELECT location, (MAX(loc1.max_year) - MIN(loc1.min_year)) AS year_interval
FROM location_max_min_year AS loc1
GROUP BY location
HAVING (MAX(loc1.max_year) - MIN(loc1.min_year)) >=
    ALL (SELECT (MAX(loc2.max_year) - MIN(loc2.min_year)) AS year_interval
    FROM location_max_min_year AS loc2
    GROUP BY location)
ORDER BY year_interval DESC;