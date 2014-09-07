from __future__ import division

import itertools
import twitter
import random

import twitter_cfg

from analyzer import GeoTag

ZEN = ['Beautiful is better than ugly.',
       'Explicit is better than implicit.',
       'Simple is better than complex.',
       'Complex is better than complicated.',
       'Flat is better than nested.',
       'Sparse is better than dense.',
       'Readability counts.',
       "Special cases aren't special enough to break the rules.",
       'Although practicality beats purity.',
       'Errors should never pass silently.',
       'Unless explicitly silenced.',
       'In the face of ambiguity, refuse the temptation to guess.',
       'There should be one-- and preferably only one --obvious way to do it.',
       "Although that way may not be obvious at first unless you're Dutch.",
       'Now is better than never.',
       'Although never is often better than *right* now.',
       "If the implementation is hard to explain, it's a bad idea.",
       'If the implementation is easy to explain, it may be a good idea.',
       "Namespaces are one honking great idea -- let's do more of those!",]

class Tweeter(object):
    FUZZ = .01

    def __init__(self, geotag):
        self.sentence = itertools.cycle(ZEN)
        self.client = twitter.Twitter(auth=twitter.OAuth(
            twitter_cfg.ACCESS_TOKEN,
            twitter_cfg.ACCESS_SECRET,
            twitter_cfg.API_KEY,
            twitter_cfg.API_SECRET))
        self.geotag = geotag

    def fuzz(self):
        return random.uniform(-self.FUZZ, self.FUZZ)

    def make_geotag(self):
        return GeoTag(self.geotag.lat + self.fuzz(),
                      self.geotag.long + self.fuzz())

    def post(self):
        gt = self.make_geotag()
        self.client.statuses.update(
            status=self.sentence.next(),
            lat=gt.lat,
            long=gt.long)
