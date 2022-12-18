import variables
from starts import DATES
import os
import urllib.request
import urllib.error
from datetime import datetime
import boto3

def setup(symbol:str, symbol_storagepath:str = variables.BASEPATH_SYMBOL, logfilepath:str = variables.DUCA_LOGFILE_PATH):
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
        },
        'default_start': DATES[symbol.upper()]
    }

def get_utc_lastday_month(month:int = datetime.utcnow().month, year:int = datetime.utcnow().year):
    lastday = 31 if month == 12 else datetime(year, month + 1, 1) - variables.DAY
    return int(lastday.day)

def get_utcdata_to_use(year:int = datetime.utcnow().year, month:int = datetime.utcnow().month, day:int = datetime.utcnow().day, hour:int = datetime.utcnow().hour):
    utcdate = datetime(year, month, day, hour)
    usehour = utcdate.hour - 1 if not utcdate.hour == 0 else 23
    useday = utcdate.day
    useyear = utcdate.year
    usemonth = utcdate.month - 1
    if utcdate.hour == 0:
        if utcdate.day == 1:
            if utcdate.month == 1:
                useyear = utcdate.year - 1
                usemonth = 11
                useday = 31
            else:
                usemonth = utcdate.month - 2
                useday = get_utc_lastday_month(utcdate.month - 1)
        else:
            useday = utcdate.day -1
    return {
            'y': useyear,
            'm': usemonth,
            'd': useday,
            'h': usehour
    }

def get_symbols(bucketlist:list = variables.SYMBOL_BUCKETS):
    symbols = []
    for b in bucketlist:
        fragments = b.split('-')
        symbols.append(fragments[len(fragments)-1])
    return symbols

def load_ticks_hour_dukascopy(symbol:str, error_list:list = [], year:int = datetime.utcnow().year, month:int = datetime.utcnow().month, day:int = datetime.utcnow().day, hour:int = datetime.utcnow().hour, symbol_basepath:str = variables.BASEPATH_SYMBOL):
    usedata = get_utcdata_to_use(year, month, day, hour)
    useyear = usedata['y']
    usemonth = usedata['m']
    useday = usedata['d']
    usehour = usedata['h']
    namemonth = usemonth + 1
    url = f'{variables.DUCA_APIBASE}/{symbol.upper()}/{useyear:04d}/{usemonth:02d}/{useday:02d}/{usehour:02d}h_ticks.bi5'
    filename = f'{symbol}-{useyear:04d}-{namemonth:02d}-{useday:02d}-{usehour:02d}h_ticks.bi5'
    for i in range(5):
        try:
            urllib.request.urlretrieve(url, f'{symbol_basepath}{filename}')
        except urllib.error.HTTPError as e:
                error_list.append('ERROR: ' + str(e.status) + ' ' + url)
        except Exception as e:
                error_list.append('EXCEPTION: ' + str(e) + ' ' + url)
    return error_list

def create_client_boto3_s3():
    return boto3.client('s3')

def upload_folder_to_s3(client_s3, src_path:str = variables.BASEPATH_SYMBOL, dest_bucket:str = variables.S3_BUCKET_SYMBOL_LAKE):
    for file in os.listdir(src_path):
        client_s3.upload_file(f'{src_path}{file}', dest_bucket, file.replace('-', '/'))

def upload_logfile_to_s3(client_s3, error_list:list, logfile:str = variables.DUCA_LOGFILE_PATH,  dest_bucket:list = variables.S3_BUCKET_SYMBOL_LOGS):
    if len(error_list) > 0:
        with open(logfile, 'w') as file:
            for e in error_list:
                file.write(e)
        client_s3.upload_file(logfile, dest_bucket, logfile.replace('/tmp/', ''))
