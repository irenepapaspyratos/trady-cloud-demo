from datetime import datetime, timedelta

TODAY = datetime.utcnow().date()
DAY = timedelta(days=1)

BASEPATH_LAMBDA = '/tmp/'
BASEPATH_SYMBOL = f'{BASEPATH_LAMBDA}symbol/'

DUCA_APIBASE = 'http://www.dukascopy.com/datafeed'
DUCA_LOGFILE_PATH = f'{BASEPATH_LAMBDA}{TODAY}.log'.replace(' ', '-')

# Earliest starting dates determined by Dukascopy
START_DATES = {
    'EURUSD': datetime(2003, 5, 4),
    'EURGBP': datetime(2003, 8, 3)
}

# Latest stopping date determined by Dukascopy
DEFAULT_STOP = TODAY - DAY

# AWS S3 symbol bucket names
SYMBOL_BUCKETS = ['trady-cloud-symbol-eurusd', 'trady-cloud-symbol-eurgbp', 'trady-cloud-logs']
