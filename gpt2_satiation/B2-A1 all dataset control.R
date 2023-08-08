library(tidyverse)
library(ggplot2)
library(ggthemes)
num_trained = c(0, 10, 20, 30)
POLAR_0WS = read.csv("gpt2_satiation/output/surprisals/30B_WS_15test/POLAR_30_B_0_WS_surprisals.csv")
POLAR_10WS = read.csv("gpt2_satiation/output/surprisals/30B_WS_15test/POLAR_30_B_10_WS_surprisals.csv")
POLAR_20WS = read.csv("gpt2_satiation/output/surprisals/30B_WS_15test/POLAR_30_B_20_WS_surprisals.csv")
POLAR_30WS = read.csv("gpt2_satiation/output/surprisals/30B_WS_15test/POLAR_30_B_30_WS_surprisals.csv")
P_0WS = mean(POLAR_0WS$mean_surprisal)
P_10WS = mean(POLAR_10WS$mean_surprisal)
P_20WS = mean(POLAR_20WS$mean_surprisal)
P_30WS = mean(POLAR_30WS$mean_surprisal)
#surprisal = c(P_0 - P_0, P_10 - P_0, P_20 - P_0, P_30 - P_0)
surprisal = c(P_30WS, P_20WS, P_10WS, P_0WS)
condition = c("POLAR", "POLAR", "POLAR", "POLAR")
polar_df = data.frame(num_trained, surprisal, condition)

WH_0WS = read.csv("gpt2_satiation/output/surprisals/30B_WS_15test/WH_30_B_0_WS_surprisals.csv")
WH_10WS = read.csv("gpt2_satiation/output/surprisals/30B_WS_15test/WH_30_B_10_WS_surprisals.csv")
WH_20WS = read.csv("gpt2_satiation/output/surprisals/30B_WS_15test/WH_30_B_20_WS_surprisals.csv")
WH_30WS = read.csv("gpt2_satiation/output/surprisals/30B_WS_15test/WH_30_B_30_WS_surprisals.csv")
W_0WS = mean(WH_0WS$mean_surprisal)
W_10WS = mean(WH_10WS$mean_surprisal)
W_20WS = mean(WH_20WS$mean_surprisal)
W_30WS = mean(WH_30WS$mean_surprisal)
#surprisal = c(P_0 - P_0, P_10 - P_0, P_20 - P_0, P_30 - P_0)
surprisal = c(W_30WS, W_20WS, W_10WS, W_0WS)
condition = c("WH", "WH", "WH", "WH")
wh_df = data.frame(num_trained, surprisal, condition)

SUBJ_0WS = read.csv("gpt2_satiation/output/surprisals/30B_WS_15test/SUBJ_30_B_0_WS_surprisals.csv")
SUBJ_10WS = read.csv("gpt2_satiation/output/surprisals/30B_WS_15test/SUBJ_30_B_10_WS_surprisals.csv")
SUBJ_20WS = read.csv("gpt2_satiation/output/surprisals/30B_WS_15test/SUBJ_30_B_20_WS_surprisals.csv")
SUBJ_30WS = read.csv("gpt2_satiation/output/surprisals/30B_WS_15test/SUBJ_30_B_30_WS_surprisals.csv")
S_0WS = mean(SUBJ_0WS$mean_surprisal)
S_10WS = mean(SUBJ_10WS$mean_surprisal)
S_20WS = mean(SUBJ_20WS$mean_surprisal)
S_30WS = mean(SUBJ_30WS$mean_surprisal)
#surprisal = c(P_0 - P_0, P_10 - P_0, P_20 - P_0, P_30 - P_0)
surprisal = c(S_30WS, S_20WS, S_10WS, S_0WS)
condition = c("SUBJ", "SUBJ", "SUBJ", "SUBJ")
subj_df = data.frame(num_trained, surprisal, condition)


CNPC_0WS = read.csv("gpt2_satiation/output/surprisals/30B_WS_15test/CNPC_30_B_0_WS_surprisals.csv")
CNPC_10WS = read.csv("gpt2_satiation/output/surprisals/30B_WS_15test/CNPC_30_B_10_WS_surprisals.csv")
CNPC_20WS = read.csv("gpt2_satiation/output/surprisals/30B_WS_15test/CNPC_30_B_20_WS_surprisals.csv")
CNPC_30WS = read.csv("gpt2_satiation/output/surprisals/30B_WS_15test/CNPC_30_B_30_WS_surprisals.csv")
C_0WS = mean(CNPC_0WS$mean_surprisal)
C_10WS = mean(CNPC_10WS$mean_surprisal)
C_20WS = mean(CNPC_20WS$mean_surprisal)
C_30WS = mean(CNPC_30WS$mean_surprisal)
#surprisal = c(P_0 - P_0, P_10 - P_0, P_20 - P_0, P_30 - P_0)
surprisal = c(C_30WS, C_20WS, C_10WS, C_0WS)
condition = c("CNPC", "CNPC", "CNPC", "CNPC")
cnpc_df = data.frame(num_trained, surprisal, condition)



surprisal_v_training = rbind(polar_df, wh_df, subj_df, cnpc_df)
#surprisal_v_training = rbind(surprisal_v_training, subj_df)

surprisal_v_training %>%
  #filter(condition != "POLAR") %>%
  ggplot((aes(x = num_trained, y= surprisal))) +
  geom_line(aes(group = condition, color = condition)) +
  geom_point(aes(color = condition)) +
  #geom_smooth(method = "lm", se=FALSE) +
  labs(title = "Controlled overlap and dataset size", 
       x = "Number of Non Word Salad Sentences (out of 30)", 
       y = "Mean Surprisal") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text())

ggsave("gpt2_satiation/plots/B2_A1_all_controls.png", width=7, height=5)

p<-ggplot(surprisal_v_training, aes(x=num_trained, y= surprisal, fill = condition)) +
  geom_bar(stat="identity")
p + scale_fill_brewer(palette="BuPu")