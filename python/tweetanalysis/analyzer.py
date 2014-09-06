import textblob
import collections

from scraper import Scraper

GeoTag = collections.namedtuple("Geotag", ['lat', 'long'])

class WeightedTweet(object):
    def __init__(self, tweet):
        self.geotag = GeoTag(*tweet['geo']['coordinates'])
        self.weight = textblob.TextBlob(tweet['text']).sentiment.polarity
