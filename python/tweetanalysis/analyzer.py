import textblob
import collections

from scraper import Scraper

class WeightedTweet(object):
    def __init__(self, tweet):
        self.geotag = tweet['geo']['coordinates']
        self.weight = textblob.TextBlob(tweet['text']).sentiment
