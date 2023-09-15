library(tidyverse)
library(ggplot2)
library(ggthemes)
all = read.csv("exp1_pilot-trials.csv")
no_prac = filter(all, block_number != "practice")


participant_3 = filter(no_prac, workerid == 3)

participant_3 %>%
  ggplot((aes(x = block_number, y= rating))) +
  geom_smooth(aes(group = condition, color = condition), method = "lm", se=FALSE) +
  #geom_line(aes(group = condition, color = condition)) +
  #geom_point(aes(color = condition)) +
  ylim(0, 1) +
  labs(title = "Paritipant 3 Ratings", 
       x = "Block Number", 
       y = "Acceptability Rating") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text())

participant_4 = filter(no_prac, workerid == 4)

participant_4 %>%
  ggplot((aes(x = block_number, y= rating))) +
  geom_smooth(aes(group = condition, color = condition), method = "lm", se=FALSE) +
  #geom_line(aes(group = condition, color = condition)) +
  #geom_point(aes(color = condition)) +
  ylim(0, 1) +
  labs(title = "Paritipant 4 Ratings", 
       x = "Block Number", 
       y = "Acceptability Rating") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text())



participant_5 = filter(no_prac, workerid == 5)

participant_5 %>%
  ggplot((aes(x = block_number, y= rating))) +
  geom_smooth(aes(group = condition, color = condition), method = "lm", se=FALSE) +
  #geom_line(aes(group = condition, color = condition)) +
  #geom_point(aes(color = condition)) +
  ylim(0, 1) +
  labs(title = "Paritipant 5 Ratings", 
       x = "Block Number", 
       y = "Acceptability Rating") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text())

participant_6 = filter(no_prac, workerid == 6)

participant_6 %>%
  ggplot((aes(x = block_number, y= rating))) +
  geom_smooth(aes(group = condition, color = condition), method = "lm", se=FALSE) +
  #geom_line(aes(group = condition, color = condition)) +
  #geom_point(aes(color = condition)) +
  ylim(0, 1) +
  labs(title = "Paritipant 6 Ratings", 
       x = "Block Number", 
       y = "Acceptability Rating") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text())

participant_7 = filter(no_prac, workerid == 7)

participant_7 %>%
  ggplot((aes(x = block_number, y= rating))) +
  geom_smooth(aes(group = condition, color = condition), method = "lm", se=FALSE) +
  #geom_line(aes(group = condition, color = condition)) +
  #geom_point(aes(color = condition)) +
  ylim(0, 1) +
  labs(title = "Paritipant 7 Ratings", 
       x = "Block Number", 
       y = "Acceptability Rating") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text())

no_prac %>%
  ggplot((aes(x = block_number, y= rating))) +
  geom_smooth(aes(group = condition, color = condition), method = "lm", se=FALSE) +
  #geom_line(aes(group = condition, color = condition)) +
  #geom_point(aes(color = condition)) +
  ylim(0, 1) +
  labs(title = "All Participants", 
       x = "Block Number", 
       y = "Acceptability Rating") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text())


#ggsave("gpt2_satiation/plots/POLAR_A12_B12_variation.png", width=7, height=5)