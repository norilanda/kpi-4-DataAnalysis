INSERT INTO disasters_dwh.dim_continent (ContinentName)
SELECT DISTINCT Region
FROM disasters_stage.country
WHERE Region IS NOT NULL;

INSERT INTO disasters_dwh.dim_subcontinent (ContinentID, SubContinentName)
SELECT ContinentID, c.SubRegion
FROM disasters_dwh.dim_continent dc, (
    SELECT DISTINCT Region, SubRegion
    FROM disasters_stage.country) AS c
WHERE dc.ContinentName = c.Region;

INSERT INTO disasters_dwh.dim_country(SubContinentID, CountryName)
SELECT SubContinentID, s.CountryName
FROM disasters_dwh.dim_subcontinent ds, (
    SELECT DISTINCT SubRegion, CountryName
    FROM disasters_stage.country) AS s
WHERE ds.SubContinentName = s.SubRegion;

INSERT INTO disasters_dwh.dim_location(CountryID, LocationName, Latitude, Longitude)
SELECT CountryID, l.Location, l.Latitude, l.Longitude
FROM disasters_dwh.dim_country ds, (
    SELECT DISTINCT LOWER(Country) c, Location, Latitude, Longitude
    FROM disasters_stage.volcanoevent
    UNION
    SELECT DISTINCT LOWER(Country) c, LocationName, Latitude, Longitude
    FROM disasters_stage.tsunamievent
    UNION
    SELECT DISTINCT LOWER(Country) c, disasters_dwh.delete_country_from_location(Location),
                    disasters_dwh.if_is_not_alphanumeric_set_null(Latitude),
                    disasters_dwh.if_is_not_alphanumeric_set_null(Longitude)
    FROM disasters_stage.earthquakes
) AS l
WHERE Lower(ds.CountryName) = l.c;
