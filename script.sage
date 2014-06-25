import random
from sage.rings.all import ZZ, QQ
import csv
from timeit import Timer
import time


class Analysis():

    def __init__(self):
        self.cols = random.randint(1, 5)
        self.rows = random.randint(1, 5)
        self.A = random_matrix(QQ, self.rows, self.cols)
        self.B = random_matrix(QQ, self.rows, self.cols)
        self.game = NormalFormGame([self.A, self.B])

Game = Analysis()

lrs_timer = Timer(lambda: Game.game.obtain_Nash(algorithm='lrs'))
LCP_timer = Timer(lambda: Game.game.obtain_Nash(algorithm='LCP'))
enum_timer = Timer(lambda: Game.game.obtain_Nash(algorithm='enumeration'))
lrs_time = lrs_timer.timeit(number=5)
LCP_time = LCP_timer.timeit(number=5)
enum_time = enum_timer.timeit(number=5)

lrs_nash = Game.game.obtain_Nash(algorithm='lrs')
LCP_nash = Game.game.obtain_Nash(algorithm='LCP')
enum_nash = Game.game.obtain_Nash(algorithm='enumeration')

date = time.strftime("%d/%m/%Y")
time = time.strftime("%H:%M:%S")
dimensions = (Game.cols, Game.rows)
matrix1 = list(Game.A)
matrix2 = list(Game.B)

DATA = [date, time, dimensions, matrix1, matrix2, lrs_time, LCP_time, enum_time, lrs_nash, LCP_nash, enum_nash]

logFile = open("log.csv",'wb')
wr = csv.writer(logFile)
wr.writerow(DATA)
