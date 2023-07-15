library(tidyverse)


exp1_2012 = read.csv("data/Sprouse2012/SWP.EXP1.results.csv") %>%
  select(c("item", "condition", "raw.judgment")) %>%
  dplyr::rename(sentence_id = "item", response = "raw.judgment") %>%
  group_by(sentence_id, condition) %>%
  dplyr::summarize(mean_acc = mean(response))

exp2_2012 = read.csv("data/Sprouse2012/SWP.EXP2.results.csv") %>%
  select(c("item", "condition", "raw.judgment")) %>%
  dplyr::rename(sentence_id = "item", response = "raw.judgment") %>%
  group_by(sentence_id, condition) %>%
  dplyr::summarize(mean_acc = mean(response))


exp1_2016 = read.csv("data/Sprouse2016/Experiment 1 results - English.csv") %>%
  select(c("item", "condition", "judgment")) %>%
  dplyr::rename(sentence_id = "item", response = "judgment") %>%
  group_by(sentence_id, condition) %>%
  dplyr::summarize(mean_acc = mean(response)) %>%
  arrange(sentence_id)

ids = 1:nrow(exp1_2016)
exp1_2016_IDs = select(exp1_2016, "condition")
exp1_2016_IDs$sentence_id = ids
write.csv( exp1_2016_IDs,"data/Sprouse2016/exp1ID_to_cond.csv", row.names=FALSE)

exp1_2016_surps = read.csv("data/Sprouse2016/exp1_surprisals.csv")
exp1_2016$mean_surprisal = exp1_2016_surps$mean_surprisal
exp1_2016$normalized = exp1_2016_surps$normalized

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
