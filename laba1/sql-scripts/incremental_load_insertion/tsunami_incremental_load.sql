-- date
INSERT INTO disasters_dwh.dim_date(Year, Month, Day)
SELECT DISTINCT Year, Mo, Dy
FROM disasters_stage.tsunamievent stage
WHERE Year IS NOT NULL AND
    NOT EXISTS(
    SELECT DateID
    FROM disasters_dwh.dim_date dd
    WHERE dd.Year = stage.Year AND dd.Month <=> stage.Mo AND dd.Day <=> stage.Dy
    );

-- location
INSERT INTO disasters_dwh.dim_location(CountryID, LocationName, Latitude, Longitude)
SELECT DISTINCT CountryID, LocationName, Latitude, Longitude
        FROM disasters_stage.tsunamievent l left join disasters_dwh.dim_country ds on CONCAT('%',LOWER(l.Country),'%') like
              CONCAT('%', ds.CountryName, '%')
WHERE NOT EXISTS(
    SELECT LocationID
    FROM disasters_dwh.dim_location dl
    WHERE dl.CountryID <=> ds.CountryID
      AND CONCAT('%', dl.LocationName, '%') like CONCAT('%', l.LocationName, '%')
      AND dl.Latitude <=> l.Latitude
      AND dl.Longitude <=> l.Longitude
    );

-- tsunami-to-fact-table
INSERT INTO disasters_dwh.fact_event (LocationID, StartDateID, EndDateID, EventTypeID, EventNameID, Deaths, DeathsDescription, Missing, MissingDescription, Injuries, InjuriesDescription, DamageMillionsDollars, DamageMillionsDollarsDescription, HousesDamaged, HousesDamagedDescription, HousesDestroyed, HousesDestroyedDescription, TotalDeaths, TotalDeathsDescription, TotalMissing, TotalMissingDescription, TotalInjuries, TotalInjuriesDescription, TotalDamageMillionsDollars, TotalDamageMillionsDollarsDescription, TotalHousesDamaged, TotalHousesDamagedDescription, TotalHousesDestroyed, TotalHousesDestroyedDescription)
SELECT dl.LocationID, dd.DateID, null , de.EventTypeID, null ,
       Deaths, find_damage_description_id('people', DeathsDescription),
       Missing, find_damage_description_id('people', MissingDescription),
       Injuries, find_damage_description_id('people', InjuriesDescription),
       DamageMillionsDollars, find_damage_description_id('damageMillionDollars', DamageMillionsDollarsDescription),
       HousesDamaged, find_damage_description_id('houses', HousesDamagedDescription),
       HousesDestroyed, find_damage_description_id('houses', HousesDestroyedDescription),
       TotalDeaths, find_damage_description_id('people', TotalDeathsDescription),
       TotalMissing, find_damage_description_id('people', TotalMissingDescription),
       TotalInjuries, find_damage_description_id('people', TotalInjuriesDescription),
       TotalDamage, find_damage_description_id('damageMillionDollars', TotalDamageDescription),
       TotalHousesDamaged, find_damage_description_id('houses', TotalHousesDamagedDescription), TotalHousesDestroyed, find_damage_description_id('houses', TotalHousesDestroyedDescription)
FROM
    disasters_stage.tsunamievent st left join disasters_dwh.dim_location dl
        on dl.Latitude <=> st.Latitude AND dl.Longitude <=> st.Longitude AND CONCAT('%', dl.LocationName, '%') like CONCAT('%', st.LocationName, '%')
        join disasters_dwh.dim_date dd on (st.Year = dd.Year AND st.Mo <=> dd.Month AND st.Dy <=> dd.Day), disasters_dwh.dim_eventtype de
WHERE
    de.EventTypeName = 'tsunami'
