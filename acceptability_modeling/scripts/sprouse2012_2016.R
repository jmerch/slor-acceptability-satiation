library(tidyverse)
library(ggplot2)
library(ggthemes)

fillers = c("F.1.UG","F.10.UG","F.11.UG","F.12.UG","F.13.UG","F.14.UG","F.15.UG","F.16.UG","F.17.UG","F.18.UG","F.19.UG","F.2.UG","F.20.UG","F.21.G","F.22.G","F.23.G","F.24.G","F.25.G","F.26.G","F.27.G","F.28.G","F.29.G","F.3.UG","F.30.G","F.31.G","F.32.G","F.4.UG","F.5.UG","F.6.UG","F.7.UG","F.8.UG","F.9.UG")


#NOT USABLE
exp1_2012 = read.csv("data/Sprouse2012/SWP.EXP1.results.csv") %>%
  select(c("item", "condition", "raw.judgment", "structure")) %>%
  dplyr::rename(sentence_id = "item", response = "raw.judgment") %>%
  group_by(sentence_id, condition) %>%
  dplyr::summarize(mean_acc = mean(response))

#MAGNITUDE ESTIMATE
exp2_2012 = read.csv("data/Sprouse2012/SWP.EXP2.results.csv") %>%
  select(c("item", "condition", "raw.judgment")) %>%
  dplyr::rename(sentence_id = "item", response = "raw.judgment") %>%
  group_by(sentence_id, condition) %>%
  dplyr::summarize(mean_acc = mean(response))


exp1_2016 = read.csv("data/Sprouse2016/Experiment 1 results - English.csv") %>%
  select(c("item", "condition", "judgment", "structure", "distance", "dependency", "island")) %>%
  dplyr::rename(sentence_id = "item", response = "judgment") %>%
  group_by(sentence_id, condition, structure, distance, dependency, island) %>%
  dplyr::summarize(mean_acc = mean(response)) %>%
  arrange(sentence_id)
  
exp1_2016 = exp1_2016 %>%
  ungroup()
  
ids = 1:nrow(exp1_2016)
exp1_2016_IDs = select(exp1_2016, "condition")
exp1_2016_IDs$sentence_id = ids
exp1_2016_IDs = exp1_2016_IDs[c("sentence_id", "condition")]

write.csv( exp1_2016_IDs,"data/Sprouse2016/exp1ID_to_cond.csv", row.names=FALSE)

exp1_2016_surps = read.csv("data/Sprouse2016/exp1_surprisals.csv")
exp1_2016$mean_surprisal = exp1_2016_surps$mean_surprisal
exp1_2016$normalized = exp1_2016_surps$normalized
exp1_2016$beyond_5 = exp1_2016_surps$beyond_5
exp1_2016$beyond_6 = exp1_2016_surps$beyond_6
exp1_2016$beyond_7 = exp1_2016_surps$beyond_7
exp1_2016$beyond_8 = exp1_2016_surps$beyond_8
exp1_2016$beyond_9 = exp1_2016_surps$beyond_9
exp1_2016$gap = exp1_2016_surps$gap
exp1_2016$gap_norm = exp1_2016_surps$gap_norm

plot = exp1_2016 %>%
  ggplot((aes(x = mean_surprisal, y= mean_acc))) +
  geom_point() +
  geom_smooth(method = "lm", se=FALSE) +
  labs(title = "Sprouse 2016 Mean Acceptability and Surprisal", 
       x = "Mean Surprisal", 
       y = "Mean Acceptability") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text())
plot



exp3_2016 = read.csv("data/Sprouse2016/Experiment 3 results - English D-linking.csv") %>%
  select(c("item", "condition", "judgment", "structure", "distance", "dependency", "island")) %>%
  dplyr::rename(sentence_id = "item", response = "judgment") %>%
  group_by(sentence_id, condition, structure, distance, dependency, island) %>%
  dplyr::summarize(mean_acc = mean(response)) %>%
  arrange(sentence_id)

exp3_2016 = exp3_2016 %>%
  ungroup()


ids = 1:nrow(exp3_2016)
exp3_2016_IDs = select(exp3_2016, "condition")
exp3_2016_IDs$sentence_id = ids
exp3_2016_IDs = exp3_2016_IDs[c("sentence_id", "condition")]
write.csv( exp3_2016_IDs,"data/Sprouse2016/exp3ID_to_cond.csv", row.names=FALSE)

exp3_2016_surps = read.csv("data/Sprouse2016/exp3_surprisals.csv")
exp3_2016$mean_surprisal = exp3_2016_surps$mean_surprisal
exp3_2016$normalized = exp3_2016_surps$normalized
exp3_2016$beyond_5 = exp3_2016_surps$beyond_5
exp3_2016$beyond_6 = exp3_2016_surps$beyond_6
exp3_2016$beyond_7 = exp3_2016_surps$beyond_7
exp3_2016$beyond_8 = exp3_2016_surps$beyond_8
exp3_2016$beyond_9 = exp3_2016_surps$beyond_9
exp3_2016$gap = exp3_2016_surps$gap
exp3_2016$gap_norm = exp3_2016_surps$gap_norm

