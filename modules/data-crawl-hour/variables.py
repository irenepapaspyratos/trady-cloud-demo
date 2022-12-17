from datetime import datetime, timedelta

TODAY = datetime.utcnow().date()
DAY = timedelta(days=1)

BASEPATH_LAMBDA = '/tmp/'
BASEPATH_SYMBOL = f'{BASEPATH_LAMBDA}symbol/'

DUCA_APIBASE = 'http://www.dukascopy.com/datafeed'
DUCA_LOGFILE_PATH = f'{BASEPATH_LAMBDA}{TODAY}.log'.replace(' ', '-')

# Latest stopping date determined by Dukascopy
DEFAULT_STOP = TODAY - DAY

# AWS S3 symbol bucket names
S3_BUCKET_SYMBOLBASE = 'trady-cloud-symbol'
S3_BUCKET_SYMBOL_LAKE = 'trady-cloud-symbol-lake'
S3_BUCKET_SYMBOL_LOGS = 'trady-cloud-symbol-logs'
SYMBOL_BUCKETS = ['trady-cloud-symbol-eurusd', 'trady-cloud-symbol-eurgbp']
