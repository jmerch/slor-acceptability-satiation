library(tidyverse)
library(ggplot2)
library(ggthemes)

num_trained = as.integer(c(0, 15))

CNPC_base = read.csv("gpt2_satiation/output/surprisals/adapt_rep/adapt_exp1_CNPCtest_baseline_surprisals.csv")
CNPC_test = read.csv("gpt2_satiation/output/surprisals/adapt_rep/adapt_exp1_CNPCtest_surprisals.csv")
m_0 = mean(CNPC_base$mean_surprisal)
m_10 = mean(CNPC_test$mean_surprisal)
ms = c(m_0, m_10)
condition = c("CNPC", "CNPC")
CNPC = data.frame(num_trained, ms, condition)

WH_base = read.csv("gpt2_satiation/output/surprisals/adapt_rep/adapt_exp1_WHtest_baseline_surprisals.csv")
WH_test = read.csv("gpt2_satiation/output/surprisals/adapt_rep/adapt_exp1_WHtest_surprisals.csv")
m_0 = mean(WH_base$mean_surprisal)
m_10 = mean(WH_test$mean_surprisal)
ms = c(m_0, m_10)
condition = c("WH", "WH")
WH = data.frame(num_trained, ms, condition)

SUBJ_base = read.csv("gpt2_satiation/output/surprisals/adapt_rep/adapt_exp1_SUBJtest_baseline_surprisals.csv")
SUBJ_test = read.csv("gpt2_satiation/output/surprisals/adapt_rep/adapt_exp1_SUBJtest_surprisals.csv")
m_0 = mean(SUBJ_base$mean_surprisal)
m_10 = mean(SUBJ_test$mean_surprisal)
ms = c(m_0, m_10)
condition = c("SUBJ", "SUBJ")
SUBJ = data.frame(num_trained, ms, condition)

FILL_base = read.csv("gpt2_satiation/output/surprisals/adapt_rep/adapt_exp1_FILLtest_baseline_surprisals.csv")
FILL_test = read.csv("gpt2_satiation/output/surprisals/adapt_rep/adapt_exp1_FILLtest_surprisals.csv")
m_0 = mean(FILL_base$mean_surprisal)
m_10 = mean(FILL_test$mean_surprisal)
ms = c(m_0, m_10)
condition = c("FILL", "FILL")
FILL = data.frame(num_trained, ms, condition)


UNGRAM_base = read.csv("gpt2_satiation/output/surprisals/adapt_rep/adapt_exp1_UNGRAMtest_baseline_surprisals.csv")
UNGRAM_test = read.csv("gpt2_satiation/output/surprisals/adapt_rep/adapt_exp1_UNGRAMtest_surprisals.csv")
m_0 = mean(UNGRAM_base$mean_surprisal)
m_10 = mean(UNGRAM_test$mean_surprisal)
ms = c(m_0, m_10)
condition = c("UNGRAM", "UNGRAM")
UNGRAM = data.frame(num_trained, ms, condition)

exp1 = rbind(CNPC, WH, SUBJ, FILL, UNGRAM)

exp1 %>%
  ggplot((aes(x = num_trained, y= ms))) +
  geom_line(aes(group = condition, color = condition)) +
  geom_point(aes(color = condition)) + 
  scale_x_continuous(breaks=c(0,15)) +
  labs(title = "Adaptation Experiment 1 Replication (one model, all islands)", 
       x = "Number of Training Sentences", 
       y = "Mean Surprisal") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text())

ggsave("gpt2_satiation/plots/adapt_exp1_rep.png", width=7, height=5)

exp1 %>%
  ggplot((aes(x = num_trained, y= ms))) +
  geom_line(aes(group = condition, color = condition)) +
  geom_point(aes(color = condition)) + 
  scale_x_continuous(breaks=c(0,15)) +
  ylim(3,9) +
  labs(title = "Adaptation Experiment 1 Replication (one model, all islands)", 
       x = "Number of Training Sentences", 
       y = "Mean Surprisal") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text())

ggsave("gpt2_satiation/plots/adapt_exp1_rep_zoom.png", width=7, height=5)


