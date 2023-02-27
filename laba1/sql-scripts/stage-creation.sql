use disasters_stage;

drop table if exists Country;

drop table if exists Earthquakes;

drop table if exists TsunamiEvent;

drop table if exists VolcanoEvent;

drop table if exists PeopleEffectDescription;

drop table if exists HouseEffectDescription;

drop table if exists DamageEffectDescription;

/*==============================================================*/
/* Table: Country                                               */
/*==============================================================*/
create table Country
(
   CountryID            int                            not null AUTO_INCREMENT,
   CountryName                 varchar(70)                    null,
   alpha2               varchar(3)                     null,
   alpha3               varchar(4)                     null,
   CountryCode          int                            null,
   iso_3166_2           varchar(17)                    null,
   Region               varchar(17)                    null,
   SubRegion            varchar(40)                    null,
   IntermediateRegion   varchar(40)                    null,
   RegionCode           int                            null,
   SubRegionCode        int                            null,
   IntermidiateRegionCode int                            null,
   constraint PK_COUNTRY primary key (CountryID)
);

/*==============================================================*/
/* Table: Earthquakes                                           */
/*==============================================================*/
create table Earthquakes
(
   EarthquakeEventID    int                            not null AUTO_INCREMENT,
   FlagTsunami          varchar(4)                     null,
   Year                 int                            null,
   Mo                   int                            null,
   Dy                   int                            null,
   Hr                   int                            null,
   Mn                   int                            null,
   Sec                  varchar(6)                     null,
   FocalDepth           varchar(6)                     null,
   EQ_Primary           varchar(6)                     null,
   EQ_MAG_MV            varchar(6)                     null,
   EQ_MAG_MS            varchar(6)                     null,
   EQ_MAG_MB            varchar(6)                     null,
   EQ_MAG_ML            varchar(6)                     null,
   EQ_MAG_MFA           varchar(6)                     null,
   EQ_MAG_UNK           varchar(6)                     null,
   Intensity            varchar(6)                     null,
   Country              varchar(70)                    null,
   State                varchar(15)                    null,
   Location             varchar(150)                   null,
   Latitude             varchar(10)                     null,
   Longitude            varchar(10)                     null,
   RegionCode           varchar(6)                     null,
   Deaths               int                            null,
   DeathsDescription    tinyint                        null,
   Missing              int                            null,
   MissingDescription   tinyint                        null,
   Injuries             int                            null,
   InjuriesDescription  tinyint                        null,
   DamageMillionsDollars float                          null,
   DamageDescription    tinyint                        null,
   HousesDestroyed      float                          null,
   HousesDestroyedDescription tinyint                        null,
   HousesDamaged        float                          null,
   HousesDamagedDescription tinyint                        null,
   TotalDeaths          int                            null,
   TotalDeathsDescription tinyint                        null,
   TotalMissing         int                            null,
   TotalMissingDescription tinyint                        null,
   TotalInjuries        int                            null,
   TotalInjuriesDescription tinyint                        null,
   TotalDamage          float                          null,
   TotalDamageDescription tinyint                        null,
   TotalHousesDestroyed int                            null,
   TotalHousesDestroyedDescription tinyint                        null,
   TotalHousesDamaged   int                            null,
   TotalHousesDamageDescription tinyint                        null,
   constraint PK_EARTHQUAKES primary key (EarthquakeEventID)
);

