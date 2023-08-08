library(tidyverse)
library(ggplot2)
library(ggthemes)
num_trained = c(0, 10, 20, 30)
POLAR_0 = read.csv("gpt2_satiation/output/surprisals/overlap/gen_POLAR_0_surprisals.csv")
POLAR_10 = read.csv("gpt2_satiation/output/surprisals/POLAR_10_B_15_test_surprisals.csv")
POLAR_20 = read.csv("gpt2_satiation/output/surprisals/POLAR_20_B_15_test_surprisals.csv")
POLAR_30 = read.csv("gpt2_satiation/output/surprisals/POLAR_30_B_15_test_surprisals.csv")
P_0 = mean(POLAR_0$mean_surprisal)
P_10 = mean(POLAR_10$mean_surprisal)
P_20 = mean(POLAR_20$mean_surprisal)
P_30 = mean(POLAR_30$mean_surprisal)
#surprisal = c(P_0 - P_0, P_10 - P_0, P_20 - P_0, P_30 - P_0)
surprisal = c(P_0, P_10, P_20, P_30)
condition = c("POLAR", "POLAR", "POLAR", "POLAR")
polar_df = data.frame(num_trained, surprisal, condition)


WH_0 = read.csv("gpt2_satiation/output/surprisals/overlap/gen_WH_0_surprisals.csv")
WH_10 = read.csv("gpt2_satiation/output/surprisals/WH_10_B_15_test_surprisals.csv")
WH_20 = read.csv("gpt2_satiation/output/surprisals/WH_20_B_15_test_surprisals.csv")
WH_30 = read.csv("gpt2_satiation/output/surprisals/WH_30_B_15_test_surprisals.csv")
W_0 = mean(WH_0$mean_surprisal)
W_10 = mean(WH_10$mean_surprisal)
W_20 = mean(WH_20$mean_surprisal)
W_30 = mean(WH_30$mean_surprisal)
#surprisal = c(W_0 - W_0, W_10 - W_0, W_20 - W_0, W_30 - W_0)
surprisal = c(W_0, W_10, W_20, W_30)
condition = c("WH", "WH", "WH", "WH")
wh_df = data.frame(num_trained, surprisal, condition)


SUBJ_0 = read.csv("gpt2_satiation/output/surprisals/overlap/gen_SUBJ_0_surprisals.csv")
SUBJ_10 = read.csv("gpt2_satiation/output/surprisals/SUBJ_10_B_15_test_surprisals.csv")
SUBJ_20 = read.csv("gpt2_satiation/output/surprisals/SUBJ_20_B_15_test_surprisals.csv")
SUBJ_30 = read.csv("gpt2_satiation/output/surprisals/SUBJ_30_B_15_test_surprisals.csv")
S_0 = mean(SUBJ_0$mean_surprisal)
S_10 = mean(SUBJ_10$mean_surprisal)
S_20 = mean(SUBJ_20$mean_surprisal)
S_30 = mean(SUBJ_30$mean_surprisal)
#surprisal = c(S_0 - S_0, S_10 - S_0, S_20 - S_0, S_30 - S_0)
surprisal = c(S_0, S_10, S_20, S_30)
condition = c("SUBJ", "SUBJ", "SUBJ", "SUBJ")
subj_df = data.frame(num_trained, surprisal, condition)



CNPC_0 = read.csv("gpt2_satiation/output/surprisals/overlap/gen_CNPC_0_surprisals.csv")
CNPC_10 = read.csv("gpt2_satiation/output/surprisals/CNPC_10_B_15_test_surprisals.csv")
CNPC_20 = read.csv("gpt2_satiation/output/surprisals/CNPC_20_B_15_test_surprisals.csv")
CNPC_30 = read.csv("gpt2_satiation/output/surprisals/CNPC_30_B_15_test_surprisals.csv")
C_0 = mean(CNPC_0$mean_surprisal)
C_10 = mean(CNPC_10$mean_surprisal)
C_20 = mean(CNPC_20$mean_surprisal)
C_30 = mean(CNPC_30$mean_surprisal)
#surprisal = c(C_0 - C_0, C_10 - C_0, C_20 - C_0, C_30 - C_0)
surprisal = c(C_0, C_10, C_20, C_30)
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
  labs(title = "Normalized for Lexical Overlap", 
       x = "Sentences", 
       y = "Mean Surprisal") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text())

ggsave("gpt2_satiation/plots/sentences_v_mean_surprisal_B2_A1.png" )

p<-ggplot(surprisal_v_training, aes(x=num_trained, y= surprisal, fill = condition)) +
  geom_bar(stat="identity")
p + scale_fill_brewer(palette="BuPu")