use disasters_dwh;

drop table if exists Fact_Event;

drop table if exists Dim_Location;

drop table if exists Dim_Country;

drop table if exists Dim_SubContinent;

drop table if exists Dim_Continent;

drop table if exists Dim_DamageDescription;

drop table if exists Dim_Date;

drop table if exists Dim_EventType;

drop table if exists Dim_EventName;

/*==============================================================*/
/* Table: Dim_Continent                                         */
/*==============================================================*/
create table Dim_Continent
(
   ContinentID          int                            AUTO_INCREMENT,
   ContinentName        varchar(17)                    not null UNIQUE,
   constraint PK_DIM_CONTINENT primary key (ContinentID)
);

/*==============================================================*/
/* Table: Dim_SubContinent                                      */
/*==============================================================*/
create table Dim_SubContinent
(
   SubContinentID       int                            AUTO_INCREMENT,
   ContinentID          int                            not null,
   SubContinentName     varchar(40)                    not null UNIQUE,
   constraint PK_DIM_SUBCONTINENT primary key (SubContinentID)
);

/*==============================================================*/
/* Table: Dim_Country                                           */
/*==============================================================*/
create table Dim_Country
(
   CountryID            int                            AUTO_INCREMENT,
   SubContinentID       int                            not null,
   CountryName          varchar(70)                    not null,
   Load_Date            date                           not null DEFAULT '1000-01-01',
   End_Load_Date        date                           not null DEFAULT '9999-12-31',
   Old_reference_ID     int                            ,
   constraint PK_DIM_COUNTRY primary key (CountryID)
);

/*==============================================================*/
/* Table: Dim_Location                                          */
/*==============================================================*/
create table Dim_Location
(
   LocationID           int                            AUTO_INCREMENT,
   CountryID            int                            ,
   LocationName         varchar(100)                   ,
   Latitude            decimal(10,3)                   ,
   Longitude           decimal(10,3)                   ,
   constraint PK_DIM_LOCATION primary key (LocationID)
);

/*==============================================================*/
/* Table: Dim_DamageDescription                                 */
/*==============================================================*/
create table Dim_DamageDescription
(
   DamageDescriptionID  tinyint                        AUTO_INCREMENT,
   DescriptionStatus    varchar(15)                    not null,
   LowerBound           int                            ,
   UpperBound           int                            ,
   DamageType           enum('people', 'houses', 'damageMillionDollars') not null,
   constraint PK_DIM_DAMAGEDESCRIPTION primary key (DamageDescriptionID)
);

/*==============================================================*/
/* Table: Dim_Date                                              */
/*==============================================================*/
create table Dim_Date
(
   DateID               int                            AUTO_INCREMENT,
   Year                 int                            not null,
   Month                tinyint                        ,
   Day                  tinyint                        ,
   constraint PK_DIM_DATE primary key (DateID)
);

/*==============================================================*/
/* Table: Dim_EventType                                         */
/*==============================================================*/
create table Dim_EventType
(
   EventTypeID          int                            AUTO_INCREMENT,
   EventTypeName        varchar(18)                    not null,
   constraint PK_DIM_EVENTTYPE primary key (EventTypeID)
);

/*==============================================================*/
/* Table: EventName                                             */
/*==============================================================*/
create table Dim_EventName
(
   EventNameID          int                            AUTO_INCREMENT,
   EventName            varchar(30)                    not null,
   constraint PK_EVENTNAME primary key (EventNameID)
);

