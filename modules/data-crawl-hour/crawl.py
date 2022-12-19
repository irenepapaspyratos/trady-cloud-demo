from functions import*

def get_crawl_hour():
    crawl = [int(x) for x in os.getenv('DEFAULT_CRAWL').split('-')]
    hour = crawl[3] + 1
    crawl[3] = hour
    return crawl

def get_ticks(symbol, invocation):
    errors = []
    if invocation == 'true':
        crawl = get_crawl_hour()
        load_ticks_hour_dukascopy(symbol, errors, crawl[0], crawl[1], crawl[2], crawl[3])
    else:
        errors = load_ticks_hour_dukascopy(symbol, errors)
    return errors

def upload_to_bucket(client_s3, errors):
    upload_folder_to_s3(client_s3)
    upload_logfile_to_s3(client_s3, errors)

def handler(event, context):
    symbol = os.getenv('SYMBOL_CURRENT')
    invocation = os.getenv('INVOCATION')
    client_s3 = create_client_boto3_s3()
    settings = setup(symbol)

    errors = get_ticks(symbol, invocation)
    upload_to_bucket(client_s3, errors)

    return ({"crawl_hour": os.getenv('DEFAULT_CRAWL'), "settings": settings, "errors": errors})
    
if __name__ == "__main__":
    handler({},{})