/*==============================================================*/
/* Table: TsunamiEvent                                          */
/*==============================================================*/
create table TsunamiEvent
(
   TsunamiEventID       int                            not null AUTO_INCREMENT,
   Year                 int                            null,
   Mo                   int                            null,
   Dy                   int                            null,
   Hr                   int                            null,
   Mn                   int                            null,
   Sec                  int                            null,
   TsunamiEventValidity tinyint                        null,
   TsunamiCauseCode     tinyint                        null,
   EarthquakeMagnitude  float                          null,
   Deposits             tinyint                        null,
   Country              varchar(70)                    null,
   LocationName         varchar(150)                   null,
   Latitude             float                          null,
   Longitude           float                          null,
   MaximumWaterHeightInMeters float                          null,
   NumberOfRunups       int                            null,
   TsunamiMagnitudeAbe  float                          null,
   TsunamiMagnitudeIida float                          null,
   TsunamiIntensity     float                          null,
   Deaths               int                            null,
   DeathsDescription    int                            null,
   Missing              int                            null,
   MissingDescription   int                            null,
   Injuries             int                            null,
   InjuriesDescription  int                            null,
   DamageMillionsDollars int                            null,
   DamageMillionsDollarsDescription int                            null,
   HousesDestroyed      int                            null,
   HousesDestroyedDescription int                            null,
   HousesDamaged        int                            null,
   HousesDamagedDescription int                            null,
   TotalDeaths          int                            null,
   TotalDeathsDescription int                            null,
   TotalMissing         int                            null,
   TotalMissingDescription int                            null,
   TotalInjuries        int                            null,
   TotalInjuriesDescription int                            null,
   TotalDamage          int                            null,
   TotalDamageDescription int                            null,
   TotalHousesDestroyed int                            null,
   TotalHousesDestroyedDescription int                            null,
   TotalHousesDamaged   int                            null,
   TotalHousesDamagedDescription int                            null,
   constraint PK_TSUNAMIEVENT primary key (TsunamiEventID)
);

/*==============================================================*/
/* Table: VolcanoEvent                                          */
/*==============================================================*/
create table VolcanoEvent
(
   VolcanoEventID       integer                        not null AUTO_INCREMENT,
   Year                 int                            null,
   Mo                   int                            null,
   Dy                   int                            null,
   TsunamiEvent         int                            null,
   EarthquakeEvent       int                            null,
   VolcanoName          varchar(60)                    null,
   Location             varchar(70)                    null,
   Country              varchar(70)                    null,
   Latitude             float                          null,
   Longitude            float                          null,
   Elevation            int                            null,
   Type                 varchar(40)                    null,
   VEI                  tinyint                        null,
   Agent                varchar(15)                    null,
   Deaths               int                            null,
   DeathsDescription     tinyint                        null,
   Missing              int                            null,
   MissingDescription   int                            null,
   Injuries             int                            null,
   InjuriesDescription  int                            null,
   Damage               float                          null,
   DamageDescription    tinyint                        null,
   HousesDestroyed      int                            null,
   HousesDestroyedDescription tinyint                        null,
   TotalDeaths          int                            null,
   TotalDeathsDescription tinyint                        null,
   TotalMissing         int                            null,
   TotalMissingDescription tinyint                        null,
   TotalInjuries        int                            null,
   TotalInjuriesDescription tinyint                        null,
   TotalDamage          int                            null,
   TotalDamageDescription tinyint                        null,
   TotalHousesDestroyed  int                            null,
   TotalHousesDestroyedDescription tinyint                        null,
   constraint PK_VOLCANOEVENT primary key (VolcanoEventID)
);

/*==============================================================*/
/* Table: PeopleEffectDescription                               */
/*==============================================================*/
create table PeopleEffectDescription
(
   id                   int                            not null AUTO_INCREMENT,
   description          varchar(35)                    null,
   constraint PK_PEOPLEEFFECTDESCRIPTION primary key (id)
);

/*==============================================================*/
/* Table: HouseEffectDescription                                */
/*==============================================================*/
create table HouseEffectDescription
(
   id                   int                            not null AUTO_INCREMENT,
   description          varchar(35)                    null,
   constraint PK_HOUSEEFFECTDESCRIPTION primary key (id)
);

/*==============================================================*/
/* Table: DamageEffectDescription                               */
/*==============================================================*/
create table DamageEffectDescription
(
   id                   int                            not null AUTO_INCREMENT,
   description          varchar(35)                    null,
   constraint PK_DAMAGEEFFECTDESCRIPTION primary key (id)
);

