import csv
import matplotlib.pyplot as plt
from ast import literal_eval

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
    date = data[0]
    time = data[1]
    ring = data[3]
    size = prod(literal_eval(data[2]))
    lrs_time = literal_eval(data[6])
    LCP_time = literal_eval(data[7])
    enum_time = literal_eval(data[8])
    lrs_output = literal_eval(data[9])
    LCP_output = literal_eval(data[10])
    enum_output = literal_eval(data[11])
    host = data[12]
    GA = GameAnalysis(date, time, size, lrs_time, LCP_time, enum_time, ring, lrs_output, LCP_output, enum_output, host)
    GAlist.append(GA)


def create_graph(data):
    lrs_list = [(ga.size, ga.lrs_time) for ga in data]
    LCP_list = [(ga.size, ga.LCP_time) for ga in data]
    enum_list = [(ga.size, ga.enum_time) for ga in data]
    lrs_plot = list_plot(lrs_list, color='red', legend_label='lrs', legend_color='red')
    LCP_plot = list_plot(LCP_list, color='blue', legend_label='LCP', legend_color='blue')
    enum_plot = list_plot(enum_list, color='green', legend_label='enum', legend_color='green')
    return lrs_plot, LCP_plot, enum_plot


def integer_plot():
    int_data = []
    for i in GAlist:
        if i.ring == 'Integer Ring':
            int_data.append(i)
    lrs_plot, LCP_plot, enum_plot = create_graph(int_data)
    total_title = text('Run time (seconds) versus problem\n size (m x n) for Integer games', (15, 15))
    minusenum_title = text('Run time (seconds) versus problem\n size (m x n) for Integer games', (15, 0.4))
    minusenum = lrs_plot + LCP_plot + minusenum_title
    total_plot = lrs_plot + LCP_plot + enum_plot + total_title
    total_plot.axes_labels(['Size of Matrix(m x n)', 'Time (s)'])
    minusenum.axes_labels(['Size of Matrix(m x n)', 'Time (s)'])
    minusenum.save('plots/integer_lrs_and_LCP.png')
    total_plot.save('plots/integer_total_plot.png')


def rational_plot():
    rational_data = []
    for i in GAlist:
        if i.ring == 'Rational Field':
            rational_data.append(i)
    lrs_plot, LCP_plot, enum_plot = create_graph(rational_data)
    total_title = text('Run time (seconds) versus problem\n size (m x n) for Rational games', (15, 15))
    minusenum_title = text('Run time (seconds) versus problem\n size (m x n) for Rational games', (15, 0.4))
    minusenum = lrs_plot + LCP_plot + minusenum_title
    total_plot = lrs_plot + LCP_plot + enum_plot + total_title
    total_plot.axes_labels(['Size of Matrix(m x n)', 'Time (s)'])
    minusenum.axes_labels(['Size of Matrix(m x n)', 'Time (s)'])
    minusenum.save('plots/rational_lrs_and_LCP.png')
    total_plot.save('plots/rational_total_plot.png')


def all_plot():
    all_data = []
    for i in GAlist:
        all_data.append(i)
    lrs_plot, LCP_plot, enum_plot = create_graph(all_data)
    total_title = text('Run time (seconds) versus problem\n size (m x n) for All games', (15, 15))
    minusenum_title = text('Run time (seconds) versus problem\n size (m x n) for All games', (15, 0.4))
    minusenum = lrs_plot + LCP_plot + minusenum_title
    total_plot = lrs_plot + LCP_plot + enum_plot + total_title
    total_plot.axes_labels(['Size of Matrix(m x n)', 'Time (s)'])
    minusenum.axes_labels(['Size of Matrix(m x n)', 'Time (s)'])
    minusenum.save('plots/all_lrs_and_LCP.png')
    total_plot.save('plots/all_total_plot.png')


def size_histogram():
    sizes = [i.size for i in GAlist]
    number_of_sizes = max(sizes) - 4
    plt.hist(sizes, bins=number_of_sizes)
    plt.xlabel('Size of matrices')
    plt.ylabel('Frequency')
    plt.title(r'Histogram of Size of Matrices')
    plt.savefig('plots/Histogram.png')
    plt.close()


def vectors_the_same(game):
    if len(game.lrs_output) == len(game.LCP_output) == len(game.enum_output):
        return True
    else:
        return False


class GameAnalysis():
    def __init__(self, date, time, size, lrs_time, LCP_time, enum_time, ring, lrs_output, LCP_output, enum_output, host):
        self.date = date
        self.time = time
        self.size = size
        self.lrs_time = lrs_time
        self.LCP_time = LCP_time
        self.enum_time = enum_time
        self.ring = ring
        self.lrs_output = lrs_output
        self.LCP_output = LCP_output
        self.enum_output = enum_output
        self.host = host

with open('log.csv', 'rb') as logFile:
    logreader = csv.reader(logFile)
    for row in logreader:
        build_game_analysis(row)

all_plot()
rational_plot()
integer_plot()
size_histogram()
print "Number of Games: %s" % len(GAlist)

for i, v in enumerate(GAlist, start=1):
    if not vectors_the_same(v):
        date = v.date
        time = v.time
        host = v.host
        lrs = len(v.lrs_output)
        LCP = len(v.LCP_output)
        enum = len(v.enum_output)
        print "%s, %s, %s, Line %s, Lrs: %s, LCP: %s, Enum: %s" % (host, date, time, i, lrs, LCP, enum)
