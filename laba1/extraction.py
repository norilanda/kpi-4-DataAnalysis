# initial load
import pandas as pd
import numpy as np
import pymysql
from pathes import *
from stage_area_model import *

class Extraction:
    def __init__(self, connection: pymysql.Connection):
        self.connection = connection

    def initial_extract(self):
        pass

    def continents_extraction(self):
        data = pd.read_csv(continents_file_name, delimiter=',')
        data = data.replace({np.nan: None})
        data = data.to_numpy()
        with self.connection.cursor() as cursor:
            cursor.executemany(f"insert into {country_table}({country_attributes}) values ({self.get_format_string(country_column_number)})", tuple(map(tuple, data)))
            self.connection.commit()

    def earthquakes_extraction(self):
        pass

    def get_format_string(self, table_num):
        return ','.join(['%s']*table_num)
