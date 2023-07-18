library(dplyr) 
install.packages("tidyr")
library(tidyr)

df = read.csv("data/Sprouse2013/Sprouse2013_surprisals.csv")
acceptability = readRDS(file="data/Sprouse2013/Sprouse2013.rds")
print(df[nrow(df),])
print(nrow(df))
print(acceptability[nrow(acceptability),])

for (i in 1:nrow(acceptability)){
  df$mean_acceptability = acceptability$mean_acc
}

write.csv(df, "data/Sprouse2013/Sprouse2013Ratings.csv", row.names=FALSE)

##### checking that results are lined up -- ignore #######
# mean surprisal of first sentence of dativebase
print(mean(c(14.146384239196777, 14.315942764282227, 3.8838701248168945, 12.754701614379883, 2.0852227210998535, 11.678030729293823, 4.0954203605651855, 11.75735092163086, 14.150141716003418, 9.729240417480469, 7.5328145027160645, 8.44174575805664, 9.425204277038574)))
# mean surprisal of first sentence of locativeresults
print(mean(c(15.30359935760498, 18.002038955688477, 3.3711812496185303, 14.97891902923584, 3.243788480758667, 7.317869663238525, 1.3850141763687134, 19.829740524291992, 11.101941108703613, 8.542166709899902, 7.169226169586182, 8.012426376342773, 10.581880569458008)))
