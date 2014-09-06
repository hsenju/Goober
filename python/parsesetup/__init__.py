import tweetanalysis.analyzer
import foursquare
import json
import models
import parsesetup_cfg
from parse_rest.connection import register
from parse_rest import query

FS_CLIENT_ID = parsesetup_cfg.FS_CLIENT_ID
FS_CLIENT_SECRET = parsesetup_cfg.FS_CLIENT_SECRET

PARSE_APPLICATION_ID = parsesetup_cfg.PARSE_APPLICATION_ID
PARSE_REST_API_KEY = parsesetup_cfg.PARSE_REST_API_KEY
PARSE_MASTER_KEY = parsesetup_cfg.PARSE_MASTER_KEY

register(PARSE_APPLICATION_ID, PARSE_REST_API_KEY,
         master_key=PARSE_MASTER_KEY)


def main():

    client = foursquare.Foursquare(client_id=FS_CLIENT_ID, client_secret=FS_CLIENT_SECRET)
    places = client.venues.search(params={'ll': '40.7,-74.0', 'limit': '100'})['venues']

    for place in places:
        print place
        name = place['name']
        try:
            category = place['categories'][0]['shortName']
        except IndexError, KeyError:
            category = None
        pop = 10
        geotag = tweetanalysis.analyzer.GeoTag(place['location']['lat'], place['location']['lng'])
        addr = ' '.join(place['location']['formattedAddress'])

        if category:
            try:
                models.Venue.Query.get(name=name)
                print '{} already exists'.format(name)
                return None
            except query.QueryResourceDoesNotExist:
                venue = models.Venue.build(name=name, category=category, pop=pop, geotag=geotag, addr=str(addr))
                venue.save()
                return venue


# main()
