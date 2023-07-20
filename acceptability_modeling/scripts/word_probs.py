import math

freqs = open("../data/enwiki-2023-04-13.txt")
out = open("../data/individual_surprisals.txt", "w")

data = freqs.readlines()
clean_data = []

total_words = 0

surps = {}

for datum in data:
    pair = datum.strip().split(" ")
    freq = int(pair[1])
    total_words += freq
    surps[pair[0]] = freq
    
for word in surps:
    surps[word] = -1 * math.log2(surps[word] / total_words)
    #print(word + " : " + str(surps[word]))

surps["?"] = surps["the"]
surps["."] = surps["the"]

out.write(str(surps))
out.close()
    