plot = exp3_2016 %>%
  ggplot((aes(x = mean_surprisal, y= mean_acc))) +
  geom_point() +
  geom_smooth(method = "lm", se=FALSE) +
  labs(title = "Sprouse 2016 Mean Acceptability and Surprisal with D-Linking", 
       x = "Mean Surprisal", 
       y = "Mean Acceptability") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text())
plot


all_2016 = rbind(exp1_2016, exp3_2016)
all_2016_no_fill = filter(all_2016, structure != "filler" & structure != "" & gap > 0)
all_2016_no_fill_long = filter(all_2016_no_fill, distance == "long")
all_2016 = all_2016_no_fill

plot = all_2016 %>%
  ggplot((aes(x = mean_surprisal, y= mean_acc))) +
  geom_point() +
  geom_smooth(method = "lm", se=FALSE) +
  labs(title = "Sprouse 2016 Mean Acceptability and Surprisal", 
       x = "Mean Surprisal", 
       y = "Mean Acceptability") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text())
plot


plot = all_2016 %>%
  ggplot((aes(x = normalized, y= mean_acc))) +
  geom_point() +
  geom_smooth(method = "lm", se=FALSE) +
  labs(title = "Sprouse 2016 Mean Acceptability and Surprisal", 
       x = "Normalized Surprisal", 
       y = "Mean Acceptability") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text())
plot

plot = all_2016 %>%
  ggplot((aes(x = beyond_5, y= mean_acc))) +
  geom_point() +
  geom_smooth(method = "lm", se=FALSE) +
  labs(title = "Sprouse 2016 Mean Acceptability and Surprisal", 
       x = "Mean Surprisal Threshold = 5", 
       y = "Mean Acceptability") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text())
plot

plot = all_2016 %>%
  ggplot((aes(x = beyond_6, y= mean_acc))) +
  geom_point() +
  geom_smooth(method = "lm", se=FALSE) +
  labs(title = "Sprouse 2016 Mean Acceptability and Surprisal", 
       x = "Mean Surprisal Threshold = 6", 
       y = "Mean Acceptability") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text())
plot

plot = all_2016 %>%
  ggplot((aes(x = beyond_7, y= mean_acc))) +
  geom_point() +
  geom_smooth(method = "lm", se=FALSE) +
  labs(title = "Sprouse 2016 Mean Acceptability and Surprisal", 
       x = "Mean Surprisal Threshold = 7", 
       y = "Mean Acceptability") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text())
plot

plot = all_2016 %>%
  ggplot((aes(x = beyond_8, y= mean_acc))) +
  geom_point() +
  geom_smooth(method = "lm", se=FALSE) +
  labs(title = "Sprouse 2016 Mean Acceptability and Surprisal", 
       x = "Mean Surprisal Threshold = 8", 
       y = "Mean Acceptability") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text())
plot

plot = all_2016 %>%
  ggplot((aes(x = beyond_9, y= mean_acc))) +
  geom_point() +
  geom_smooth(method = "lm", se=FALSE) +
  labs(title = "Sprouse 2016 Mean Acceptability and Surprisal", 
       x = "Mean Surprisal Threshold = 9", 
       y = "Mean Acceptability") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text())
plot

plot = all_2016_no_fill%>%
  ggplot((aes(x = gap_norm, y= mean_acc))) +
  geom_point(aes(color = island)) +
  geom_smooth(method = "lm", se=FALSE) +
  labs(title = "Sprouse 2016 Mean Acceptability and Surprisal", 
       x = "Normalized Surprisal Post Gap", 
       y = "Mean Acceptability") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text())
plot

plot = all_2016_no_fill%>%
  ggplot((aes(x = gap, y= mean_acc, group = island, color = island))) +
  geom_point(aes(color = distance)) +
  geom_smooth(method = "lm", se=FALSE) +
  labs(title = "Sprouse 2016 Mean Acceptability and Surprisal", 
       x = "Surprisal Post Gap", 
       y = "Mean Acceptability") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text())
plot

plot = all_2016_no_fill_long%>%
  ggplot((aes(x = gap, y= mean_acc, group = island, color = island))) +
  geom_point(aes(color = island)) +
  geom_smooth(method = "lm", se=FALSE) +
  labs(title = "Sprouse 2016 Mean Acceptability and Surprisal", 
       x = "Surprisal Post Gap (Long Distance Only)", 
       y = "Mean Acceptability") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text())
plot

plot = all_2016_no_fill_long%>%
  ggplot((aes(x = mean_surprisal, y= mean_acc, group = island, color = island))) +
  geom_point(aes(color = island)) +
  geom_smooth(method = "lm", se=FALSE) +
  labs(title = "Sprouse 2016 Mean Acceptability and Surprisal", 
       x = "Mean Surprisal (Long Distance Only)", 
       y = "Mean Acceptability") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text())
plot

plot = all_2016_no_fill_long%>%
  ggplot((aes(x = normalized, y= mean_acc))) +
  geom_point(aes(color = island)) +
  geom_smooth(method = "lm", se=FALSE) +
  labs(title = "Sprouse 2016 Mean Acceptability and Surprisal", 
       x = "Normalized Surprisal (Long Distance Only)", 
       y = "Mean Acceptability") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text())
plot




summary(lm(mean_acc ~ gap, all_2016_no_fill_long))
summary(lm(mean_acc ~ normalized, all_2016_no_fill_long))
summary(lm(mean_acc ~ mean_surprisal, all_2016_no_fill_long))

