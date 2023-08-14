library(tidyverse)
library(ggplot2)
library(ggthemes)

num_trained = as.integer(c(0, 10))

WH_base = read.csv("gpt2_satiation/output/surprisals/gen_rep/gen_WH_baseline_surprisals.csv")
WH_test = read.csv("gpt2_satiation/output/surprisals/gen_rep/gen_WH_SUBJtest_surprisals.csv")
m_0 = mean(WH_base$mean_surprisal)
m_10 = mean(WH_test$mean_surprisal)
ms = c(m_0, m_10)
condition = c("WH", "WH")
WH = data.frame(num_trained, ms, condition)

SUBJ_base = read.csv("gpt2_satiation/output/surprisals/gen_rep/gen_SUBJ_baseline_surprisals.csv")
SUBJ_test = read.csv("gpt2_satiation/output/surprisals/gen_rep/gen_SUBJ_SUBJtest_surprisals.csv")
m_0 = mean(SUBJ_base$mean_surprisal)
m_10 = mean(SUBJ_test$mean_surprisal)
ms = c(m_0, m_10)
condition = c("SUBJ", "SUBJ")
SUBJ = data.frame(num_trained, ms, condition)

POLAR_base = read.csv("gpt2_satiation/output/surprisals/gen_rep/gen_POLAR_baseline_surprisals.csv")
POLAR_test = read.csv("gpt2_satiation/output/surprisals/gen_rep/gen_POLAR_SUBJtest_surprisals.csv")
m_0 = mean(POLAR_base$mean_surprisal)
m_10 = mean(POLAR_test$mean_surprisal)
ms = c(m_0, m_10)
condition = c("POLAR", "POLAR")
POLAR = data.frame(num_trained, ms, condition)


exp1 = rbind(WH, SUBJ, POLAR)

exp1 %>%
  ggplot((aes(x = num_trained, y= ms))) +
  geom_line(aes(group = condition, color = condition)) +
  geom_point(aes(color = condition)) + 
  scale_x_continuous(breaks=c(0,10)) +
  labs(title = "Generalization Experiment 1 Replication", 
       x = "Number of Training Sentences", 
       y = "Mean Surprisal") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text())

ggsave("gpt2_satiation/plots/gen_exp1_rep.png", width=7, height=5)



WH_base = read.csv("gpt2_satiation/output/surprisals/gen_rep/gen_WH_baseline_surprisals.csv")
WH_test = read.csv("gpt2_satiation/output/surprisals/gen_rep/gen_WH_WHtest_surprisals.csv")
m_0 = mean(WH_base$mean_surprisal)
m_10 = mean(WH_test$mean_surprisal)
ms = c(m_0, m_10)
condition = c("WH", "WH")
WH = data.frame(num_trained, ms, condition)

SUBJ_base = read.csv("gpt2_satiation/output/surprisals/gen_rep/gen_SUBJ_baseline_surprisals.csv")
SUBJ_test = read.csv("gpt2_satiation/output/surprisals/gen_rep/gen_SUBJ_WHtest_surprisals.csv")
m_0 = mean(SUBJ_base$mean_surprisal)
m_10 = mean(SUBJ_test$mean_surprisal)
ms = c(m_0, m_10)
condition = c("SUBJ", "SUBJ")
SUBJ = data.frame(num_trained, ms, condition)

POLAR_base = read.csv("gpt2_satiation/output/surprisals/gen_rep/gen_POLAR_baseline_surprisals.csv")
POLAR_test = read.csv("gpt2_satiation/output/surprisals/gen_rep/gen_POLAR_WHtest_surprisals.csv")
m_0 = mean(POLAR_base$mean_surprisal)
m_10 = mean(POLAR_test$mean_surprisal)
ms = c(m_0, m_10)
condition = c("POLAR", "POLAR")
POLAR = data.frame(num_trained, ms, condition)


exp2 = rbind(WH, SUBJ, POLAR)
exp2 %>%
  ggplot((aes(x = num_trained, y= ms))) +
  geom_line(aes(group = condition, color = condition)) +
  geom_point(aes(color = condition)) + 
  scale_x_continuous(breaks=c(0,10)) +
  ylim(3,9) +
  labs(title = "Generalization Experiment 2 Replication", 
       x = "Number of Training Sentences", 
       y = "Mean Surprisal") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text())

ggsave("gpt2_satiation/plots/gen_exp2_rep.png", width=7, height=5)