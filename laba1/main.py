import pymysql
from config import host, password, stage_area_user, dwh_area_user, disasters_stage_db, disasters_dwh_db
from extraction import Extraction

try:
    connection = pymysql.connect(
        host=host,
        port=3306,
        user=stage_area_user,
        password=password,
        database=disasters_stage_db,
        cursorclass=pymysql.cursors.DictCursor
    )
    print("Connection is successfull")
    extr = Extraction(connection)
    extr.initial_extraction()
    # try:
    #     with connection.cursor() as cursor:
    #         pass
    # finally:
        # connection.close()
except Exception as e:
    print("Connection FAILED!")
    print (e)
