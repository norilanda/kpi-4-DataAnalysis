SET GLOBAL LOCAL_INFILE =1;
use disasters_stage;
--
LOAD DATA LOCAL
-- INFILE '../datasets/initial-load/continents2.csv'
INFILE 'C:/Users/ACER/source/repos/kpi-ad-4-semestr/kpi-ad-4-laba-1/datasets/initial-load/continents2.csv'
INTO TABLE Country
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(Name, alpha2, alpha3, CountryCode, iso_3166_2, Region, SubRegion, IntermediateRegion, RegionCode, SubRegionCode, IntermidiateRegionCode);