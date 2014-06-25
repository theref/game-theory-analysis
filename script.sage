import random
from sage.rings.all import ZZ, QQ
import csv
from timeit import Timer
import time
import socket

N = 10000
maxmatrixsize = 5
num_bound = 100
den_bound = 10
x = -100
y = 100
timerepetitions = 5

names = {'m015.maths.cf.ac.uk': 'Juliet',
         'james-desktop': 'Msc Lab',
         'Jamess-MacBook-Air.local': 'James Air'}

host = names[socket.gethostname()]


class Analysis():

    def __init__(self, k):
        set_random_seed(k)
        random.seed(k)
        self.ring = random.choice([ZZ, QQ])
        self.cols = random.randint(2, maxmatrixsize)
        self.rows = random.randint(2, maxmatrixsize)
        if self.ring == QQ:
            self.A = random_matrix(QQ, self.rows, self.cols, num_bound=num_bound, den_bound=den_bound)
            self.B = random_matrix(QQ, self.rows, self.cols, num_bound=num_bound, den_bound=den_bound)
        if self.ring == ZZ:
            self.A = random_matrix(ZZ, self.rows, self.cols, x=x, y=y)
            self.B = random_matrix(ZZ, self.rows, self.cols, x=x, y=y)

        self.game = NormalFormGame([self.A, self.B])

    def convert_to_float(self, old):
        new = []
        for solution in old:
            new_solution = []
            for vector in solution:
                new_vector = tuple([float(i) for i in vector])
                new_solution.append(new_vector)
            new.append(new_solution)
        return new

    def lrs_timing(self):
        lrs_timer = Timer(lambda: self.game.obtain_Nash(algorithm='lrs'))
        lrs_time = lrs_timer.timeit(number=timerepetitions)
        lrs_bad = self.game.obtain_Nash(algorithm='lrs')
        lrs_nash = self.convert_to_float(lrs_bad)
        return lrs_time, lrs_nash

    def LCP_timing(self):
        LCP_timer = Timer(lambda: self.game.obtain_Nash(algorithm='LCP'))
        LCP_time = LCP_timer.timeit(number=timerepetitions)
        LCP_bad = self.game.obtain_Nash(algorithm='LCP')
        LCP_nash = self.convert_to_float(LCP_bad)
        return LCP_time, LCP_nash

    def enum_timing(self):
        enum_timer = Timer(lambda: self.game.obtain_Nash(algorithm='enumeration'))
        enum_time = enum_timer.timeit(number=timerepetitions)
        enum_bad = self.game.obtain_Nash(algorithm='enumeration')
        enum_nash = self.convert_to_float(enum_bad)
        return enum_time, enum_nash

    def return_data(self):

        lrs_time, lrs_nash = self.lrs_timing()
        LCP_time, LCP_nash = self.LCP_timing()
        enum_time, enum_nash = self.enum_timing()

        date = time.strftime("%d/%m/%Y")
        tim = time.strftime("%H:%M:%S")
        dimensions = (self.cols, self.rows)
        ring = self.ring
        matrix1 = list(self.A)
        matrix2 = list(self.B)
        return [date, tim, dimensions, ring, matrix1, matrix2, lrs_time, LCP_time, enum_time, lrs_nash, LCP_nash, enum_nash, host]


@parallel
def instance(k):
    Game = Analysis(k)
    return Game.return_data()

r = instance([k for  k in range(N)])
for result in r:
    result = list(result[1])
    logFile = open("log.csv", 'a')
    wr = csv.writer(logFile)
    wr.writerow(result)
    logFile.close()
