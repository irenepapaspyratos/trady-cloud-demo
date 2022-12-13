import variables
import os
import urllib.request
import urllib.error
from datetime import datetime
import boto3

def setup(symbol_storagepath: str = variables.BASEPATH_SYMBOL, logfilepath: str = variables.DUCA_LOGFILE_PATH):
    if not os.path.exists(symbol_storagepath):
        os.mkdir(symbol_storagepath)
    return {
        'logfilepath': logfilepath,
        'symbolpath': symbol_storagepath,
        'utcnow': {
            'year': datetime.utcnow().year,
            'month': datetime.utcnow().month,
            'day': datetime.utcnow().day,
            'hour': datetime.utcnow().hour
        }
    }

def load_ticks_hour_dukascopy(year:int, month:int, day:int, hour:int, symbol:str, symbol_storagepath: str = variables.BASEPATH_SYMBOL, logfilepath: str = variables.DUCA_LOGFILE_PATH):
    error_list = []
    url = f'{variables.DUCA_APIBASE}/{symbol.upper()}/{year:04d}/{(month-1):02d}/{day:02d}/{hour:02d}h_ticks.bi5'
    filename = f'{year:04d}-{(month-1):02d}-{day:02d}-{hour:02d}h_ticks.bi5'
    for i in range(5):
        try:
            urllib.request.urlretrieve(url, f'{symbol_storagepath}{filename}')
        except urllib.error.HTTPError as e:
                error_list.append('ERROR: ' + str(e.status) + ' ' + url)
        except Exception as e:
                error_list.append('EXCEPTION: ' + str(e) + ' ' + url)
    return error_list

def create_client_boto3_s3():
    return boto3.client('s3')

def upload_folder_to_s3(client_s3, symbol:str, symbol_storagepath: str = variables.BASEPATH_SYMBOL, bucketlist :list = variables.SYMBOL_BUCKETS):
    bucket = filter(lambda f: symbol in f, bucketlist)
    for file in os.listdir(symbol_storagepath):
        client_s3.upload_file(f'{symbol_storagepath}{file}', list(bucket)[0], file.replace('-', '/'))

def upload_logfile_to_s3(client_s3, error_list: list, logfilepath: str = variables.DUCA_LOGFILE_PATH,  bucketlist: list = variables.SYMBOL_BUCKETS):
    if len(error_list) > 0:
        with open(logfilepath, 'w') as file:
            for e in error_list:
                file.write(e)
        bucket = filter(lambda f: 'logs' in f, bucketlist)
        client_s3.upload_file(logfilepath, list(bucket)[0])
