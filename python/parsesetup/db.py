from parsesetup.models import Venue

class Parse:
    # def add(self, venue):
    #     venue.save()

    def find_nearest(self, weighted_tweet):
        return Venue.Query.filter(location__nearSphere=weighted_tweet.geotag,
                                  limit=1)[0]

    def update_for_tweet(self, weighted_tweet):
        venue = self.find_nearest(weighted_tweet)
        venue.update_popularity(weighted_tweet.weight)

        venue.save()

    def decay_all(self):
        venues = Venue.Query.all()

        for venue in venues:
            venue.decay()
