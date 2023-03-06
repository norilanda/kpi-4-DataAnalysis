DROP PROCEDURE IF EXISTS insert_event_type;

DELIMITER $$
CREATE PROCEDURE disasters_dwh.insert_event_type(type VARCHAR(20))
    BEGIN
        INSERT INTO disasters_dwh.dim_eventtype(EventTypeName) VALUES (type);
    end;

DELIMITER ;
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
        DECLARE type varchar(20);
        DECLARE finished INT DEFAULT 0;
        -- declare cursor for employee email
        DEClARE curs CURSOR FOR
                SELECT description, 'damageMillionDollars'
                FROM disasters_stage.damageeffectdescription
                UNION
                SELECT description, 'people'
                FROM disasters_stage.peopleeffectdescription
                UNION
                SELECT description, 'houses'
                FROM disasters_stage.houseeffectdescription;
        -- declare NOT FOUND handler
        DECLARE CONTINUE HANDLER
            FOR NOT FOUND SET finished = 1;
        OPEN curs;

        insertValues: LOOP
            FETCH curs INTO str, type;
            IF finished = 1 THEN
                LEAVE insertValues;
            END IF;
            call disasters_dwh.parse_damage_effect(str, @status, @lb,@ub);

            if POSITION('<' in str) != 0
            then
                SET @ub = @lb;
                SET @lb = 0;
            end if ;
            INSERT INTO dim_damagedescription(descriptionstatus, lowerbound, upperbound, DamageType)
                VALUES (@status, @lb, @ub, type);

        END LOOP insertValues;
        CLOSE curs;
    END $$

DELIMITER ;
DROP FUNCTION IF EXISTS disasters_dwh.find_damage_description_id;

DELIMITER $$
CREATE FUNCTION disasters_dwh.find_damage_description_id(type enum('people', 'houses', 'damageMillionDollars'), id int)
RETURNS int
DETERMINISTIC
begin
    DECLARE description_id int;
    if id IS NULL
    then
        return NULL;
    end if ;
    SELECT * into description_id
    FROM(SELECT DamageDescriptionID
    FROM disasters_dwh.dim_damagedescription
    WHERE DamageType = type) as t
    LIMIT id, 1;
    return description_id;
end $$


DROP FUNCTION IF EXISTS transform_country_name;
DELIMITER $$
CREATE FUNCTION disasters_dwh.transform_country_name(country VARCHAR(100))
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    SET country = lcase(country);
    SET country = REPLACE(country, ',', '');
    SET country = REGEXP_REPLACE(country, '(( |,|.)usa( |,|.))|^usa$|^usa( |,|.)|( |,|.)usa$|u.s.', ' united states ');
    SET country = REGEXP_REPLACE(country, '^uk$', ' united kingdom ');
    SET country = REGEXP_REPLACE(country, ' is.', ' islands ');
    if country REGEXP '^d(.)*r(.)*c(.)*$|^d(.)*r(.)*c(.)*( )|( )d(.)*r(.)*c(.)*$|( )d(.)*r(.)*c(.)*( )' then
        set country = 'Democratic Republic of the Congo';
    end if ;

    SET country = TRIM(country);
    RETURN country;
end $$