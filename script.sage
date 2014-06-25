import random
from sage.rings.all import ZZ, QQ
import csv
from timeit import Timer
import time
from multiprocessing import Pool


class Analysis():

    def __init__(self):
        self.cols = random.randint(2, 5)
        self.rows = random.randint(2, 5)
        ring = random.choice([ZZ, QQ])
        self.A = random_matrix(ring, self.rows, self.cols)
        self.B = random_matrix(ring, self.rows, self.cols)
        self.game = NormalFormGame([self.A, self.B])

    def lrs_timing(self):
        lrs_timer = Timer(lambda: self.game.obtain_Nash(algorithm='lrs'))
        lrs_time = lrs_timer.timeit(number=5)
        lrs_nash = self.game.obtain_Nash(algorithm='lrs')
        return lrs_time, lrs_nash

    def LCP_timeing(self):
        LCP_timer = Timer(lambda: self.game.obtain_Nash(algorithm='LCP'))
        LCP_time = LCP_timer.timeit(number=5)
        LCP_nash = self.game.obtain_Nash(algorithm='LCP')
        return LCP_time, LCP_nash

    def enum_timing(self):
        enum_timer = Timer(lambda: self.game.obtain_Nash(algorithm='enumeration'))
        enum_time = enum_timer.timeit(number=5)
        enum_nash = self.game.obtain_Nash(algorithm='enumeration')
        return enum_time, enum_nash

    def return_data(self):

        pool = Pool()
        lrs_out = pool.apply_async(self.lrs_timing)
        LCP_out = pool.apply_async(self.LCP_timeing)
        enum_out = pool.apply_async(self.enum_timing)
        lrs_time, lrs_nash = lrs_out.get()
        LCP_time, LCP_nash = LCP_out.get()
        enum_time, enum_nash = enum_out.get()

        date = time.strftime("%d/%m/%Y")
        tim = time.strftime("%H:%M:%S")
        dimensions = (self.cols, self.rows)
        matrix1 = list(self.A)
        matrix2 = list(self.B)
        return [date, tim, dimensions, matrix1, matrix2, lrs_time, LCP_time, enum_time, lrs_nash, LCP_nash, enum_nash]


Game = Analysis()

logFile = open("log.csv", 'wb')
wr = csv.writer(logFile)
wr.writerow(Game.return_data())
