import os
from functions import*

def handler(event, context):
    
    used_symbol = 'eurusd'
    preps = preparation()
    load_ticks_hour_dukascopy(preps['utcnow']['year'], preps['utcnow']['month'], preps['utcnow']['day'], preps['utcnow']['hour'], used_symbol)
    upload_folder_to_s3(used_symbol)
    
if __name__ == "__main__":
    handler({},{})
