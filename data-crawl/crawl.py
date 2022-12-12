import os
from functions import*

def handler(event, context):
    client = create_s3_client()
    used_symbol = 'eurusd'
    settings = setup()
    load_ticks_hour_dukascopy(settings['utcnow']['year'], settings['utcnow']['month'], settings['utcnow']['day'], settings['utcnow']['hour'], used_symbol)
    upload_folder_to_s3(client, used_symbol)
    
if __name__ == "__main__":
    handler({},{})
