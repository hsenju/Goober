import twitter

from engine.timer import Timer
from tweetanalysis import scraper, analyzer
from parsesetup.db import Parse
from parsesetup.fsclient import FSClient, VenueNotFoundError
from time import sleep


def run():
    decay_timer = Timer()
    tweet_builder = analyzer.WeightedTweetBuilder(scraper.Scraper())
    parse = Parse()
    fsclient = FSClient()

    while True:
        try:
            while not decay_timer.is_done():
                try:
                    weighted_tweets = tweet_builder.new_tweets()
                except twitter.TwitterHTTPError:
                    print "Twitter complained!"
                    sleep(10)
                    continue

                print "Got tweets."

                for weighted_tweet in weighted_tweets:
                    try:
                        venue = parse.add_if_not_exists(
                            fsclient.find_nearest(
                                weighted_tweet.geotag))
                        parse.update_for_tweet(weighted_tweet, venue)
                    except VenueNotFoundError:
                        pass

            print "Updated popularity."

            print "Decaying...."

            parse.decay_all()
            decay_timer.reset()

            print "Done."
        except Exception, e:
            print "SOMETHING WENT WRONG: {}".format(e)
