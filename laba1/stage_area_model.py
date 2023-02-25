import pymysql
country_table = 'Country'
earthquake_table = 'Earthquakes'
tsunami_table = 'TsunamiEvent'
volcano_table = 'VolcanoEvent'

country_attributes = "Name, alpha2, alpha3, CountryCode, iso_3166_2, Region, SubRegion, IntermediateRegion, RegionCode, SubRegionCode, IntermidiateRegionCode"
country_column_number = 11
earthquake_attributes = ''
earthquake_column_number = 46

def get_all_column_names(connection: pymysql.Connection, database_name: str, table_name:str):
    cols = []
    with connection.cursor() as cursor:
         cursor.execute(
             f"""SELECT `COLUMN_NAME`
                FROM `INFORMATION_SCHEMA`.`COLUMNS`
                WHERE `TABLE_SCHEMA`='{database_name}'
                AND `TABLE_NAME`='{table_name}'
                ORDER BY ordinal_position;"""
         )
         cols = cursor.fetchall()
    return cols

def get_columns_without_id(connection: pymysql.Connection, database_name: str, table_name:str):
    cols_objects = get_all_column_names(connection, database_name, table_name)[1:]
    cols = []
    for col_obj in cols_objects:
        cols.append(col_obj['COLUMN_NAME'])
    return cols