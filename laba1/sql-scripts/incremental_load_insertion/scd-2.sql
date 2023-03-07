DROP PROCEDURE IF EXISTS disasters_dwh.scd_country;

DELIMITER $$
CREATE PROCEDURE disasters_dwh.scd_country(old_name varchar(70), new_name varchar(70))
BEGIN
    DECLARE old_id int DEFAULT null;
    DECLARE old_subCont_id int;
    DECLARE new_id int;

    SELECT CountryID, SubContinentID into old_id, old_subCont_id
    FROM dim_country
    WHERE CountryName = old_name;
  IF old_id IS NULL THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Old country name has not been found!';
    ELSE
      INSERT INTO dim_country (SubContinentID, CountryName, Load_Date, Old_reference_ID)
          VALUE(old_subCont_id, new_name, CURRENT_DATE, old_id);
      UPDATE dim_country
      SET End_Load_Date = CURRENT_DATE
      WHERE CountryID = old_id;

      SELECT CountryID into new_id
      FROM dim_country
      WHERE CountryName LIKE new_name;
      UPDATE dim_location
      SET CountryID = new_id
      WHERE CountryID = old_id;
      -- NEEED TO FINISH!!!!!!!!!!!!!!!!!!!!!!!!
  end if ;
end $$

DELIMITER ;