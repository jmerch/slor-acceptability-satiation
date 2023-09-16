library(tidyverse)
library(ggplot2)
library(ggthemes)
all = read.csv("../pilot/exp1_pilot-trials_labeled_fixed.csv")
no_prac = filter(all, block_number != "practice")
no_prac$block_number = as.numeric(no_prac$block_number)

participant_3 = filter(no_prac, workerid == 3)

participant_3 %>%
  ggplot((aes(x = block_number, y= rating))) +
  geom_smooth(aes(group = condition, color = condition), method = "lm", se=FALSE) +
  #geom_line(aes(group = condition, color = condition)) +
  #geom_point(aes(color = condition)) +
  ylim(0, 1) +
  labs(title = "Participant 3 Ratings", 
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
  labs(title = "Participant 4 Ratings", 
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
  labs(title = "Participant 5 Ratings", 
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
  labs(title = "Participant 6 Ratings", 
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
  labs(title = "Participant 7 Ratings", 
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

# Calculates slope (satiation rate) and entropies of each condition for each participant
conditions <- list("adj_island", "CSC", "agreement", "binding", "head_dir", "LBC", "NPI", "subcat", "subj_island")
participants <- list(participant_3, participant_4, participant_5, participant_6, participant_7)
within_participant_results <- data.frame(matrix(ncol = 5, nrow = 0))
for (participant in participants) {
  for(cond in conditions) {
    subset = filter(participant, condition == toString(cond))
    participant_num = subset$workerid[1]
    # print(coef(lm(rating ~ block_number, subset)))
    # print(coef(lm(rating ~ block_number, subset))[2])
    cur_slope = unname((coef(lm(rating ~ block_number, subset))[2]))
    
    print(participant_num)
    print(cond)
    meanings = as.data.frame(table(subset$meaning))
    meanings$prob = meanings$Freq / sum(meanings$Freq)
    forms = as.data.frame(table(subset$form))
    forms$prob = forms$Freq / sum(forms$Freq)

    cur_HM = -sum(meanings$prob * log2(meanings$prob))
    cur_HF = -sum(forms$prob * log2(forms$prob))
    within_participant_results = rbind(within_participant_results, c(participant_num, cond, cur_slope, cur_HM, cur_HF))
  }
}
print(within_participant_results)
colnames(within_participant_results) <- c('participant', 'condition', 'slope', 'HM', 'HF')
within_participant_results$slope = as.numeric(within_participant_results$slope)
within_participant_results$HM = as.numeric(within_participant_results$HM)
within_participant_results$HF = as.numeric(within_participant_results$HF)
print(within_participant_results)

# Graph slope vs. HM for individual participants
participant_3 = filter(within_participant_results, participant==3)
participant_3 %>%
  ggplot(aes(x = HM, y= slope)) +
  geom_point(aes(color=condition)) +
  geom_smooth(method = "lm", se=FALSE) +
  #geom_line(aes(group = condition, color = condition)) +
  #ylim(0, 1) +
  labs(title = "Participant 3", 
       x = "Entropy of meaning", 
       y = "Satiation rate (slope)") +
  #scale_x_continuous(breaks = seq(0, 1, 0.1)) +
  #scale_y_continuous(breaks = seq(0, 2,0.1)) +
  theme_fivethirtyeight() +
  theme(axis.title = element_text())
ggsave(filename = 'slope_v_HM_p3.png', path="exp1/plots/")

participant_4 = filter(within_participant_results, participant==4)
participant_4 %>%
  ggplot(aes(x = HM, y= slope)) +
  geom_point(aes(color=condition)) +
  geom_smooth(method = "lm", se=FALSE) +
  labs(title = "Participant 4", 
       x = "Entropy of meaning", 
       y = "Satiation rate (slope)") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text())
ggsave(filename = 'slope_v_HM_p4.png', path="exp1/plots/")

participant_5 = filter(within_participant_results, participant==5)
participant_5 %>%
  ggplot(aes(x = HM, y= slope)) +
  geom_point(aes(color=condition)) +
  geom_smooth(method = "lm", se=FALSE) +
  labs(title = "Participant 5", 
       x = "Entropy of meaning", 
       y = "Satiation rate (slope)") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text())
ggsave(filename = 'slope_v_HM_p5.png', path="exp1/plots/")

participant_6 = filter(within_participant_results, participant==6)
participant_6 %>%
  ggplot(aes(x = HM, y= slope)) +
  geom_point(aes(color=condition)) +
  geom_smooth(method = "lm", se=FALSE) +
  labs(title = "Participant 6", 
       x = "Entropy of meaning", 
       y = "Satiation rate (slope)") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text())
ggsave(filename = 'slope_v_HM_p6.png', path="exp1/plots/")

participant_7 = filter(within_participant_results, participant==7)
participant_7 %>%
  ggplot(aes(x = HM, y= slope)) +
  geom_point(aes(color=condition)) +
  geom_smooth(method = "lm", se=FALSE) +
  labs(title = "Participant 7", 
       x = "Entropy of meaning", 
       y = "Satiation rate (slope)") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text())
ggsave(filename = 'slope_v_HM_p7.png', path="exp1/plots/")

within_participant_results %>%
    ggplot((aes(x = HM, y= slope))) +
    geom_point(aes(color = participant)) +
    geom_smooth(aes(group = participant, color = participant), method = "lm", se=FALSE) +
  #geom_line(aes(group = condition, color = condition)) +
    #ylim(0, 1) +
    labs(title = "All Participants", 
       x = "Entropy of meaning", 
       y = "Satiation rate (slope)") +
    theme_fivethirtyeight() +
    theme(axis.title = element_text())
ggsave(filename = 'slope_v_HM_allpart.png', path="exp1/plots/")

# Graph slope vs HF for each participant
participant_3 = filter(within_participant_results, participant==3)
participant_3 %>%
  ggplot(aes(x = HF, y= slope)) +
  geom_point(aes(color=condition)) +
  geom_smooth(method = "lm", se=FALSE) +
  #geom_line(aes(group = condition, color = condition)) +
  #ylim(0, 1) +
  labs(title = "Participant 3", 
       x = "Entropy of form", 
       y = "Satiation rate (slope)") +
  #scale_x_continuous(breaks = seq(0, 1, 0.1)) +
  #scale_y_continuous(breaks = seq(0, 2,0.1)) +
  theme_fivethirtyeight() +
  theme(axis.title = element_text())
ggsave(filename = 'slope_v_HF_p3.png', path="exp1/plots/")

participant_4 = filter(within_participant_results, participant==4)
participant_4 %>%
  ggplot(aes(x = HF, y= slope)) +
  geom_point(aes(color=condition)) +
  geom_smooth(method = "lm", se=FALSE) +
  labs(title = "Participant 4", 
       x = "Entropy of form", 
       y = "Satiation rate (slope)") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text())
