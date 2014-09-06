from parse_rest.datatypes import Object

# class GeoPoint(Object):
#     def __init__(self, lat, long):
#         super(GeoPoint, self).__init__(self,
#                                        __type="GeoPoint",
#                                        lat=lat,
#                                        long=long)


class Venue(Object):

    @staticmethod
    def build(cls, id_, type_, pop, geotag, addr):
        location = {
            '__type': "GeoPoint",
            'latitude': geotag.lat,
            'longitude': geotag.long
        }

        return Venue(id_=id_,
                     type_=type_,
                     location=location,
                     pop=pop,
                     addr=addr)

    @classmethod
    def find_nearest_to_tweet(cls, weighted_tweet):
        return cls.Query.filter(location__nearSphere=
                                weighted_tweet.geotag)
