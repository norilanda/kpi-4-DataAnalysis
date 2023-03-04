use disasters_dwh;
INSERT INTO disasters_dwh.fact_event (LocationID, StartDateID, EndDateID, EventTypeID, EventNameID, Deaths, DeathsDescription, Missing, MissingDescription, Injuries, InjuriesDescription, DamageMillionsDollars, DamageMillionsDollarsDescription, HousesDamaged, HousesDamagedDescription, HousesDestroyed, HousesDestroyedDescription, TotalDeaths, TotalDeathsDescription, TotalMissing, TotalMissingDescription, TotalInjuries, TotalInjuriesDescription, TotalDamageMillionsDollars, TotalDamageMillionsDollarsDescription, TotalHousesDamaged, TotalHousesDamagedDescription, TotalHousesDestroyed, TotalHousesDestroyedDescription)

SELECT dl.LocationID, dd.DateID, null , de.EventTypeID, den.EventNameID,
       Deaths, find_damage_description_id('people', DeathsDescription) ,
       Missing, find_damage_description_id('people', MissingDescription),
       Injuries, find_damage_description_id('people', InjuriesDescription),
       Damage, find_damage_description_id('damageMillionDollars', DamageDescription) ,
       null , null ,
       HousesDestroyed, find_damage_description_id('houses', HousesDestroyedDescription),
       TotalDeaths, find_damage_description_id('people', TotalDeathsDescription),
       TotalMissing, find_damage_description_id('people', TotalMissingDescription),
       TotalInjuries, find_damage_description_id('people', TotalInjuriesDescription),
       TotalDamage, find_damage_description_id('damageMillionDollars', TotalDamageDescription),
       null , null ,
       TotalHousesDestroyed, find_damage_description_id('houses', TotalHousesDestroyedDescription)
FROM
    disasters_stage.volcanoevent sv left join disasters_dwh.dim_location dl on (sv.Latitude <=> dl.Latitude AND sv.Longitude <=> dl.Longitude AND sv.Location <=> dl.LocationName) left join disasters_dwh.dim_date dd on (dd.Year = sv.Year AND dd.Month <=> sv.Mo AND dd.Day <=> sv.Dy) join  disasters_dwh.dim_eventname den on sv.VolcanoName = den.EventName, disasters_dwh.dim_eventtype de
WHERE
     de.EventTypeName = 'volcano'
UNION
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
    disasters_stage.tsunamievent st left join disasters_dwh.dim_location dl on dl.Latitude <=> st.Latitude AND dl.Longitude <=> st.Longitude AND dl.LocationName <=> st.LocationName join disasters_dwh.dim_date dd on (st.Year = dd.Year AND st.Mo <=> dd.Month AND st.Dy <=> dd.Day), disasters_dwh.dim_eventtype de
WHERE
    de.EventTypeName = 'tsunami'
UNION
SELECT dl.LocationID, dd.DateID, null , de.EventTypeID, null ,
       Deaths, find_damage_description_id('people', DeathsDescription),
       Missing, find_damage_description_id('people', MissingDescription),
       Injuries, find_damage_description_id('people', InjuriesDescription),
       DamageMillionsDollars, find_damage_description_id('damageMillionDollars', DamageDescription),
       HousesDamaged, find_damage_description_id('houses', HousesDamagedDescription),
       HousesDestroyed, find_damage_description_id('houses', HousesDestroyedDescription),
       TotalDeaths, find_damage_description_id('people', TotalDeathsDescription),
       TotalMissing, find_damage_description_id('people', TotalMissingDescription),
       TotalInjuries, find_damage_description_id('people', TotalInjuriesDescription),
       TotalDamage, find_damage_description_id('damageMillionDollars', TotalDamageDescription),
       TotalHousesDamaged, find_damage_description_id('houses', TotalHousesDamageDescription),
       TotalHousesDestroyed, find_damage_description_id('houses', TotalHousesDestroyedDescription)
FROM
        disasters_stage.earthquakes se left join disasters_dwh.dim_location dl on
        ((dl.Latitude <=> se.Latitude OR dl.Latitude IS NULL AND NOT EXISTS(select se.Latitude where se.Latitude REGEXP '^[A-Za-z0-9]+$'))
             AND
         (dl.Longitude <=> se.Longitude OR dl.Longitude IS NULL AND NOT EXISTS(select se.Longitude where se.Longitude REGEXP '^[A-Za-z0-9]+$')) AND dl.LocationName <=> disasters_dwh.delete_country_from_location(se.Location))
     join disasters_dwh.dim_date dd on (dd.Year = se.Year AND dd.Month <=> se.Mo AND dd.Day <=> se.Dy), disasters_dwh.dim_eventtype de
WHERE
     de.EventTypeName = 'earthquake';