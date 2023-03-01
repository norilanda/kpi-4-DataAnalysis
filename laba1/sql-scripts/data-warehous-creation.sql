use disasters_dwh;

drop table if exists Fact_Event;

drop table if exists Dim_Location;

drop table if exists Dim_Country;

drop table if exists Dim_SubContinent;

drop table if exists Dim_Continent;

drop table if exists Dim_DamageDescription;

drop table if exists Dim_Date;

drop table if exists Dim_EventType;

drop table if exists Dim_FlagOtherEvent;

drop table if exists Dim_EventName;

/*==============================================================*/
/* Table: Dim_Continent                                         */
/*==============================================================*/
create table Dim_Continent
(
   ContinentID          int                            not null AUTO_INCREMENT,
   ContinentName        varchar(17)                    null,
   constraint PK_DIM_CONTINENT primary key (ContinentID)
);

/*==============================================================*/
/* Table: Dim_Country                                           */
/*==============================================================*/
create table Dim_Country
(
   CountryID            int                            not null AUTO_INCREMENT,
   SubContinentID       int                            null,
   CountryName          varchar(70)                    null,
   constraint PK_DIM_COUNTRY primary key (CountryID)
);

/*==============================================================*/
/* Table: Dim_DamageDescription                                 */
/*==============================================================*/
create table Dim_DamageDescription
(
   DamageDescriptionID  tinyint                        not null AUTO_INCREMENT,
   DescriptionStatus    varchar(15)                    null,
   LowerBound           int                            null,
   UpperBound           int                            null,
   constraint PK_DIM_DAMAGEDESCRIPTION primary key (DamageDescriptionID)
);

/*==============================================================*/
/* Table: Dim_Date                                              */
/*==============================================================*/
create table Dim_Date
(
   DateID               int                            not null AUTO_INCREMENT,
   Year                 int                            null,
   Month                tinyint                        null,
   Day                  tinyint                        null,
   constraint PK_DIM_DATE primary key (DateID)
);

/*==============================================================*/
/* Table: Dim_EventType                                         */
/*==============================================================*/
create table Dim_EventType
(
   EventTypeID          int                            not null AUTO_INCREMENT,
   EventTypeName        varchar(18)                    null,
   constraint PK_DIM_EVENTTYPE primary key (EventTypeID)
);

/*==============================================================*/
/* Table: Dim_FlagOtherEvent                                    */
/*==============================================================*/
create table Dim_FlagOtherEvent
(
   FlagOtherEventID     int                            not null AUTO_INCREMENT,
   description          varchar(30)                    null,
   constraint PK_DIM_FLAGOTHEREVENT primary key (FlagOtherEventID)
);

/*==============================================================*/
/* Table: Dim_Location                                          */
/*==============================================================*/
create table Dim_Location
(
   LocationID           int                            not null AUTO_INCREMENT,
   CountryID            int                            null,
   LocationName                 varchar(100)                   null,
   Latitude            float                          null,
   Longitude           float                          null,
   constraint PK_DIM_LOCATION primary key (LocationID)
);

/*==============================================================*/
/* Table: Dim_SubContinent                                      */
/*==============================================================*/
create table Dim_SubContinent
(
   SubContinentID       int                            not null AUTO_INCREMENT,
   ContinentID          int                            null,
   SubContinentName     varchar(40)                    null,
   constraint PK_DIM_SUBCONTINENT primary key (SubContinentID)
);


/*==============================================================*/
/* Table: EventName                                             */
/*==============================================================*/
create table Dim_EventName
(
   EventNameID          int                            not null AUTO_INCREMENT,
   EventName            varchar(30)                    null,
   constraint PK_EVENTNAME primary key clustered (EventNameID)
);


