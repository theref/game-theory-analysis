import csv


# [date, tim, dimensions, ring, matrix1, matrix2, lrs_time, LCP_time, enum_time, lrs_nash, LCP_nash, enum_nash, host]
# row[0] = Date
# row[1] = Time
# row[2] = Dimensions of matrices
# row[3] = Ring of matrices
# row[4] = Player1 Matrix
# row[5] = Player2 Matrix
# row[6] = Time taken by lrs
# row[7] = Time taken by LCP
# row[8] = Time taken by enumeration
# row[9] = Output for lrs
# row[10] = Output for LCP
# row[11] = Output for enumeration
# row[12] = host

GAlist = []


def build_game_analysis(data):
    size = prod(eval(data[2]))

    GA = GameAnalysis(size)
    GAlist.append(GA)


class GameAnalysis():
    def __init__(self, size):
        self.size = size

with open('log.csv', 'rb') as logFile:
    logreader = csv.reader(logFile)
    for row in logreader:
        build_game_analysis(row)
