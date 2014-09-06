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
               "geotag": {
                 "$nearSphere": {
                   "__type": "GeoPoint",
                   "latitude": weighted_tweet.geotag.lat,
                   "longitude": weighted_tweet.geotag.long
                 }
               }
             })})
        connection.connect()
        connection.request('GET', '/1/classes/Venue?%s' % params, '', {
               "X-Parse-Application-Id": "{}".format(
                   parsesetup_cfg.PARSE_APPLICATION_ID),
               "X-Parse-Master-Key": "{}".format(
                   parsesetup_cfg.PARSE_MASTER_KEY)
             })
        result = json.loads(connection.getresponse().read())

        print result

        try:
            result[0]['objectId']
        except IndexError:
            print 'Something went wrong'
            exit(0)