# Exp 2 rep, mean_surprisal (6 test sentences) baseline is same as exp 1, since same stimuli

#CNPC_base = read.csv("gpt2_satiation/output/surprisals/adapt_rep/adapt_exp1_CNPCtest_baseline_surprisals.csv")
CNPC_test = read.csv("gpt2_satiation/output/surprisals/adapt_rep/adapt_exp2_CNPC_CNPCtest_surprisals.csv")
m_0 = mean(CNPC_base$mean_surprisal)
m_10 = mean(CNPC_test$mean_surprisal)
ms = c(m_0, m_10)
condition = c("CNPC", "CNPC")
CNPC = data.frame(num_trained, ms, condition)

#WH_base = read.csv("gpt2_satiation/output/surprisals/adapt_rep/adapt_exp1_WHtest_baseline_surprisals.csv")
WH_test = read.csv("gpt2_satiation/output/surprisals/adapt_rep/adapt_exp2_WH_WHtest_surprisals.csv")
m_0 = mean(WH_base$mean_surprisal)
m_10 = mean(WH_test$mean_surprisal)
ms = c(m_0, m_10)
condition = c("WH", "WH")
WH = data.frame(num_trained, ms, condition)

#SUBJ_base = read.csv("gpt2_satiation/output/surprisals/adapt_rep/adapt_exp1_SUBJtest_baseline_surprisals.csv")
SUBJ_test = read.csv("gpt2_satiation/output/surprisals/adapt_rep/adapt_exp2_SUBJ_SUBJtest_surprisals.csv")
m_0 = mean(SUBJ_base$mean_surprisal)
m_10 = mean(SUBJ_test$mean_surprisal)
ms = c(m_0, m_10)
condition = c("SUBJ", "SUBJ")
SUBJ = data.frame(num_trained, ms, condition)

exp2 = rbind(CNPC, WH, SUBJ)
exp2[exp2=='WH'] = 'whether island'
exp2[exp2 == 'SUBJ'] = 'subject island'
print(exp2)

plot = exp2 %>%
  ggplot((aes(x = num_trained, y= ms))) +
  geom_line(aes(group = condition, color = condition), size=1.5) +
  geom_point(aes(color = condition), size=3) + 
  scale_x_continuous(breaks=c(0,15), labels=c('pre-exposure','post-exposure')) +
  ylim(3,9) +
  labs(y = "Mean surprisal") +
  theme_bw() +
  theme(legend.position = "bottom")+
  #theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) + 
  theme(axis.title.y = element_text(size=14), axis.title.x=element_blank())+
  theme(legend.text = element_text(size=12)) +
  theme(legend.title = element_blank()) + 
  theme(axis.text.x = element_text(size=13, hjust=0.6), axis.text.y = element_text(size=10)) +
  theme(plot.margin = margin(5, 15, 5, 5)) + 
  scale_color_manual(values=c("#D29D1A", "#B77AA5", "#5E9E76"))
plot
ggsave("gpt2_satiation/plots/adapt_exp2_rep_labels.png", width=7, height=5)

# Exp 2 rep, normalized (SLOR; 6 test sentences)

CNPC_test = read.csv("gpt2_satiation/output/surprisals/adapt_rep/adapt_exp2_CNPCtrain_CNPCtest_noContext_surprisals.csv")
CNPC_base = read.csv("gpt2_satiation/output/surprisals/adapt_rep/adapt_exp1_CNPC_baseline_noContext_surprisals.csv")
norm_CNPC = mean(CNPC_test$normalized)
norm_CNPC_baseline = mean(CNPC_base$normalized)

WH_test = read.csv("gpt2_satiation/output/surprisals/adapt_rep/adapt_exp2_WHtrain_WHtest_noContext_surprisals.csv")
WH_base = read.csv("gpt2_satiation/output/surprisals/adapt_rep/adapt_exp1_WH_baseline_noContext_surprisals.csv")
norm_WH = mean(WH_test$normalized)
norm_WH_baseline = mean(WH_base$normalized)

