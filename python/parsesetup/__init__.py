import foursquare
from parse_rest.connection import register
import parsesetup_cfg

FS_CLIENT_ID = parsesetup_cfg.FS_CLIENT_ID
FS_CLIENT_SECRET = parsesetup_cfg.FS_CLIENT_SECRET

PARSE_APPLICATION_ID = parsesetup_cfg.PARSE_APPLICATION_ID
PARSE_REST_API_KEY = parsesetup_cfg.PARSE_REST_API_KEY
PARSE_MASTER_KEY = parsesetup_cfg.PARSE_MASTER_KEY

register(PARSE_APPLICATION_ID, PARSE_REST_API_KEY,
         master_key=PARSE_MASTER_KEY)

def main():

    client = foursquare.Foursquare(client_id=FS_CLIENT_ID, client_secret=FS_CLIENT_SECRET)
    # print client.venues.search(params={'ll': '40.7,74.0', 'limit': '10'})

# main()
