# This script reads data in the format of Sprouse (excel files)

# First, read csv data into R Data Frame
library(dplyr)
install.packages("readxl")
library("readxl")

materials_path = "data/Sprouse2013/SSA.Materials.xlsx"
results_path = "data/Sprouse2013/LS experiment/LI.ls.results.csv"

# Reads and formats bad sentences
materials_bad = read_excel(materials_path)
materials_bad <- materials_bad[-(1:3),(1:2)]
colnames(materials_bad) <- c("ID", "sentence_string")
print(materials_bad)

# Reads and formats good sentences
materials_good = read_excel(materials_path, col_names=FALSE)
materials_good = materials_good[-(1:4),(5:6)]
colnames(materials_good) <- c("ID", "sentence_string")
print(materials_good)

# add together
materials = rbind(materials_bad, materials_good)
print(materials)

# now read judgment results (not strictly necessary, just in case we want to put in acceptability later in too)
results = read.csv(results_path, skip=5)
results = results[, (4:6)]
print(results)

# create SurpIn file
filter(materials, sentence_string != "NA")
for (i in 1:nrow(materials)){
  materials$sentence_string[i] = gsub('.', ' .', materials$sentence_string[i])
}

# saves data frame object, to be modified once we have the surprisal calculations
# saveRDS(df_unique, file = paste("data/lu_kim_2022/", data_name, ".rds", sep=""))

# Now we need to produce 1) a list of unique sentences separated by "!ARTICLE" to calculate the mean surprisal, then add that to our data frame, writing it all as a csv
sentences = c()
for (string in materials$sentence_string){
  sentences = c(sentences, "!ARTICLE")
  sentences = c(sentences, string)
}

filePath = file("data/Sprouse2013SurpIn.txt")
writeLines(sentences, filePath)
close(filePath)
