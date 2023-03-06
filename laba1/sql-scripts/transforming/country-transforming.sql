UPDATE disasters_stage.country
SET CountryName = 'Palestine'
WHERE CountryName LIKE 'Palestine,%';

UPDATE disasters_stage.country
SET CountryName = 'Democratic Republic of the Congo'
WHERE CountryName LIKE 'Congo (D%';

UPDATE disasters_stage.tsunamievent
SET Country = disasters_dwh.transform_country_name(Country);

UPDATE disasters_stage.volcanoevent
SET Country = disasters_dwh.transform_country_name(Country);

UPDATE disasters_stage.earthquakes
SET Country = disasters_dwh.transform_country_name(Country);