ggsave(filename = 'slope_v_HF_p4.png', path="exp1/plots/")

participant_5 = filter(within_participant_results, participant==5)
participant_5 %>%
  ggplot(aes(x = HF, y= slope)) +
  geom_point(aes(color=condition)) +
  geom_smooth(method = "lm", se=FALSE) +
  labs(title = "Participant 5", 
       x = "Entropy of form", 
       y = "Satiation rate (slope)") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text())
ggsave(filename = 'slope_v_HF_p5.png', path="exp1/plots/")

participant_6 = filter(within_participant_results, participant==6)
participant_6 %>%
  ggplot(aes(x = HF, y= slope)) +
  geom_point(aes(color=condition)) +
  geom_smooth(method = "lm", se=FALSE) +
  labs(title = "Participant 6", 
       x = "Entropy of meaning", 
       y = "Satiation rate (slope)") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text())
ggsave(filename = 'slope_v_HF_p6.png', path="exp1/plots/")

participant_7 = filter(within_participant_results, participant==7)
participant_7 %>%
  ggplot(aes(x = HF, y= slope)) +
  geom_point(aes(color=condition)) +
  geom_smooth(method = "lm", se=FALSE) +
  labs(title = "Participant 7", 
       x = "Entropy of meaning", 
       y = "Satiation rate (slope)") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text())
ggsave(filename = 'slope_v_HF_p7.png', path="exp1/plots/")

within_participant_results %>%
  ggplot((aes(x = HF, y= slope))) +
  geom_point(aes(color = participant)) +
  geom_smooth(aes(group = participant, color = participant), method = "lm", se=FALSE) +
  #geom_line(aes(group = condition, color = condition)) +
  #ylim(0, 1) +
  labs(title = "All Participants", 
       x = "Entropy of form", 
       y = "Satiation rate (slope)") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text())
ggsave(filename = 'slope_v_HF_allpart.png', path="exp1/plots/")


#p7_test = filter(participant_7, condition == "LBC")
#coef(lm(rating~block_number, p7_test))

#ggsave("gpt2_satiation/plots/POLAR_A12_B12_variation.png", width=7, height=5)