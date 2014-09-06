import textblob
import collections

from scraper import Scraper

WeightedTweet = collections.namedtuple("WeightedTweet",
                                       ['geotag', 'weight'])

class Analyzer(object):
