library(dplyr) 

data_name = "locative_baseline_full"
df = readRDS(file = paste("data/lu_kim_2022/", data_name, ".rds", sep=""))
print(df)

print(nrow(df))

surprisals = read.csv(paste("data/lu_kim_2022/", "locative_baseline", "_surprisals.csv", sep=""))
print(nrow(surprisals))
print(surprisals[1, ])

df$mean_surprisal = surprisals$mean_surprisal
df$normalized_surprisal = surprisals$normalized
print(df)
print(nrow(df))

write.csv(df, paste("data/lu_kim_2022/", data_name, "Ratings.csv",sep=""), row.names=FALSE)
