from engine.timer import Timer
from tweetanalysis import scraper, analyzer
from parsesetup.db import Parse

def run():
    decay_timer = Timer()
    tweet_builder = analyzer.WeightedTweetBuilder(scraper.Scraper())
    parse = Parse()

    while True:
        while not decay_timer.is_done():
            weighted_tweets = tweet_builder.new_tweets()

            print "Got tweets."

            for weighted_tweet in weighted_tweets:
                parse.update_for_tweet(weighted_tweet)

            print "Updated popularity."

        print "Decaying...."

        parse.decay_all()

        print "Done."
