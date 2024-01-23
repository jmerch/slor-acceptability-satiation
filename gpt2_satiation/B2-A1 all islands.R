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
  labs(title = "No Lexical Overlap but Varied Dataset Size", 
       x = "Sentences", 
       y = "Mean Surprisal") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text())

ggsave("gpt2_satiation/plots/sentences_v_mean_surprisal_B2_A1.png", width=7, height=5)

p<-ggplot(surprisal_v_training, aes(x=num_trained, y= surprisal, fill = condition)) +
  geom_bar(stat="identity")
p + scale_fill_brewer(palette="BuPu")

# JUST pre- and post- (15 exposure sentences)
CNPC_0 = read.csv("gpt2_satiation/output/surprisals/adapt_rep/adapt_exp1_CNPC_baseline_noContext_surprisals.csv")
CNPC_15 = read.csv("gpt2_satiation/output/surprisals/A_B_sets/CNPC_15_Btrain_CNPC_test_cleaned_surprisals.csv")
P_0 = mean(CNPC_0$mean_surprisal)
P_15 = mean(CNPC_15$mean_surprisal)
surprisal = c(P_0, P_15)
SLOR = c(mean(CNPC_0$normalized), mean(CNPC_15$normalized))
condition = c("CNPC", "CNPC")
cnpc_df = data.frame(num_trained = c(0, 15), surprisal, SLOR, condition)

WH_0 = read.csv("gpt2_satiation/output/surprisals/adapt_rep/adapt_exp1_WH_baseline_noContext_surprisals.csv")
WH_15 = read.csv("gpt2_satiation/output/surprisals/A_B_sets/WH_15_Btrain_WH_test_SurpOut_cleaned_surprisals.csv")
P_0 = mean(WH_0$mean_surprisal)
P_15 = mean(WH_15$mean_surprisal)
surprisal = c(P_0, P_15)
SLOR = c(mean(WH_0$normalized), mean(WH_15$normalized))
condition = c("WH", "WH")
wh_df = data.frame(num_trained = c(0, 15), surprisal, SLOR, condition)

SUBJ_0 = read.csv("gpt2_satiation/output/surprisals/adapt_rep/adapt_exp1_SUBJ_baseline_noContext_surprisals.csv")
SUBJ_15 = read.csv("gpt2_satiation/output/surprisals/A_B_sets/SUBJ_15_Btrain_SUBJ_test_SurpOut_cleaned_surprisals.csv")
P_0 = mean(SUBJ_0$mean_surprisal)
P_15 = mean(SUBJ_15$mean_surprisal)
surprisal = c(P_0, P_15)
SLOR = c(mean(SUBJ_0$normalized), mean(SUBJ_15$normalized))
condition = c("SUBJ", "SUBJ")
subj_df = data.frame(num_trained = c(0, 15), surprisal, SLOR, condition)

surprisal_v_training = rbind(wh_df, subj_df, cnpc_df)
print(surprisal_v_training)
surprisal_v_training[surprisal_v_training=='WH'] = 'whether-island'
surprisal_v_training[surprisal_v_training=='SUBJ'] = 'subject island'

plot = surprisal_v_training %>%
  ggplot((aes(x = num_trained, y= surprisal))) +
  geom_line(aes(group = condition, color = condition), size=1.5) +
  geom_point(aes(color = condition), size=3) + 
  scale_x_continuous(breaks=c(0,15), labels=c('pre-exposure','post-exposure')) +
  ylim(3,9) +
  labs(y = 'mean surprisal') +
  theme_bw() +
  theme(legend.position = 'bottom') +
  theme(legend.text = element_text(size=12))+
  theme(axis.title.y = element_text(size=14), axis.title.x=element_blank()) +
  theme(legend.title = element_blank()) +
  theme(axis.text.x = element_text(size=14, hjust=0.6), axis.text.y = element_text(size=10)) +
  theme(plot.margin = margin(5, 15, 5, 5)) +
  scale_color_manual(values=c("#D29D1A", "#B77AA5", "#5E9E76"))
plot
ggsave("gpt2_satiation/plots/B2_A1_15_new.png", width=7, height=5)

plot = surprisal_v_training %>%
  ggplot((aes(x = num_trained, y= SLOR))) +
  geom_line(aes(group = condition, color = condition), size=1.5) +
  geom_point(aes(color = condition), size=3) + 
  scale_x_continuous(breaks=c(0,15), labels=c('pre-exposure','post-exposure')) +
  ylim(2,6) +
  labs(y = 'Mean SLOR') +
  theme_bw() +
  theme(legend.position = 'bottom') +
  theme(legend.text = element_text(size=12))+
  theme(axis.title.y = element_text(size=16), axis.title.x=element_blank()) +
  theme(legend.title = element_blank()) +
  theme(axis.text.x = element_text(size=14.5, hjust=0.6), axis.text.y = element_text(size=10)) +
  theme(plot.margin = margin(5, 15, 5, 5)) +
  scale_color_manual(values=c("#D29D1A", "#B77AA5", "#5E9E76"))
plot
ggsave("gpt2_satiation/plots/B2_A1_15_SLOR.png", width=7, height=5)

