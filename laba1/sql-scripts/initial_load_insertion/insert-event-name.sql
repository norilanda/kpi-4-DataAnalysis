INSERT INTO disasters_dwh.dim_eventname (EventName)
SELECT DISTINCT VolcanoName
FROM disasters_stage.volcanoevent
WHERE VolcanoName IS NOT NULL
ORDER BY VolcanoName;