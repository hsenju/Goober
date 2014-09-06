import httplib
import json
import requests
import urllib
import parsesetup_cfg

class Parse:

    def add(self, venue):
        venue.save()

    def update_popularity(self, venue, factor):
        if venue.popularity > 0:
            venue.popularity *= (1 + factor)
        else:
            venue.popularity /= (1 + factor)

    def find_nearest(self, weighted_tweet):
        connection = httplib.HTTPSConnection('api.parse.com', 443)
        params = urllib.urlencode({"limit": 10, "where": json.dumps({
               "location": {
                 "$nearSphere": {
                   "__type": "GeoPoint",
                   "latitude": weighted_tweet.geotag.lat,
                   "longitude": weighted_tweet.geotag.long
                 }
               }
             })})
        connection.connect()
        connection.request('GET', '/1/classes/PlaceObject?%s' % params, '', {
               "X-Parse-Application-Id": "{}".format(parsesetup_cfg.PARSE_APPLICATION_ID),
               "X-Parse-REST-API-Key": "{}".format(parsesetup_cfg.PARSE_REST_API_KEY)
             })
        result = json.loads(connection.getresponse().read())

        try:
            result[0]['objectId']
        except IndexError:
            print 'Something went wrong'
            exit(0)
