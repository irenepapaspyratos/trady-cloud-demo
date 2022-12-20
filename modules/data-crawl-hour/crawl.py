from functions import*

def get_crawl_hour():
    crawl = [int(x) for x in os.getenv('DEFAULT_CRAWL').split('-')]
    if os.getenv('INVOCATION') == 'true':
        hour = crawl[3] + 1
        crawl[3] = hour
    return crawl

def upload_to_bucket(client_s3, errors):
    upload_folder_to_s3(client_s3)
    upload_logfile_to_s3(client_s3, errors)


def handler(event, context):
    symbol = os.getenv('SYMBOL_CURRENT')
    client_s3 = create_client_boto3_s3()
    settings = setup(symbol)
    crawl = get_crawl_hour()

    errors = []
    load_ticks_hour_dukascopy(symbol, errors, crawl[0], crawl[1], crawl[2], crawl[3])
    upload_to_bucket(client_s3, errors)

    return ({"crawl_hour": os.getenv('DEFAULT_CRAWL'), "settings": settings, "errors": errors})
    
if __name__ == "__main__":
    handler({},{})
