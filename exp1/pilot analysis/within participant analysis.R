library(tidyverse)
library(ggplot2)
library(ggthemes)
all = read.csv("exp1_pilot-trials_labeled_fixed.csv")
no_prac = filter(all, block_number != "practice")
no_prac$block_number = as.numeric(no_prac$block_number)

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

conditions <- list("adj_island", "CSC", "agreement", "binding", "head_dir", "LBC", "NPI", "subcat", "subj_island")
participants <- list(participant_3, participant_4, participant_5, participant_6, participant_7)
within_participant_results <- data.frame(matrix(ncol = 4, nrow = 0))
for (participant in participants) {
  for(cond in conditions) {
    subset = filter(participant, condition == toString(cond))
    participant_num = subset$workerid[1]
    cur_slope = unname((coef(lm(rating ~ block_number, subset))[2]))
    cur_entropy = 0
    within_participant_results = rbind(within_participant_results, c(participant_num, cond, cur_slope, cur_entropy))
  }
}
colnames(within_participant_results) <- c('participant', 'condition', 'slope', 'entropy')
#p7_test = filter(participant_7, condition == "LBC")
#coef(lm(rating~block_number, p7_test))

#ggsave("gpt2_satiation/plots/POLAR_A12_B12_variation.png", width=7, height=5)