import textblob
import collections

from scraper import Scraper

GeoTag = collections.namedtuple("Geotag", ['lat', 'long'])

class WeightedTweet(object):
    def __init__(self, tweet):
        self.geotag = GeoTag(*tweet['geo']['coordinates'])
        self.weight = textblob.TextBlob(tweet['text']).sentiment.polarity

class WeightedTweetBuilder(object):
    def __init__(self, scraper):
        self.scraper = scraper

    def new_tweets(self):
        return [WeightedTweet(tweet) for tweet in self.scraper.new_tweets()]
