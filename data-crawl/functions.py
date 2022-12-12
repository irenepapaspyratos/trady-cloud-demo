import variables
import os
import urllib.request
import urllib.error
from datetime import datetime
import boto3

def preparation(symbol_storagepath: str = variables.BASEPATH_SYMBOL, logfilepath: str = variables.DUCA_LOGFILE_PATH):
    if not os.path.exists(logfilepath): 
        with open(logfilepath, 'w'): pass
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
    url = f'{variables.DUCA_APIBASE}/{symbol.upper()}/{year:04d}/{(month-1):02d}/{day:02d}/{hour:02d}h_ticks.bi5'
    filename = f'{year:04d}-{(month-1):02d}-{day:02d}-{hour:02d}h_ticks.bi5'
    for i in range(5):
        try:
            urllib.request.urlretrieve(url, f'{symbol_storagepath}{filename}')
        except urllib.error.HTTPError as e:
            with open(logfilepath, 'a') as file:
                file.write('ERROR: ' + str(e.status) + ' ' + url)
        except Exception as e:
            with open(logfilepath, 'a') as file:
                file.write('EXCEPTION: ' + str(e) + ' ' + url)

def create_s3_client():
    return boto3.client('s3')

def upload_folder_to_s3(symbol:str, symbol_storagepath: str = variables.BASEPATH_SYMBOL, bucketlist :list = variables.SYMBOL_BUCKETS):
    client = create_s3_client()
    bucket = filter(lambda f: symbol in f, bucketlist)
    for file in os.listdir(symbol_storagepath):
        client.upload_file(f'{symbol_storagepath}{file}', list(bucket)[0], file.replace('-', '/'))

def upload_logfile(logfilepath: str = variables.DUCA_LOGFILE_PATH,  bucketlist :list = variables.SYMBOL_BUCKETS):
    if os.path.isfile(logfilepath) and os.path.getsize(logfilepath) > 0:
        client = create_s3_client()
        bucket = filter(lambda f: 'logs' in f, bucketlist)
        client.upload_file(logfilepath, list(bucket)[0])