/*==============================================================*/
/* Table: Fact_Event                                            */
/*==============================================================*/
create table Fact_Event
(
   EventID              int                            AUTO_INCREMENT,
   LocationID           int                            not null,
   StartDateID          int                            not null,
   EndDateID            int                            ,
   EventTypeID          int                            not null,
   Deaths               int                            ,
   DeathsDescription    tinyint                        ,
   Missing              int                            ,
   EventNameID          int                            ,
   MissingDescription   tinyint                        ,
   Injuries             int                            ,
   InjuriesDescription  tinyint                        ,
   DamageMillionsDollars int                           ,
   DamageMillionsDollarsDescription tinyint            ,
   HousesDamaged        int                            ,
   HousesDamagedDescription tinyint                    ,
   HousesDestroyed      int                            ,
   HousesDestroyedDescription tinyint                  ,
   TotalDeaths          int                            ,
   TotalDeathsDescription tinyint                      ,
   TotalMissing         int                            ,
   TotalMissingDescription tinyint                     ,
   TotalInjuries        int                            ,
   TotalInjuriesDescription tinyint                    ,
   TotalDamageMillionsDollars int                      ,
   TotalDamageMillionsDollarsDescription tinyint       ,
   TotalHousesDamaged   int                            ,
   TotalHousesDamagedDescription tinyint               ,
   TotalHousesDestroyed int                            ,
   TotalHousesDestroyedDescription tinyint             ,
   constraint PK_FACT_EVENT primary key (EventID),
   constraint FK_TotalHousesDestroyedDescription foreign key (TotalHousesDestroyedDescription) references Dim_DamageDescription (DamageDescriptionID),
   constraint FK_TotalHousesDamagedDescription foreign key (TotalHousesDamagedDescription) references Dim_DamageDescription (DamageDescriptionID),
   constraint FK_TotalDamageMillionsDollarsDescription foreign key (TotalDamageMillionsDollarsDescription) references Dim_DamageDescription (DamageDescriptionID),
   constraint FK_TotalInjuriesDescription foreign key (TotalInjuriesDescription) references Dim_DamageDescription (DamageDescriptionID),
   constraint FK_TotalMissingDescription foreign key (TotalMissingDescription) references  Dim_DamageDescription (DamageDescriptionID),
   constraint FK_TotalDeathsDescription foreign key (TotalDeathsDescription) references Dim_DamageDescription (DamageDescriptionID),
   constraint FK_HousesDestroyedDescription foreign key (HousesDestroyedDescription) references Dim_DamageDescription (DamageDescriptionID),
   constraint FK_HousesDamagedDescription foreign key (HousesDamagedDescription) references Dim_DamageDescription (DamageDescriptionID),
   constraint FK_DamageMillionsDollarsDescription foreign key (DamageMillionsDollarsDescription) references Dim_DamageDescription (DamageDescriptionID),
   constraint FK_InjuriesDescription foreign key (InjuriesDescription) references Dim_DamageDescription (DamageDescriptionID),
   constraint FK_MissingDescription foreign key (MissingDescription) references Dim_DamageDescription (DamageDescriptionID),
   constraint FK_DeathsDescription foreign key (DeathsDescription) references Dim_DamageDescription (DamageDescriptionID)
);

alter table Dim_Country
   add constraint FK_DIM_COUN_REFERENCE_DIM_COUN foreign key (Old_reference_ID)
      references Dim_Country (CountryID);

alter table Dim_Country
   add constraint FK_DIM_COUN_REFERENCE_DIM_SUBC foreign key (SubContinentID)
      references Dim_SubContinent (SubContinentID);

alter table Dim_Location
   add constraint FK_DIM_LOCA_REFERENCE_DIM_COUN foreign key (CountryID)
      references Dim_Country (CountryID);

alter table Dim_SubContinent
   add constraint FK_DIM_SUBC_REFERENCE_DIM_CONT foreign key (ContinentID)
      references Dim_Continent (ContinentID);

alter table Fact_Event
   add constraint FK_FACT_EVE_REFERENCE_DIM_LOCA foreign key (LocationID)
      references Dim_Location (LocationID);

alter table Fact_Event
   add constraint FK_FACT_EVE_REFERENCE_DIM_DATE foreign key (StartDateID)
      references Dim_Date (DateID);

alter table Fact_Event
   add constraint FK_FACT_EVE_REFERENCE_DIM_EVEN foreign key (EventTypeID)
      references Dim_EventType (EventTypeID);

alter table Fact_Event
   add constraint FK_FACT_EVE_REFERENCE_EVENTNAM foreign key (EventNameID)
      references Dim_EventName (EventNameID)
