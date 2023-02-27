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

DELIMITER ;
DROP PROCEDURE IF EXISTS disasters_dwh.parse_damage_effect;

DELIMITER $$
CREATE PROCEDURE disasters_dwh.parse_damage_effect(
    value varchar(50), OUT status varchar(15), OUT lowerBound int, OUT upperBound int)
    BEGIN
        DECLARE pos int;
        DECLARE bound varchar(25);
        SET pos = POSITION('(' IN value);
        IF pos = 0
            THEN
              SET status = value;
              SET lowerBound = 0;
              SET upperBound = 0;
        ELSE
            SET status = SUBSTR(value, 1, POSITION(' ' IN value));
            SET value = SUBSTR(value, pos+1);
            SET pos = POSITION(' ' IN value);
            SET bound = SUBSTR(value, pos+1);
            SET value = SUBSTR(value, 1, pos);
            SET upperBound = REGEXP_SUBSTR(bound,'[0-9]+');
            SET lowerBound = REGEXP_SUBSTR(value,'[0-9]+');
        END IF;
    END $$

DELIMITER ;
DROP PROCEDURE IF EXISTS disasters_dwh.insert_damage_effect_table;

DELIMITER $$
CREATE PROCEDURE disasters_dwh.insert_damage_effect_table()
    BEGIN
        DECLARE str varchar(35);
        DECLARE finished INT DEFAULT 0;
        -- declare cursor for employee email
        DEClARE curs CURSOR FOR
                SELECT description
                FROM disasters_stage.damageeffectdescription
                UNION
                SELECT description
                FROM disasters_stage.peopleeffectdescription
                UNION
                SELECT description
                FROM disasters_stage.houseeffectdescription;
        -- declare NOT FOUND handler
        DECLARE CONTINUE HANDLER
            FOR NOT FOUND SET finished = 1;
        OPEN curs;

        insertValues: LOOP
            FETCH curs INTO str;
            IF finished = 1 THEN
                LEAVE insertValues;
            END IF;
            call disasters_dwh.parse_damage_effect(str, @status, @lb,@ub);
            IF NOT EXISTS(
                SELECT DamageDescriptionID
                FROM dim_damagedescription
                WHERE DescriptionStatus = @status
                          AND LowerBound = @lb AND (UpperBound = @ub OR UpperBound IS NULL )
                )
                THEN
                    INSERT INTO dim_damagedescription(descriptionstatus, lowerbound, upperbound)
                        VALUES (@status, @lb, @ub);
            end if ;
        END LOOP insertValues;
        CLOSE curs;
    END $$
