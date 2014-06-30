import csv
import matplotlib.pyplot as plt
from ast import literal_eval as le


with open('oldtimings.csv', 'rb') as oldFile:
    oldtimings = csv.reader(oldFile)
    with open('newtimings.csv', 'rb') as newFile:
        newtimings = csv.reader(newFile)
        points = [(le(i[0]), le(i[1])/le(j[1])) for i, j in zip(oldtimings, newtimings)]

sizes = range(1, 30)

plt.figure()
plt.boxplot([[i[1] for i in points if i[0] == k] for k in sizes])
plt.xlim(xmin=10, xmax=30)
# plt.xticks(range(10, 30, 1))
plt.savefig('plots/ratio_box_plot.png')
