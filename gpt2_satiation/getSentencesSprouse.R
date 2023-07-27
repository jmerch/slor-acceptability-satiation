library(dplyr)
#install.packages("readxl")
library("readxl")

NUM = 15

source = "gpt2_satiation/stimuli/sprouse2016Stim.xlsx"
dataset = paste("gpt2_satiation/datasets/sprouse2016_GRAM_test", NUM, ".txt", sep = "")

fillers = rbind(read_excel(source, sheet="Fillers 1"), read_excel(source, sheet="Fillers 2"), read_excel(source, sheet="Fillers 3"), read_excel(source, sheet="Fillers 4"))
fillers = filter(fillers, code %in% c("F.21.G","F.22.G","F.23.G","F.24.G","F.25.G","F.26.G","F.27.G","F.28.G","F.29.G","F.3.UG","F.30.G","F.31.G","F.32.G"))

random_sents = sample(fillers$sentence, NUM)

lines = c()
for (i in 1:length(random_sents)){
  lines = c(lines, "!ARTICLE")
  lines = c(lines, random_sents[i])
}
print(lines)

filePath = file(dataset)
writeLines(lines, filePath)
close(filePath)