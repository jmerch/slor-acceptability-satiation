# This script reads data in the format of Lu & Kim (2022)


# First, read csv data into R Data Frame
library(dplyr)

# Data files for Lu and Kim: "dative", "dativebase", "locative_baseline_full", "locativeresults"
data_name = "dativebase"

source = paste("data/lu_kim_2022/", data_name, ".csv", sep="")

df = read.csv(source) # reads csv into a Data Frame, indexable by column name

# Produces a pared down data frame with just unique sentence ID, sentence string, acceptability for each individual response
df_subset = subset(df, select=c(4, 6, 10, 12))
colnames(df_subset) = c('sentence_id', 'condition', 'sentence_string', 'acceptability')
print(df_subset)

# Now, we want to create a data frame with entries corresponding to each unique sentence: (sentence_id, sentence_string, mean_acceptability)
df_unique = df_subset %>%
  group_by(sentence_id, sentence_string, condition) %>%
  summarize(
    mean_acc = mean(acceptability/7) # scale 7 point likert scale to 0-1
  )

# Cleans up data (sentence strings and condition names)
for (i in 1:nrow(df_unique)){ # replaces '%2C' with actual commas ','
  df_unique$sentence_string[i] = gsub('%2C','',df_unique$sentence_string[i])
  df_unique$sentence_string[i] = gsub('\\.',' .',df_unique$sentence_string[i])
  df_unique$sentence_string[i] = gsub(',','',df_unique$sentence_string[i])
  df_unique$sentence_string[i] = gsub('â€™','\'',df_unique$sentence_string[i])
  df_unique$sentence_string[i] = gsub('’','\'',df_unique$sentence_string[i])
  
  #df_unique$condition[i] = gsub('-', ' ', df_unique$condition[i])
  if (data_name == "dative" || data_name == "locativeresults"){
    df_unique$condition[i] = gsub('[12]', '', df_unique$condition[i]) 
    df_unique$condition[i] = paste(df_unique$condition[i], "-gap", sep="")
  } else if (data_name == "dativebase"){
    if (grepl("verb", df_unique$condition[i])){
      df_unique$condition[i] = gsub('verb', 'nogap', df_unique$condition[i])
    } else{
      df_unique$condition[i] = paste(df_unique$condition[i], "-gap", sep="")
    }
    df_unique$condition[i] = gsub('[12]', '', df_unique$condition[i])
  }
}

# saves data frame object, to be modified once we have the surprisal calculations
saveRDS(df_unique, file = paste("data/lu_kim_2022/", data_name, ".rds", sep=""))

# Now we need to produce 1) a list of unique sentences separated by "!ARTICLE" to calculate the mean surprisal, then add that to our data frame, writing it all as a csv
sentences = c()
for (string in df_unique$sentence_string){
  sentences = c(sentences, "!ARTICLE")
  sentences = c(sentences, string)
}

filePath = file(paste("data/lu_kim_2022/", data_name, "SurpIn.txt", sep=""))
writeLines(sentences, filePath)
close(filePath)
