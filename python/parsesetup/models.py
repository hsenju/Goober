from parse_rest.datatypes import Object

# class GeoPoint(Object):
#     def __init__(self, lat, long):
#         super(GeoPoint, self).__init__(self,
#                                        __type="GeoPoint",
#                                        lat=lat,
#                                        long=long)


class Venue(Object):
    def __init__(self, id_, type_, pop, geotag, addr):
        geotag = {
            '__type': "GeoPoint",
            'latitude': geotag.lat,
            'longitude': geotag.long
        }

        super(Venue, self).__init__(id_=id_, type_=type_,
                                    geotag=geotag,
                                    pop=pop,
                                    addr=addr)
