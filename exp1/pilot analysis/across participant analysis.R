library(tidyverse)
library(ggplot2)
library(ggthemes)
all = read.csv("../pilot/exp1_pilot-trials_labeled_fixed.csv")
no_prac = filter(all, block_number != "practice")
no_prac$block_number = as.numeric(no_prac$block_number)

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

# Satiation slope per condition, with each data point being an individual rating
conditions <- list("adj_island", "CSC", "agreement", "binding", "head_dir", "LBC", "NPI", "subcat", "subj_island")
for (cond in conditions) {
  subset = filter(no_prac, condition==cond)
  plot_title = sprintf("%s ratings across participants", cond)
  print(subset)
  plot = subset %>%
    ggplot((aes(x=block_number, y=rating))) + 
    geom_point(aes(group=sentence_id, color=sentence_id)) +
    geom_smooth(method="lm", se=FALSE) +
    ylim(0,1) +
    labs(title = plot_title, 
         x = "Block Number", 
         y = "Acceptability Rating") +
    theme_fivethirtyeight() +
    theme(axis.title = element_text())
  print(plot)
}

# Calculates slope (satiation rate) and entropies of each condition for each participant
across_participant_results <- data.frame(matrix(ncol = 4, nrow = 0))
for (cond in conditions) {
  subset = filter(no_prac, condition == toString(cond))
  cur_slope = unname((coef(lm(rating ~ block_number, subset))[2]))
  
  meanings = as.data.frame(table(subset$meaning))
  meanings$prob = meanings$Freq / sum(meanings$Freq)
  forms = as.data.frame(table(subset$form))
  forms$prob = forms$Freq / sum(forms$Freq)

  cur_HM = -sum(meanings$prob * log2(meanings$prob))
  cur_HF = -sum(forms$prob * log2(forms$prob))
  across_participant_results = rbind(across_participant_results, c(cond, cur_slope, cur_HM, cur_HF))
}
colnames(across_participant_results) <- c('condition', 'slope', 'HM', 'HF')
across_participant_results$slope = as.numeric(across_participant_results$slope)
across_participant_results$HM = as.numeric(across_participant_results$HM)
across_participant_results$HF = as.numeric(across_participant_results$HF)
print(across_participant_results)

across_participant_results %>%
  ggplot(aes(x=HM, y=slope)) +
  geom_point(aes(color=condition)) +
  geom_smooth(method="lm", se=FALSE) +
  labs(title = "All Conditions", 
       x = "Entropy of meaning", 
       y = "Satiation rate (slope)") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text())
ggsave(filename = 'slope_v_HM_allcond.png', path="exp1/plots/")

across_participant_results %>%
  ggplot(aes(x=HF, y=slope)) +
  geom_point(aes(color=condition)) +
  geom_smooth(method="lm", se=FALSE) +
  labs(title = "All Conditions", 
       x = "Entropy of form", 
       y = "Satiation rate (slope)") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text())
ggsave(filename = 'slope_v_HF_allcond.png', path="exp1/plots/")