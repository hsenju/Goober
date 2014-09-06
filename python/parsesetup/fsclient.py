import parsesetup_cfg

from foursquare import Foursquare

FS_CLIENT_ID = parsesetup_cfg.FS_CLIENT_ID
FS_CLIENT_SECRET = parsesetup_cfg.FS_CLIENT_SECRET


class VenueNotFoundError(Exception):
    pass


class FSClient(object):
    def __init__(self):
        self.client = Foursquare(client_id=FS_CLIENT_ID,
                                 client_secret=FS_CLIENT_SECRET)

    def find_nearest(self, geotag):
        res = self.client.venues.search(params={
            'll':'{},{}'.format(geotag.lat, geotag.long),
            'limit': '1',
            'intent': 'browse',
            'radius': '100'
        })
        print "got nearest: {}".format(res)

        try:
            return res['venues'][0]
        except IndexError:
            raise VenueNotFoundError()
