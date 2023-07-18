library(tidyverse)
library(ggplot2)
library(ggthemes)

adapt = read.csv("data/adaptContextRatings.csv")
gen = read.csv("data/genContextRatings.csv")
all = rbind(adapt, gen)
islands = filter(all, condition %in% c("CNPC", "SUBJ", "WH"))
plot = all %>%
  ggplot((aes(x = mean_surprisal, y= all_exposures))) +
  geom_point(aes(color = condition)) +
  geom_smooth(method = "lm", se=FALSE) +
  labs(title = "Mean Acceptability and Surprisal", 
       x = "Mean Surprisal", 
       y = "Mean Acceptability") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text())
plot

plot = all %>%
  ggplot((aes(x = normalized, y= all_exposures))) +
  geom_point(aes(color = condition)) +
  geom_smooth(method = "lm", se=FALSE) +
  labs(title = "Mean Acceptability and Surprisal", 
       x = "Normalized Surprisal", 
       y = "Mean Acceptability") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text())
plot

plot = islands %>%
  ggplot((aes(x = gap, y= all_exposures))) +
  geom_point(aes(color = condition)) +
  geom_smooth(method = "lm", se=FALSE) +
  labs(title = "Mean Acceptability and Surprisal", 
       x = "Post Gap Surprisal", 
       y = "Mean Acceptability") +
  xlim(0, 30) + 
  ylim(0, 1) + 
  theme_fivethirtyeight() +
  theme(axis.title = element_text())
plot

plot = islands %>%
  ggplot((aes(x = gap, y= all_exposures, group = condition, color = condition))) +
  geom_point(aes(color = condition)) +
  geom_smooth(method = "lm") +
  labs(title = "Mean Acceptability and Surprisal", 
       x = "Post Gap Surprisal", 
       y = "Mean Acceptability") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text())
plot


test = filter(islands, condition %in% c("WH", "CNPC"))