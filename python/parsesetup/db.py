class Parse:

    def add(self, venue):
        venue.save()

    def update_popularity(self, venue, factor):
        if venue.popularity > 0:
            venue.popularity *= (1 + factor)
        else:
            venue.popularity /= (1 + factor)

    def find_nearest(self, weighted_tweet):
        pass
