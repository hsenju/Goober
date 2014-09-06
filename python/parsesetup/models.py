from __future__ import division

from parse_rest.datatypes import Object

# class GeoPoint(Object):
#     def __init__(self, lat, long):
#         super(GeoPoint, self).__init__(self,
#                                        __type="GeoPoint",
#                                        lat=lat,
#                                        long=long)


class Venue(Object):
    DEFAULT_DECAY = .5
    POPULARITY_CUTOFF = 10

    @staticmethod
    def build(name, category, pop, geotag, addr):
        location = {
            '__type': "GeoPoint",
            'latitude': geotag.lat,
            'longitude': geotag.long
        }

        print "built location: {}".format(location)

        return Venue(name=name,
                     category=category,
                     location=location,
                     pop=pop,
                     addr=addr)

    @classmethod
    def find_nearest_to_tweet(cls, weighted_tweet):
        return cls.Query.filter(location__nearSphere=
                                weighted_tweet.geotag)

    def update_popularity(self, factor):
        print "Updating for factor: {}".format(factor)

        if not factor:
            return

        if factor > 0:
            self.pop *= (1 + factor)
        else:
            self.pop /= (1 + factor)

    def decay(self):
        self.update_popularity((-1 if self.popularity <
                                self.POPULARITY_CUTOFF else 1) *
                                self.DEFAULT_DECAY)
