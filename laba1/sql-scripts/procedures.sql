DROP FUNCTION IF EXISTS delete_country_from_location;

DELIMITER $$
CREATE FUNCTION delete_country_from_location(location varchar(150))
    RETURNS varchar(90)
    DETERMINISTIC
    BEGIN
        DECLARE pos int;
        SET pos = POSITION(':' IN location);
        IF pos != 0
            THEN
              SET location = TRIM(SUBSTR(location, pos+1));
              IF location = '' THEN
                  SET location = NULL;
              end if ;
        END IF;
        RETURN location;
    END $$

DELIMITER ;
DROP FUNCTION IF EXISTS disasters_dwh.if_is_not_alphanumeric_set_null;

DELIMITER $$
CREATE FUNCTION disasters_dwh.if_is_not_alphanumeric_set_null(value varchar(150))
    RETURNS varchar(90)
    DETERMINISTIC
    BEGIN
        SET value = TRIM(value);
        IF value = ''
            THEN
              SET value = NULL;
        END IF;
        RETURN value;
    END $$