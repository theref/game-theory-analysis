#!/usr/bin/env python
"""
Script to analyse the log.csv file.
"""
from __future__ import division
from csv import reader, writer
import matplotlib.pyplot as plt
from scipy import mean

class Instance():
    """
    A row of data
    """
    def __init__(self, date, time, dim, ring, A, B, lrs_time, LCP_time, enum_time, lrs_output, LCP_output, enum_output, host):
        self.date = date
        self.time = time
        self.ring = ring
        self.dim = eval(dim)
        self.size = self.dim[0] * self.dim[1]
        self.lrs_time = eval(lrs_time)
        self.LCP_time = eval(LCP_time)
        self.enum_time = eval(enum_time)
        self.lrs_output = eval(lrs_output)
        self.LCP_output = eval(LCP_output)
        self.enum_output = eval(enum_output)
        self.host = host
        self.A = A
        self.B = B
        self.agree = len(self.enum_output) == len(self.LCP_output) == len(self.lrs_output)
        self.best_time = min(self.lrs_time, self.LCP_time, self.enum_time)

if __name__ == '__main__':
    from sys import argv

    logfile = 'log.csv'
    if len(argv) > 1:
        logfile = argv[1]

    log_of_data = {}
    data = []
    for row in reader(open(logfile, 'r')):
        if (row[4], row[5]) not in log_of_data:
            try:
                data.append(Instance(*row))
                log_of_data[(row[4], row[5])] = 1
            except:
                pass

    sizes = range(min([row.size for row in data]), max([row.size for row in data]) + 1)
    hosts = list(set([instance.host for instance in data]))


    # plot box plot for time against size for lrs

    plt.figure()
    plt.boxplot([[instance.lrs_time for instance in data if instance.size == k] for k in sizes])
    plt.xticks(range(min(sizes), max(sizes) + 1, 5))
    plt.ylabel('time (s)')
    plt.title("time against size (lrs)")
    plt.savefig('./plots/vk/time_against_size_lrs.png')

    # plot box plot for time against size for LCP

    plt.figure()
    plt.boxplot([[instance.LCP_time for instance in data if instance.size == k] for k in sizes])
    plt.xticks(range(min(sizes), max(sizes) + 1, 5))
    plt.ylabel('time (s)')
    plt.title("time against size (LCP)")
    plt.savefig('./plots/vk/time_against_size_LCP.png')

    # plot box plot for time against size for enumeration

    plt.figure()
    plt.boxplot([[instance.enum_time for instance in data if instance.size == k] for k in sizes])
    plt.xticks(range(min(sizes), max(sizes) + 1, 5))
    plt.ylabel('time (s)')
    plt.title("time against size (enum)")
    plt.savefig('./plots/vk/time_against_size_enum.png')

    # plot box plot for time against approach (for all approaches)

    plt.figure()
    plt.boxplot([[instance.lrs_time for instance in data],
                 [instance.LCP_time for instance in data],
                 [instance.enum_time for instance in data]])
    plt.xticks([1,2,3], ['lrs', 'lcp', 'enumeration'])
    plt.ylabel('time (s)')
    plt.title("time against approach")
    plt.savefig('./plots/vk/time_against_approach.png')

    # Plot box plot for time against approach (Ignoring enumeration)

    plt.figure()
    plt.boxplot([[instance.lrs_time for instance in data],
                 [instance.LCP_time for instance in data]])
    plt.xticks([1,2], ['lrs', 'LCP'])
    plt.ylabel('Time (s)')
    plt.title("Time against approach")
    plt.savefig('./plots/vk/time_against_approach_without_enumeration.png')

    # Time / size box plot against approach

    plt.figure()
    plt.boxplot([[instance.lrs_time / instance.size for instance in data],
                 [instance.LCP_time / instance.size for instance in data]])
    plt.xticks([1,2], ['lrs', 'LCP'])
    plt.ylabel('Time / size (s/dim)')
    plt.title("Time / size against approach")
    plt.savefig('./plots/vk/time_over_size_against_approach_without_enumeration.png')

    # Time / size ^ 2 box plot against approach

    plt.figure()
    plt.boxplot([[instance.lrs_time / (instance.size ** 2) for instance in data],
                 [instance.LCP_time / (instance.size ** 2) for instance in data]])
    plt.xticks([1,2], ['lrs', 'LCP'])
    plt.ylabel('Time / size ^ 2 (s/dim ^ 2)')
    plt.title("Time / size ^ 2 against approach")
    plt.savefig('./plots/vk/time_over_size_squared_against_approach_without_enumeration.png')

    # Size box plot against host

    plt.figure()
    plt.boxplot([[instance.size for instance in data if instance.host == h] for h in hosts])
    plt.xticks(range(1, len(hosts) + 1), hosts)
    plt.ylabel('Size')
    plt.title("Size against host")
    plt.savefig('./plots/vk/size_against_host.png')

    # Min time box plot against host

    plt.figure()
    plt.boxplot([[instance.best_time for instance in data if instance.host == h] for h in hosts])
    plt.xticks(range(1, len(hosts) + 1), hosts)
    plt.ylabel('Time (s)')
    plt.title("Best time against host")
    plt.savefig('./plots/vk/best_time_against_host.png')

    # Min time / size box plot against host

    plt.figure()
    plt.boxplot([[instance.best_time / instance.size for instance in data if instance.host == h] for h in hosts])
    plt.xticks(range(1, len(hosts) + 1), hosts)
    plt.ylabel('Time / size (s/dim)')
    plt.title("Best time / size against host")
    plt.savefig('./plots/vk/best_time_over_size_against_host.png')

    # Min time / size ^ 2 box plot against host

    plt.figure()
    plt.boxplot([[instance.best_time / (instance.size ** 2) for instance in data if instance.host == h] for h in hosts])
    plt.xticks(range(1, len(hosts) + 1), hosts)
    plt.ylabel('Time / size ^ 2 (s/dim ^ 2)')
    plt.title("Best time / size ^ 2 against host")
    plt.savefig('./plots/vk/best_time_over_size_squared_against_host.png')

    # Number of equilibria against size of game (for games that agree)

    plt.figure()
    plt.boxplot([[len(instance.LCP_output) for instance in data if instance.agree and instance.size == k] for k in sizes])
    plt.xticks(range(min(sizes), max(sizes) + 1, 5))
    plt.ylabel('Number of equilibria')
    plt.title("Number of equilibria against size")
    plt.savefig('./plots/vk/number_of_equilibria_against_size.png')

    # Distribution of number of equilibria

    plt.figure()
    plt.hist([len(instance.LCP_output) for instance in data if instance.agree])
    plt.legend()
    plt.ylabel('Frequency')
    plt.title("Number of equilibria")
    plt.savefig('./plots/vk/number_of_equilibria_distribution.png')

    # Distribution of size by host

    plt.figure()
    plt.hist([[instance.size for instance in data if instance.host == h] for h in hosts], normed=True, label=["%s (N=%s)" % (h, len([instance for instance in data if instance.host == h])) for h in hosts])
    plt.legend()
    plt.ylabel('Frequency')
    plt.title("Size")
    plt.savefig('./plots/vk/size_distribution_by_host.png')

    # Distribution of best_time by host

    plt.figure()
    plt.hist([[instance.best_time for instance in data if instance.host == h] for h in hosts], normed=True, label=["%s (N=%s)" % (h, len([instance for instance in data if instance.host == h])) for h in hosts])
    plt.legend()
    plt.ylabel('Frequency')
    plt.title("Best time")
    plt.savefig('./plots/vk/best_time_per_instance_distribution_by_host.png')

    # Distribution of best_time / size by host

    plt.figure()
    plt.hist([[instance.best_time / instance.size for instance in data if instance.host == h] for h in hosts], normed=True, label=["%s (N=%s)" % (h, len([instance for instance in data if instance.host == h])) for h in hosts])
    plt.legend()
    plt.ylabel('Probability')
    plt.title("Best time / size")
    plt.savefig('./plots/vk/best_time_over_size_per_instance_distribution_by_host.png')

    # Distribution of best_time / size ^ 2 by host

    plt.figure()
    plt.hist([[instance.best_time / instance.size for instance in data if instance.host == h] for h in hosts], normed=True, label=["%s (N=%s)" % (h, len([instance for instance in data if instance.host == h])) for h in hosts])
    plt.legend()
    plt.ylabel('Probability')
    plt.title("Best time / size ^ 2")
    plt.savefig('./plots/vk/best_time_over_size_squared_per_instance_distribution_by_host.png')

    # Get dimensions for heat maps

    maxm = max([instance.dim[0] for instance in data])
    minm = min([instance.dim[0] for instance in data])
    maxn = max([instance.dim[1] for instance in data])
    minn = min([instance.dim[1] for instance in data])

    # Heat map of number by dimensions

    number = []
    for m in range(minm, maxm + 1):
        row = []
        for n in range(minn, maxn + 1):
            row.append(len([instance for instance in data if instance.dim == (m, n)]))
        number.append(row)
    plt.figure()
    plt.imshow(number, aspect='auto', cmap='summer')
    plt.colorbar()
    plt.ylabel('$m$')
    plt.xlabel('$n$')
    plt.title("Number of instances")
    plt.savefig('./plots/vk/number_of_instances.png')

    # Heat map of mean number of equilibria by dimensions

    number = []
    for m in range(minm, maxm + 1):
        row = []
        for n in range(minn, maxn + 1):
            row.append(mean([len(instance.LCP_output) for instance in data if instance.dim == (m, n) and instance.agree]))
        number.append(row)
    plt.figure()
    plt.imshow(number, aspect='auto', cmap='summer')
    plt.colorbar()
    plt.ylabel('$m$')
    plt.xlabel('$n$')
    plt.title("Mean number of equilibria")
    plt.savefig('./plots/vk/number_of_equilibria.png')


    # Heat map of mean best time by dimensions

    number = []
    for m in range(minm, maxm + 1):
        row = []
        for n in range(minn, maxn + 1):
            row.append(mean([instance.best_time for instance in data if instance.dim == (m, n) and instance.agree]))
        number.append(row)
    plt.figure()
    plt.imshow(number, aspect='auto', cmap='summer')
    plt.colorbar()
    plt.ylabel('$m$')
    plt.xlabel('$n$')
    plt.title("Mean best time (s)")
    plt.savefig('./plots/vk/mean_best_time.png')

    # Printing number of games that fail

    print "%s of %s give discrepancies in the number of equilibria, these have been written to './plots/vk/fails.csv'" % (len([instance for instance in data if not instance.agree]), len(data))
    fails = open('./plots/vk/fails.csv', 'w')
    csvwrtr = writer(fails)
    for instance in [instance for instance in data if not instance.agree]:
        csvwrtr.writerow([instance.A, instance.B])
