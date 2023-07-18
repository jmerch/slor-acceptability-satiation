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
materials_bad$condition = "bad"
#print(materials_bad)

# Reads and formats good sentences
materials_good = read_excel(materials_path, col_names=FALSE)
materials_good = materials_good[-(1:4),(5:6)]
colnames(materials_good) <- c("ID", "sentence_string")
materials_good$condition = "good"
#print(materials_good)

# add together
materials = rbind(materials_bad, materials_good)
print(nrow(materials)) #2698

# create SurpIn file
materials = filter(materials, sentence_string != "NA")
print(nrow(materials)) #2400 unique sentences
for (i in 1:nrow(materials)){
  if (substr(materials$sentence_string[i], nchar(materials$sentence_string[i]), nchar(materials$sentence_string[i])) != "?" & substr(materials$sentence_string[i], nchar(materials$sentence_string[i]), nchar(materials$sentence_string[i])) != "." & substr(materials$sentence_string[i], nchar(materials$sentence_string[i]), nchar(materials$sentence_string[i])) != "!"){
    print(materials$sentence_string[i])
    materials$sentence_string[i] = paste(materials$sentence_string[i], ".", sep="")
  }

  materials$sentence_string[i] = gsub('Mrs.','Mrs',materials$sentence_string[i])
  materials$sentence_string[i] = gsub('Prof.','Prof',materials$sentence_string[i])
  materials$sentence_string[i] = gsub('Ms.','Ms',materials$sentence_string[i])
  materials$sentence_string[i] = gsub('Dr.','Dr',materials$sentence_string[i])
  materials$sentence_string[i] = gsub('a\\.m\\.','am',materials$sentence_string[i])
  materials$sentence_string[i] = gsub('9 p\\.m\\.','9 pm.',materials$sentence_string[i])
  materials$sentence_string[i] = gsub('p\\.m\\.','pm',materials$sentence_string[i])

  materials$sentence_string[i] = gsub('\\.', ' .', materials$sentence_string[i])
  materials$sentence_string[i] = gsub('\\?', ' ?', materials$sentence_string[i])
  materials$sentence_string[i] = gsub('“', '" ', materials$sentence_string[i])
  materials$sentence_string[i] = gsub('”', ' "', materials$sentence_string[i])
  materials$sentence_string[i] = gsub(',',' ,', materials$sentence_string[i])
  materials$sentence_string[i] = gsub('\\!',' !', materials$sentence_string[i])
  materials$sentence_string[i] = gsub('’',"'",materials$sentence_string[i])
  materials$sentence_string[i] = gsub('  ',' ',materials$sentence_string[i])
  materials$sentence_string[i] = gsub('Mr .','Mr',materials$sentence_string[i])
}
#print(materials,n=1000)
# 
# sentence = "hello im lian!"
# print(substr(sentence, nchar(sentence), nchar(sentence)) != "!")
# print(substr(sentence, nchar(sentence), nchar(sentence)))
# TRUE | TRUE
# substr(sentence, nchar(sentence), nchar(sentence)) != "." | TRUE
# if (substr(sentence, nchar(sentence), nchar(sentence)) != "?" & substr(sentence, nchar(sentence), nchar(sentence)) != "." & substr(sentence, nchar(sentence), nchar(sentence)) != "!"){
#   sentence = paste(sentence, ".", sep="")
# }
# print(sentence)

# Read results
results = read.csv(results_path, skip=5)
results = results[, (4:6)]
print(nrow(results)) #30400
results = filter(results, judgment != "NA")
print(nrow(results)) # 30338

results_unique = results %>% # creates results df with mean acceptability
  group_by(item) %>%
  summarize(
    mean_acc = mean(judgment)
  )
print(nrow(results_unique)) #2384

#print(results_unique[results_unique$item == materials$ID[1],]$mean_acc)
#print(typeof(results_unique[results_unique$item == materials$ID[1],]$mean_acc))
#print(typeof(materials[1,]$ID))

#print(typeof(results_unique[results_unique$item == "34.1.phillips.67d.*.02",]$mean_acc))

# Now we need to produce 1) a list of unique sentences separated by "!ARTICLE" to calculate the mean surprisal, then add that to our data frame, writing it all as a csv
sentences = c()
results_unique$sentence_string = ""
filtered_out = filter(results_unique, !(results_unique$item %in% materials$ID))
#print(filtered_out, n=200)
results_unique = filter(results_unique, results_unique$item %in% materials$ID) # only keep the results that has a corresponding ID in materials (temporarily, can manually fix)
print(nrow(results_unique)) # 2232
print(results_unique[nrow(results_unique),])

for (i in 1:nrow(results_unique)){
  #store sentence string corresponding to id into results_unique dataframe
  results_unique$sentence_string[i] <- materials[materials$ID == results_unique$item[i],]$sentence_string
  
  sentences = c(sentences, "!ARTICLE")
  sentences = c(sentences, results_unique$sentence_string[i])
}
print(length(sentences)) #4464: indicates that there are the same number of sentences in SurpIn as there are judgments for (a given by design). So the issue with too many sentences must happen at the next stage (surprisal.py)

# check for sentences that contain . or ? at the non-sentence final position
for (i in 1:nrow(results_unique)){
  string = results_unique$sentence_string[i]
  if (grepl("?", substr(string, 1, nchar(string) - 1), fixed = TRUE) | grepl(".", substr(string, 1, nchar(string) - 1), fixed = TRUE))
    print(string)
}

#print(materials[materials$ID == results_unique$item[1],]$sentence_string)
#print(results_unique$mean_acc[1])

# for (i in 1:nrow(materials)){
#   sentences = c(sentences, "!ARTICLE")
#   sentences = c(sentences, materials$sentence_string[i])
#   
#   #materials$mean_acc[i] = results_unique_dict[materials$ID[i]]
#   materials[i,]$mean_acc = results_unique[results_unique$item == materials$ID[i],]$mean_acc
# }
print(results_unique[1674,])

print(mean(c(10.95219612121582, 7.393104553222656, 8.415366172790527, 6.347735404968262, 4.938467979431152, 9.6925630569458, 9.4517822265625, 3.4975271224975586, 8.08668041229248, 15.6852388381958, 12.950498580932617)))

saveRDS(results_unique, file = paste("data/Sprouse2013/Sprouse2013.rds", sep=""))
filePath = file("data/Sprouse2013/Sprouse2013SurpIn.txt")
writeLines(sentences, filePath)
close(filePath)
