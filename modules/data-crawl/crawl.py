from functions import*

def handler(event, context):
    client_s3 = create_client_boto3_s3()
    used_symbols = get_symbols()
    settings = setup()
    
    for s in used_symbols:
        errors = load_ticks_hour_dukascopy(s)
        
    upload_folder_to_s3(client_s3)
    upload_logfile_to_s3(client_s3, errors)
    
if __name__ == "__main__":
    handler({},{})
