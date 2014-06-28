#!/usr/bin/env python
"""
Script to analyse the log.csv file.
"""
from __future__ import division
from csv import reader
import matplotlib.pyplot as plt

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

    data = [Instance(*row) for row in reader(open(logfile, 'r'))]
    sizes = range(min([row.size for row in data]), max([row.size for row in data]) + 1)
    hosts = list(set([instance.host for instance in data]))

    # Plot box plot for time against approach (for all approaches)

    plt.figure()
    plt.boxplot([[instance.lrs_time for instance in data],
                 [instance.LCP_time for instance in data],
                 [instance.enum_time for instance in data]])
    plt.xticks([1,2,3], ['lrs', 'LCP', 'enumeration'])
    plt.ylabel('Time (s)')
    plt.title("Time against approach")
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

    # Distribution of size by host

    plt.figure()
    plt.hist([[instance.size for instance in data if instance.host == h] for h in hosts], normed=True, label=["%s (N=%s)" % (h, len([instance for instance in data if instance.host == h])) for h in hosts])
    plt.legend()
    plt.ylabel('Probability')
    plt.title("Size")
    plt.savefig('./plots/vk/size_distribution_by_host.png')

    # Distribution of best_time by host

    plt.figure()
    plt.hist([[instance.best_time for instance in data if instance.host == h] for h in hosts], normed=True, label=["%s (N=%s)" % (h, len([instance for instance in data if instance.host == h])) for h in hosts])
    plt.legend()
    plt.ylabel('Probability')
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
