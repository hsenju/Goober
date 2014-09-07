from parsesetup.models import Venue
from parse_rest.datatypes import GeoPoint
from parse_rest import query

import tweetanalysis.analyzer


class Parse:

    def find_nearest(self, weighted_tweet):
        res = Venue.Query.filter(location__nearSphere=
                                  GeoPoint(
                                      *weighted_tweet.geotag)).limit(1)
        print "Got venues: {}".format(res)
        return res[0]

    def update_for_tweet(self, weighted_tweet, venue=None):
        if not venue:
            venue = self.find_nearest(weighted_tweet)

        venue.update_popularity(weighted_tweet.weight)

        venue.save()

    def decay_all(self):
        venues = Venue.Query.all()

        for venue in venues:
            venue.decay()

    def add_if_not_exists(self, place):
        name = place['name']
        try:
            category = place['categories'][0]['shortName']
        except IndexError, KeyError:
            category = None
        pop = 10
        geotag = tweetanalysis.analyzer.GeoTag(
            place['location']['lat'], place['location']['lng'])
        addr = ' '.join(place['location']['formattedAddress'])

        if category and category not in Venue.BLACK_LIST:
            try:
                Venue.Query.get(name=name)
                print '{} already exists'.format(name)
            except query.QueryResourceDoesNotExist:
                venue = Venue.build(name=name,
                                    category=category,
                                    pop=pop,
                                    geotag=geotag,
                                    addr=str(addr))
                venue.save()
