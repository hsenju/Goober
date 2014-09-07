import datetime

INTERVAL_SEC = 3600


class Timer(object):
    def __init__(self, interval_sec=INTERVAL_SEC):
        self.start = datetime.datetime.now()
        self.interval_sec = interval_sec

    def is_done(self):
        return (datetime.datetime.now() -
            self.start).total_seconds() >= self.interval_sec

    def reset(self):
        self.start = datetime.datetime.now()
