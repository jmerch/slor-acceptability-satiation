import random
import sys

source = sys.argv[1]
island = sys.argv[2]
test_condition = sys.argv[3]

input = open(source)
lines = input.readlines()
random.shuffle(lines)

# create each set
train30 = lines
train20 = random.sample(lines, 20)
train10 = random.sample(lines, 10)
out = f'datasets/{island}_{30}_{test_condition}.txt'
out30 = open(out, "w")
for line in train30:
  out30.write(line + "\n")
out = f'datasets/{island}_{20}_{test_condition}.txt'
out20 = open(out, "w")
for line in train20:
  out20.write(line + "\n")
out = f'datasets/{island}_{10}_{test_condition}.txt'
out10 = open(out, "w")
for line in train10:
  out10.write(line + "\n")
