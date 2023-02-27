INSERT INTO disasters_dwh.dim_date(Year, Month, Day)
SELECT t.Year, MO, Dy
FROM (SELECT DISTINCT Year, MO, DY
FROM disasters_stage.volcanoevent
UNION
SELECT DISTINCT Year, MO, DY
FROM disasters_stage.earthquakes
UNION
SELECT DISTINCT Year, MO, DY
FROM disasters_stage.tsunamievent) as t
ORDER BY t.Year, MO, DY;