from parsesetup.models import Venue
from parse_rest.datatypes import GeoPoint
from parse_rest import query

import tweetanalysis.analyzer

class Parse:
    CHUNK_SIZE = 100

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

    def decay_all(self):
        num_proc = self.CHUNK_SIZE
        chunks = 0
        while num_proc == self.CHUNK_SIZE:
            venues = Venue.Query.all().skip(
                chunks * self.CHUNK_SIZE).limit(self.CHUNK_SIZE)

            for venue in venues:
                venue.decay()

            num_proc = len(venues)
            chunks += 1
            print "Chunks decayed: {}".format(chunks)

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
