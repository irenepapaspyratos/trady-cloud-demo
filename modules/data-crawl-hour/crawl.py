from functions import*

def handler(event, context):
    client_s3 = create_client_boto3_s3()
    settings = setup()
    
    errors = load_ticks_hour_dukascopy(os.getenv('SYMBOL_CURRENT'))
        
    upload_folder_to_s3(client_s3)
    upload_logfile_to_s3(client_s3, errors)
    
if __name__ == "__main__":
    handler({},{})
