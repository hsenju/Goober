from parsesetup.models import Venue
from parse_rest.datatypes import GeoPoint

class Parse:
    def find_nearest(self, weighted_tweet):
        res = Venue.Query.filter(location__nearSphere=
                                  GeoPoint(*weighted_tweet.geotag),
                                  limit=1)
        print "Got venues: {}".format(res)
        return res[0]

    def update_for_tweet(self, weighted_tweet):
        venue = self.find_nearest(weighted_tweet)
        venue.update_popularity(weighted_tweet.weight)

        venue.save()

    def decay_all(self):
        venues = Venue.Query.all()

        for venue in venues:
            venue.decay()
