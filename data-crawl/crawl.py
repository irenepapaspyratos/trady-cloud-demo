from functions import*

def handler(event, context):
    client_s3 = create_client_boto3_s3()
    used_symbol = 'eurusd'
    settings = setup()
    errors = load_ticks_hour_dukascopy(settings['utcnow']['year'], settings['utcnow']['month'], settings['utcnow']['day'], settings['utcnow']['hour'], used_symbol)
    upload_folder_to_s3(client_s3, used_symbol)
    upload_logfile_to_s3(client_s3, errors)
    
if __name__ == "__main__":
    handler({},{})
