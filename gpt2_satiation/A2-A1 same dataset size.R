library(tidyverse)
library(ggplot2)
library(ggthemes)
num_trained = c(0, 10, 20, 30)
gen_POLAR_0WS = read.csv("gpt2_satiation/output/surprisals/gen_WS/POLAR_30_A_0_WS_surprisals.csv")
gen_POLAR_10WS = read.csv("gpt2_satiation/output/surprisals/gen_WS/POLAR_30_A_10_WS_surprisals.csv")
gen_POLAR_20WS = read.csv("gpt2_satiation/output/surprisals/gen_WS/POLAR_30_A_20_WS_surprisals.csv")
gen_POLAR_30WS = read.csv("gpt2_satiation/output/surprisals/gen_WS/POLAR_30_A_30_WS_surprisals.csv")
P_0WS = mean(gen_POLAR_0WS$mean_surprisal)
P_10WS = mean(gen_POLAR_10WS$mean_surprisal)
P_20WS = mean(gen_POLAR_20WS$mean_surprisal)
P_30WS = mean(gen_POLAR_30WS$mean_surprisal)
#surprisal = c(P_0 - P_0, P_10 - P_0, P_20 - P_0, P_30 - P_0)
surprisal = c(P_30WS, P_20WS, P_10WS, P_0WS)
condition = c("POLAR", "POLAR", "POLAR", "POLAR")
gen_POLAR_df = data.frame(num_trained, surprisal, condition)

gen_WH_0WS = read.csv("gpt2_satiation/output/surprisals/gen_WS/WH_30_A_0_WS_surprisals.csv")
gen_WH_10WS = read.csv("gpt2_satiation/output/surprisals/gen_WS/WH_30_A_10_WS_surprisals.csv")
gen_WH_20WS = read.csv("gpt2_satiation/output/surprisals/gen_WS/WH_30_A_20_WS_surprisals.csv")
gen_WH_30WS = read.csv("gpt2_satiation/output/surprisals/gen_WS/WH_30_A_30_WS_surprisals.csv")
W_0WS = mean(gen_WH_0WS$mean_surprisal)
W_10WS = mean(gen_WH_10WS$mean_surprisal)
W_20WS = mean(gen_WH_20WS$mean_surprisal)
W_30WS = mean(gen_WH_30WS$mean_surprisal)
#surprisal = c(P_0 - P_0, P_10 - P_0, P_20 - P_0, P_30 - P_0)
surprisal = c(W_30WS, W_20WS, W_10WS, W_0WS)
condition = c("WH", "WH", "WH", "WH")
gen_WH_df = data.frame(num_trained, surprisal, condition)

gen_SUBJ_0WS = read.csv("gpt2_satiation/output/surprisals/gen_WS/SUBJ_30_A_0_WS_surprisals.csv")
gen_SUBJ_10WS = read.csv("gpt2_satiation/output/surprisals/gen_WS/SUBJ_30_A_10_WS_surprisals.csv")
gen_SUBJ_20WS = read.csv("gpt2_satiation/output/surprisals/gen_WS/SUBJ_30_A_20_WS_surprisals.csv")
gen_SUBJ_30WS = read.csv("gpt2_satiation/output/surprisals/gen_WS/SUBJ_30_A_30_WS_surprisals.csv")
S_0WS = mean(gen_SUBJ_0WS$mean_surprisal)
S_10WS = mean(gen_SUBJ_10WS$mean_surprisal)
S_20WS = mean(gen_SUBJ_20WS$mean_surprisal)
S_30WS = mean(gen_SUBJ_30WS$mean_surprisal)
#surprisal = c(P_0 - P_0, P_10 - P_0, P_20 - P_0, P_30 - P_0)
surprisal = c(S_30WS, S_20WS, S_10WS, S_0WS)
condition = c("SUBJ", "SUBJ", "SUBJ", "SUBJ")
gen_SUBJ_df = data.frame(num_trained, surprisal, condition)


gen_CNPC_0WS = read.csv("gpt2_satiation/output/surprisals/gen_WS/CNPC_30_A_0_WS_surprisals.csv")
gen_CNPC_10WS = read.csv("gpt2_satiation/output/surprisals/gen_WS/CNPC_30_A_10_WS_surprisals.csv")
gen_CNPC_20WS = read.csv("gpt2_satiation/output/surprisals/gen_WS/CNPC_30_A_20_WS_surprisals.csv")
gen_CNPC_30WS = read.csv("gpt2_satiation/output/surprisals/gen_WS/CNPC_30_A_30_WS_surprisals.csv")
C_0WS = mean(gen_CNPC_0WS$mean_surprisal)
C_10WS = mean(gen_CNPC_10WS$mean_surprisal)
C_20WS = mean(gen_CNPC_20WS$mean_surprisal)
C_30WS = mean(gen_CNPC_30WS$mean_surprisal)
#surprisal = c(P_0 - P_0, P_10 - P_0, P_20 - P_0, P_30 - P_0)
surprisal = c(C_30WS, C_20WS, C_10WS, C_0WS)
condition = c("CNPC", "CNPC", "CNPC", "CNPC")
gen_CNPC_df = data.frame(num_trained, surprisal, condition)


surprisal_v_training = rbind(gen_POLAR_df, gen_WH_df, gen_SUBJ_df, gen_CNPC_df)
#surprisal_v_training = rbind(surprisal_v_training, gen_SUBJ_df)

surprisal_v_training %>%
  #filter(condition != "POLAR") %>%
  ggplot((aes(x = num_trained, y= surprisal))) +
  geom_line(aes(group = condition, color = condition)) +
  geom_point(aes(color = condition)) +
  #geom_smooth(method = "lm", se=FALSE) +
  labs(title = "Some lexical overlap but equal dataset size", 
       x = "Number of Non Word Salad Sentences (out of 30)", 
       y = "Mean Surprisal") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text())

ggsave("gpt2_satiation/plots/A2_A1_dataset_controls.png", width=7, height=5)

p<-ggplot(surprisal_v_training, aes(x=num_trained, y= surprisal, fill = condition)) +
  geom_bar(stat="identity")
p + scale_fill_brewer(palette="BuPu")