SUBJ_test = read.csv("gpt2_satiation/output/surprisals/adapt_rep/adapt_exp2_SUBJtrain_SUBJtest_noContext_surprisals.csv")
SUBJ_base = read.csv("gpt2_satiation/output/surprisals/adapt_rep/adapt_exp1_SUBJ_baseline_noContext_surprisals.csv")
norm_SUBJ = mean(SUBJ_test$normalized)
norm_SUBJ_baseline = mean(SUBJ_base$normalized)

exp2_SLOR = data.frame(num_trained = c(0, 6, 0, 6, 0, 6), SLOR = c(norm_CNPC_baseline, norm_CNPC, norm_WH_baseline, norm_WH, norm_SUBJ_baseline, norm_SUBJ), condition = c('CNPC', 'CNPC', 'whether-island', 'whether-island', 'subject island', 'subject island'))
print(exp2_SLOR)

plot = exp2_SLOR %>%
  ggplot((aes(x = num_trained, y= SLOR))) +
  geom_line(aes(group = condition, color = condition), size=1.5) +
  geom_point(aes(color = condition), size=3) + 
  scale_x_continuous(breaks=c(0,6), labels=c('pre-exposure','post-exposure')) +
  ylim(2,6) +
  labs(y = "Mean SLOR") +
  theme_bw() +
  theme(legend.position = "bottom")+
  #theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) + 
  theme(axis.title.y = element_text(size=16), axis.title.x=element_blank())+
  theme(legend.text = element_text(size=12)) +
  theme(legend.title = element_blank()) + 
  theme(axis.text.x = element_text(size=14.5, hjust=0.63), axis.text.y = element_text(size=10)) +
  theme(plot.margin = margin(5, 15, 5, 5)) + 
  scale_color_manual(values=c("#D29D1A", "#B77AA5", "#5E9E76"))
plot
ggsave("gpt2_satiation/plots/adapt_exp2_rep_SLOR.png", width=7, height=5)


# WS

#CNPC_base = read.csv("gpt2_satiation/output/surprisals/adapt_rep/adapt_exp1_CNPCtest_baseline_surprisals.csv")
CNPC_test = read.csv("gpt2_satiation/output/surprisals/adapt_rep/CNPC_WStrain_CNPCtest_surprisals.csv")
m_0 = mean(CNPC_base$mean_surprisal)
m_10 = mean(CNPC_test$mean_surprisal)
ms = c(m_0, m_10)
condition = c("CNPC", "CNPC")
CNPC = data.frame(num_trained, ms, condition)

#WH_base = read.csv("gpt2_satiation/output/surprisals/adapt_rep/adapt_exp1_WHtest_baseline_surprisals.csv")
WH_test = read.csv("gpt2_satiation/output/surprisals/adapt_rep/WH_WStrain_WHtest_surprisals.csv")
m_0 = mean(WH_base$mean_surprisal)
m_10 = mean(WH_test$mean_surprisal)
ms = c(m_0, m_10)
condition = c("WH", "WH")
WH = data.frame(num_trained, ms, condition)

#SUBJ_base = read.csv("gpt2_satiation/output/surprisals/adapt_rep/adapt_exp1_SUBJtest_baseline_surprisals.csv")
SUBJ_test = read.csv("gpt2_satiation/output/surprisals/adapt_rep/SUBJ_WStrain_SUBJtest_surprisals.csv")
m_0 = mean(SUBJ_base$mean_surprisal)
m_10 = mean(SUBJ_test$mean_surprisal)
ms = c(m_0, m_10)
condition = c("SUBJ", "SUBJ")
SUBJ = data.frame(num_trained, ms, condition)

exp2_ws = rbind(CNPC, WH, SUBJ)

exp2_ws %>%
  ggplot((aes(x = num_trained, y= ms))) +
  geom_line(aes(group = condition, color = condition)) +
  geom_point(aes(color = condition)) + 
  scale_x_continuous(breaks=c(0,15)) +
  ylim(3,9) +
  labs(title = "Adaptation Experiment 2 Replication (WS control)", 
       x = "Number of Training Blocks", 
       y = "Mean Surprisal") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text())

ggsave("gpt2_satiation/plots/adapt_exp2_rep_WS.png", width=7, height=5)