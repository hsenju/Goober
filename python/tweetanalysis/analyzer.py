from __future__ import division
from parse_rest.datatypes import GeoPoint

import textblob
import collections

from scraper import Scraper

GeoTag = collections.namedtuple("GeoTag", ['lat', 'long'])

def coords_to_geotag(coords):
    print "finding center of coords: {}".format(coords)
    inner = coords[0]
    lat = 0
    lng = 0

    for new_lng, new_lat in inner:
        lat += new_lat
        lng += new_lng

    num_coords = len(inner)

    print "Got center lat: {}, lng: {}".format(
        lat/num_coords, lng/num_coords)

    return GeoTag(lat/num_coords, lng/num_coords)

class WeightedTweet(object):
    def __init__(self, tweet):
        print "Building for tweet: {}".format(tweet)
        self.geotag = coords_to_geotag(
                tweet['place']['bounding_box']['coordinates'])
        self.weight = textblob.TextBlob(tweet['text']).sentiment.polarity

class WeightedTweetBuilder(object):
    def __init__(self, scraper):
        self.scraper = scraper

    def new_tweets(self):
        return [WeightedTweet(tweet) for tweet in self.scraper.new_tweets()]
