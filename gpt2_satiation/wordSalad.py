import sys, random

source = sys.argv[1]
input = open(source)
sentences = input.readlines()
random.shuffle(sentences
)
for num in [0 10 20 30]:
    salads = set(random.sample(sentences, num))
    dataset = list(set(sentences).difference(salads))
    out = "datasets/gen_sets/" + source.strip().strip(".txt").strip("datasets/gen_sets") + f'_{num}_WS.txt'
    output = open(out, "w")
    for sentence in salads:
        words = sentence.strip().split()
        words.pop(-1)
        random.shuffle(words)
        salad = ' '.join([word for word in words])
        salad += " ?\n"
        dataset.append(salad)
    random.shuffle(dataset)
    for salad in dataset:
        output.write(salad)
    output.close()
input.close()
