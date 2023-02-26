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
        self.tsuname_extraction_initial()

    def continents_extraction(self):
        data = pd.read_csv(continents_file_name, delimiter=',')
        data = data.replace({np.nan: None})
        data = data.to_numpy()
        columns = get_columns_without_id(self.connection, disasters_stage_db, country_table)
        self.write_data_to_database(country_table, ', '.join(columns), len(columns), data)


    def earthquakes_extraction(self):
        data = pd.read_csv(earthquakes_file_name, delimiter=',')
        data = data.drop('I_D', axis=1)
        data = data.replace({np.nan: None})
        data = data.to_numpy()
        columns = get_columns_without_id(self.connection, disasters_stage_db, earthquake_table)
        self.write_data_to_database(earthquake_table, ', '.join(columns), len(columns), data)

    def volcanos_extraction(self):
        data = pd.read_csv(volcanos_file_name, delimiter=',')
        data = data.replace({np.nan: None})
        data = data.to_numpy()
        columns = get_columns_without_id(self.connection, disasters_stage_db, volcano_table)
        self.write_data_to_database(volcano_table, ', '.join(columns), len(columns), data)


    def tsuname_extraction_initial(self):
        data = pd.read_csv(tsunamis_file_name_initial, delimiter='\t')
        data = data.replace({np.nan: None})
        data = data.drop('Search Parameters', axis=1)
        data = data.drop('Vol', axis=1)
        data = data.drop('More Info', axis=1)

        data = data.to_numpy()
        columns = get_columns_without_id(self.connection, disasters_stage_db, tsunami_table)
        self.write_data_to_database(tsunami_table, ', '.join(columns), len(columns), data)

    def write_data_to_database(self, table_name, columns_string, column_number, data):
        with self.connection.cursor() as cursor:
            cursor.executemany(
                f"insert into {table_name}({columns_string}) values ({self.get_format_string(column_number)})",
                tuple(map(tuple, data)))
            self.connection.commit()

    def get_format_string(self, table_num):
        return ','.join(['%s']*table_num)
