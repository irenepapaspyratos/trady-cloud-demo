from functions import*

def handler(event, context):
    symbol = os.getenv('SYMBOL_CURRENT')
    client_s3 = create_client_boto3_s3()
    settings = setup(symbol)
    
    errors = load_ticks_hour_dukascopy(symbol)
        
    upload_folder_to_s3(client_s3)
    upload_logfile_to_s3(client_s3, errors)

    return ({"settings": settings, "errors": errors})
    
if __name__ == "__main__":
    handler({},{})
