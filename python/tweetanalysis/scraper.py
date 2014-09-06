import twitter
import itertools

import twitter_cfg

# class Tweets(object):
#     def __init__(self, stream, max_count=PER_CHUNK):
#         self.current = 0
#         self.max_count = max_count
#         self.stream = stream

#     def __iter__(self):
#         return self

#     def next(self):
#         self.current += 1
#         if self.current == self.max_count:
#             raise StopIteration
#         else:

class Scraper(object):
    LOCATION = "-74,40,-73,41"
    # BUMP THIS UP LATER
    PER_CHUNK = 10

    def __init__(self):
        self.stream = twitter.TwitterStream(auth=twitter.OAuth(
            twitter_cfg.ACCESS_TOKEN,
            twitter_cfg.ACCESS_SECRET,
            twitter_cfg.API_KEY,
            twitter_cfg.API_SECRET))

    def new_tweets(self):
        return [tweet for (_, tweet) in itertools.izip(
            xrange(self.PER_CHUNK), self.stream.statuses.filter(
                locations=self.LOCATION))]
