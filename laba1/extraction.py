# initial load
import pandas as pd
import numpy as np
import pymysql
from pathes import *
from stage_area_model import *
from config import *

class Extraction:
    def __init__(self, connection: pymysql.Connection):
        self.connection = connection

    def initial_extraction(self):
        self.continents_extraction()
        self.earthquakes_extraction()
        self.volcanos_extraction()
        self.tsunami_extraction_initial()
        self.effect_extraction(damage_description_file_name, damage_description_table)
        self.effect_extraction(people_description_file_name, people_description_table)
        self.effect_extraction(houses_description_file_name, house_description_table)

    def incremental_extraction(self):
        self.tsunami_extraction_initial(tsunamis_file_name_incremental)

    def continents_extraction(self, file_path=continents_file_name):
        data = pd.read_csv(file_path, delimiter=',')
        data = data.replace({np.nan: None})
        data = data.to_numpy()
        columns = get_columns_without_id(self.connection, disasters_stage_db, country_table)
        self.write_data_to_database(country_table, ', '.join(columns), len(columns), data)


    def earthquakes_extraction(self, file_path=earthquakes_file_name):
        data = pd.read_csv(file_path, delimiter=',')
        data = data.drop('I_D', axis=1)
        data = data.replace({np.nan: None})
        data = data.to_numpy()
        columns = get_columns_without_id(self.connection, disasters_stage_db, earthquake_table)
        self.write_data_to_database(earthquake_table, ', '.join(columns), len(columns), data)

    def volcanos_extraction(self, file_path=volcanos_file_name):
        data = pd.read_csv(file_path, delimiter=',')
        data = data.replace({np.nan: None})
        data = data.to_numpy()
        columns = get_columns_without_id(self.connection, disasters_stage_db, volcano_table)
        self.write_data_to_database(volcano_table, ', '.join(columns), len(columns), data)

    def tsunami_extraction_initial(self, file_path=tsunamis_file_name_initial):
        data = pd.read_csv(file_path, delimiter='\t')
        data = data.replace({np.nan: None})
        data = data.drop('Search Parameters', axis=1)
        data = data.drop('Vol', axis=1)
        data = data.drop('More Info', axis=1)
        data = data.dropna(how='all')
        data = data.to_numpy()

        columns = get_columns_without_id(self.connection, disasters_stage_db, tsunami_table)
        self.write_data_to_database(tsunami_table, ', '.join(columns), len(columns), data)

    def effect_extraction(self, filename, table_name):
        data = pd.read_json(filename)
        columns = get_columns_without_id(self.connection, disasters_stage_db, table_name)
        with self.connection.cursor() as cursor:
            for record in data['items']:
                cursor.execute(f"insert into {table_name}({', '.join(columns)}) values ({self.get_format_string(len(columns))})",
                    record['description'])
            self.connection.commit()

    def write_data_to_database(self, table_name, columns_string, column_number, data):
        with self.connection.cursor() as cursor:
            cursor.executemany(
                f"insert into {table_name}({columns_string}) values ({self.get_format_string(column_number)})",
                tuple(map(tuple, data)))
            self.connection.commit()

    def get_format_string(self, table_num):
        return ','.join(['%s']*table_num)