/*==============================================================*/
/* Table: Fact_Event                                            */
/*==============================================================*/
create table Fact_Event
(
   EventID              int                            not null AUTO_INCREMENT,
   LocationID           int                            null,
   StartDateID          int                            null,
   EndDateID            int                            null,
   EventTypeID          int                            null,
   EventNameID          int                            null,
   FlagOtherEventID     int                            null,
   Deaths               int                            null,
   DeathsDescription    tinyint                        null,
   Missing              int                            null,
   MissingDescription   tinyint                        null,
   Injuries             int                            null,
   InjuriesDescription  tinyint                        null,
   DamageMillionsDollars int                            null,
   DamageMillionsDollarsDescription tinyint                        null,
   HousesDamaged        int                            null,
   HousesDamagedDescription tinyint                        null,
   HousesDestroyed      int                            null,
   HousesDestroyedDescription tinyint                        null,
   TotalDeaths          int                            null,
   TotalDeathsDescription tinyint                        null,
   TotalMissing         int                            null,
   TotalMissingDescription tinyint                        null,
   TotalInjuries        int                            null,
   TotalInjuriesDescription tinyint                        null,
   TotalDamageMillionsDollars int                            null,
   TotalDamageMillionsDollarsDescription tinyint                        null,
   TotalHousesDamaged   int                            null,
   TotalHousesDamagedDescription tinyint                        null,
   TotalHousesDestroyed int                            null,
   TotalHousesDestroyedDescription tinyint                        null,
   constraint PK_FACT_EVENT primary key (EventID),
   constraint FK_TotalHousesDestroyedDescription foreign key (TotalHousesDestroyedDescription) references Dim_DamageDescription (DamageDescriptionID),
   constraint FK_TotalHousesDamagedDescription foreign key (TotalHousesDamagedDescription) references Dim_DamageDescription (DamageDescriptionID),
   constraint FK_TotalDamageMillionsDollarsDescription foreign key (TotalDamageMillionsDollarsDescription) references Dim_DamageDescription (DamageDescriptionID),
   constraint FK_TotalInjuriesDescription foreign key (TotalInjuriesDescription) references Dim_DamageDescription (DamageDescriptionID),
   constraint FK_TotalMissingDescription foreign key (TotalMissingDescription) references Dim_DamageDescription (DamageDescriptionID),
   constraint FK_HousesDestroyedDescription foreign key (HousesDestroyedDescription) references Dim_DamageDescription (DamageDescriptionID),
   constraint FK_HousesDamagedDescription foreign key (HousesDamagedDescription) references Dim_DamageDescription (DamageDescriptionID),
   constraint FK_DamageMillionsDollarsDescription foreign key (DamageMillionsDollarsDescription) references Dim_DamageDescription (DamageDescriptionID),
   constraint FK_InjuriesDescription foreign key (InjuriesDescription) references Dim_DamageDescription (DamageDescriptionID),
   constraint FK_MissingDescription foreign key (MissingDescription) references Dim_DamageDescription (DamageDescriptionID),
   constraint FK_DeathsDescription foreign key (DeathsDescription) references Dim_DamageDescription (DamageDescriptionID)
);

alter table Dim_Country
   add constraint FK_DIM_COUN_REFERENCE_DIM_SUBC foreign key (SubContinentID)
      references Dim_SubContinent (SubContinentID)
      on update restrict
      on delete restrict;

alter table Dim_Location
   add constraint FK_DIM_LOCA_REFERENCE_DIM_COUN foreign key (CountryID)
      references Dim_Country (CountryID)
      on update restrict
      on delete restrict;

alter table Dim_SubContinent
   add constraint FK_DIM_SUBC_REFERENCE_DIM_CONT foreign key (ContinentID)
      references Dim_Continent (ContinentID)
      on update restrict
      on delete restrict;

alter table Fact_Event
   add constraint FK_FACT_EVE_REFERENCE_DIM_LOCA foreign key (LocationID)
      references Dim_Location (LocationID)
      on update restrict
      on delete restrict;

alter table Fact_Event
   add constraint FK_FACT_EVE_REFERENCE_DIM_DATE foreign key (StartDateID)
      references Dim_Date (DateID)
      on update restrict
      on delete restrict;

alter table Fact_Event
   add constraint FK_FACT_EVE_REFERENCE_DIM_EVEN foreign key (EventTypeID)
      references Dim_EventType (EventTypeID)
      on update restrict
      on delete restrict;

alter table Fact_Event
   add constraint FK_FACT_EVE_REFERENCE_DIM_DAMA foreign key (TotalDeathsDescription)
      references Dim_DamageDescription (DamageDescriptionID)
      on update restrict
      on delete restrict;

alter table Fact_Event
   add constraint FK_FACT_EVE_REFERENCE_DIM_FLAG foreign key (FlagOtherEventID)
      references Dim_FlagOtherEvent (FlagOtherEventID)
      on update restrict
      on delete restrict;

alter table Fact_Event
   add constraint FK_FACT_EVE_REFERENCE_EVENTNAM foreign key (EventNameID)
      references Dim_EventName (EventNameID)
      on update restrict
      on delete restrict;

