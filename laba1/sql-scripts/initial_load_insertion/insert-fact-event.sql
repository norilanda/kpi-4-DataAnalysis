INSERT INTO disasters_dwh.fact_event (LocationID, StartDateID, EndDateID, EventTypeID, EventNameID, Deaths, DeathsDescription, Missing, MissingDescription, Injuries, InjuriesDescription, DamageMillionsDollars, DamageMillionsDollarsDescription, HousesDamaged, HousesDamagedDescription, HousesDestroyed, HousesDestroyedDescription, TotalDeaths, TotalDeathsDescription, TotalMissing, TotalMissingDescription, TotalInjuries, TotalInjuriesDescription, TotalDamageMillionsDollars, TotalDamageMillionsDollarsDescription, TotalHousesDamaged, TotalHousesDamagedDescription, TotalHousesDestroyed, TotalHousesDestroyedDescription)

SELECT dl.LocationID, dd.DateID, null , de.EventTypeID, den.EventNameID, Deaths, DeathsDescription + 1, Missing, MissingDescription + 1, Injuries, InjuriesDescription + 1, Damage, DamageDescription + 1, null , null , HousesDestroyed, HousesDestroyedDescription + 1, TotalDeaths, TotalDeathsDescription + 1, TotalMissing, TotalMissingDescription + 1, TotalInjuries, TotalInjuriesDescription +1, TotalDamage, TotalDamageDescription + 1, null , null , TotalHousesDestroyed, TotalHousesDestroyedDescription + 1
FROM
    disasters_stage.volcanoevent sv left join disasters_dwh.dim_location dl on (sv.Latitude = dl.Latitude AND sv.Longitude = dl.Longitude AND sv.Location = dl.LocationName) left join disasters_dwh.dim_date dd on (dd.Year = sv.Year AND dd.Month = sv.Mo AND dd.Day = sv.Dy) left join  disasters_dwh.dim_eventname den on sv.VolcanoName = den.EventName, disasters_dwh.dim_eventtype de
WHERE
     de.EventTypeName = 'volcano'
UNION ALL
SELECT dl.LocationID, dd.DateID, null , de.EventTypeID, null , Deaths, DeathsDescription +1, Missing, MissingDescription+1, Injuries, InjuriesDescription+1, DamageMillionsDollars, DamageMillionsDollarsDescription+1, HousesDamaged, HousesDamagedDescription+1, HousesDestroyed, HousesDestroyedDescription+1, TotalDeaths, TotalDeathsDescription+1, TotalMissing, TotalMissingDescription+1, TotalInjuries, TotalInjuriesDescription+1, TotalDamage, TotalDamageDescription+1, TotalHousesDamaged, TotalHousesDamagedDescription+1, TotalHousesDestroyed, TotalHousesDestroyedDescription+1
FROM
    disasters_stage.tsunamievent st left join disasters_dwh.dim_location dl on dl.Latitude = st.Latitude AND dl.Longitude = st.Longitude AND dl.LocationName = st.LocationName left join disasters_dwh.dim_date dd on (st.Year = dd.Year AND st.Mo= dd.Month AND st.Dy =dd.Day), disasters_dwh.dim_eventtype de
WHERE
    de.EventTypeName = 'tsunami'
UNION ALL
SELECT dl.LocationID, dd.DateID, null , de.EventTypeID, null , Deaths, DeathsDescription +1, Missing, MissingDescription+1, Injuries, InjuriesDescription+1, DamageMillionsDollars, DamageDescription+1, HousesDamaged, HousesDamagedDescription+1, HousesDestroyed, HousesDestroyedDescription+1, TotalDeaths, TotalDeathsDescription+1, TotalMissing, TotalMissingDescription+1, TotalInjuries, TotalInjuriesDescription+1, TotalDamage, TotalDamageDescription+1, TotalHousesDamaged, TotalHousesDamageDescription+1, TotalHousesDestroyed, TotalHousesDestroyedDescription+1
FROM
    disasters_stage.earthquakes se left join disasters_dwh.dim_location dl on (dl.Latitude = se.Latitude AND dl.Longitude = se.Longitude AND dl.LocationName = disasters_dwh.delete_country_from_location(se.Location)) left join disasters_dwh.dim_date dd on (dd.Year = se.Year AND dd.Month = se.Mo AND dd.Day = se.Dy), disasters_dwh.dim_eventtype de
WHERE
     de.EventTypeName = 'earthquake';