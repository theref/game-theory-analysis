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
        self.ring = random.choice([ZZ, QQ])
        if self.ring == QQ:
            self.A = random_matrix(QQ, self.rows, self.cols, num_bound=100, den_bound=4)
            self.B = random_matrix(QQ, self.rows, self.cols, num_bound=100, den_bound=4)
        if self.ring == ZZ:
            self.A = random_matrix(ZZ, self.rows, self.cols, x=-25, y=25)
            self.B = random_matrix(ZZ, self.rows, self.cols, x=-25, y=25)

        self.game = NormalFormGame([self.A, self.B])

    @fork
    def lrs_timing(self):
        lrs_timer = Timer(lambda: self.game.obtain_Nash(algorithm='lrs'))
        lrs_time = lrs_timer.timeit(number=5)
        lrs_nash = self.game.obtain_Nash(algorithm='lrs')
        return lrs_time, lrs_nash

    @fork
    def LCP_timing(self):
        LCP_timer = Timer(lambda: self.game.obtain_Nash(algorithm='LCP'))
        LCP_time = LCP_timer.timeit(number=5)
        LCP_nash = self.game.obtain_Nash(algorithm='LCP')
        return LCP_time, LCP_nash

    @fork
    def enum_timing(self):
        enum_timer = Timer(lambda: self.game.obtain_Nash(algorithm='enumeration'))
        enum_time = enum_timer.timeit(number=5)
        enum_nash = self.game.obtain_Nash(algorithm='enumeration')
        return enum_time, enum_nash

    def return_data(self):

        # pool = Pool()
        # lrs_out = pool.apply_async(self.lrs_timing)
        # LCP_out = pool.apply_async(self.LCP_timeing)
        # enum_out = pool.apply_async(self.enum_timing)
        # lrs_time, lrs_nash = lrs_out.get()
        # LCP_time, LCP_nash = LCP_out.get()
        # enum_time, enum_nash = enum_out.get()

        lrs_time, lrs_nash = self.lrs_timing()
        LCP_time, LCP_nash = self.LCP_timing()
        enum_time, enum_nash = self.enum_timing()

        date = time.strftime("%d/%m/%Y")
        tim = time.strftime("%H:%M:%S")
        dimensions = (self.cols, self.rows)
        ring  = self.ring
        matrix1 = list(self.A)
        matrix2 = list(self.B)
        return [date, tim, dimensions, ring, matrix1, matrix2, lrs_time, LCP_time, enum_time, lrs_nash, LCP_nash, enum_nash]


Game = Analysis()

logFile = open("log.csv", 'wb')
wr = csv.writer(logFile)
wr.writerow(Game.return_data())
