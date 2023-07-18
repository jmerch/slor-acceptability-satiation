library(dplyr) 
install.packages("tidyr")
library(tidyr)

df = read.csv("data/Sprouse2013/Sprouse2013_surprisals.csv")
acceptability = readRDS(file="data/Sprouse2013/Sprouse2013.rds")
print(df[nrow(df),])
print(nrow(df))
print(nrow(acceptability))

for (i in 1:nrow(acceptability)){
  df$mean_acc = acceptability$mean_acc
}

write.csv(df, "data/Sprouse2013/Sprouse2013Ratings.csv", row.names=FALSE)

################### Plot #########################
library(ggplot2)
install.packages("tidyverse")
library(tidyverse)
library(ggthemes)

plot = df %>%
  ggplot((aes(x = mean_surprisal, y= mean_acc))) +
  geom_point() +
  geom_smooth(method = "lm", se=FALSE) +
  labs(title = "Sprouse 2013 Mean Acceptability and Surprisal", 
       x = "Mean Surprisal", 
       y = "Mean Acceptability") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text())
plot
ggsave(filename = "sprouse2013_mean_surp.png", path='plots/Sprouse2013')
