import sys


source = sys.argv[1]
dest = sys.argv[2]

inFile = open(source)

line = inFile.readlines()[0]

commaSep = line.strip().strip("[").strip("]")
distortedJSONS = commaSep.split("},{")
for i in range(len(distortedJSONS)):
    if (i != 0):
        distortedJSONS[i] =  '{' + distortedJSONS[i] 
    if (i != len(distortedJSONS) - 1):
        distortedJSONS[i] += '}'
inFile.close()
out = open(dest, "w")
for JSON in distortedJSONS:
    out.write(JSON + "\n")
	