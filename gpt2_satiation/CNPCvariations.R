library(tidyverse)
library(ggplot2)
library(ggthemes)
num_trained = c(0, 10)
A1_B1_10 = read.csv("gpt2_satiation/output/surprisals/A1_train_B1_test_surprisals.csv")
A1_B1_0 = read.csv("gpt2_satiation/output/surprisals/CNPC_0_B1_test_surprisals.csv")
m_0 = mean(A1_B1_0$mean_surprisal)
m_10 = mean(A1_B1_10$mean_surprisal)
ms = c(m_0, m_10)
condition = c("A1-B1", "A1-B1")
AB_df = data.frame(num_trained, ms, condition)

B1_A1_10 = read.csv("gpt2_satiation/output/surprisals/B1_train_A1_test_surprisals.csv")
B1_A1_0 = read.csv("gpt2_satiation/output/surprisals/CNPC_0_A1_test_surprisals.csv")
m_0 = mean(B1_A1_0$mean_surprisal)
m_10 = mean(B1_A1_10$mean_surprisal)
ms = c(m_0, m_10)
condition = c("B1-A1", "B1-A1")
BA_df = data.frame(num_trained, ms, condition)

A1_A2_10 = read.csv("gpt2_satiation/output/surprisals/A1_train_A2_test_surprisals.csv")
A1_A2_0 = read.csv("gpt2_satiation/output/surprisals/CNPC_0_A2_test_surprisals.csv")
m_0 = mean(A1_A2_0$mean_surprisal)
m_10 = mean(A1_A2_10$mean_surprisal)
ms = c(m_0, m_10)
condition = c("A1-A2", "A1-A2")
AA_df = data.frame(num_trained, ms, condition)

surprisal_v_training = rbind(AB_df, BA_df, AA_df)

surprisal_v_training %>%
  ggplot((aes(x = num_trained, y= ms))) +
  geom_line(aes(group = condition, color = condition)) +
  geom_point(aes(color = condition)) +
  labs(title = "Training Sentences and Mean Surprisal A1-B1 Pattern", 
       x = "Sentences", 
       y = "Mean Surprisal") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text())

ggsave("gpt2_satiation/plots/CNPC_A1_B1_variation.png" )


A1_B2_10 = read.csv("gpt2_satiation/output/surprisals/A1_train_B2_test_surprisals.csv")
A1_B2_0 = read.csv("gpt2_satiation/output/surprisals/CNPC_0_B2_test_surprisals.csv")
m_0 = mean(A1_B2_0$mean_surprisal)
m_10 = mean(A1_B2_10$mean_surprisal)
ms = c(m_0, m_10)
condition = c("A1-B2", "A1-B2")
AB_df = data.frame(num_trained, ms, condition)

B2_A1_10 = read.csv("gpt2_satiation/output/surprisals/B2_train_A1_test_surprisals.csv")
B2_A1_0 = read.csv("gpt2_satiation/output/surprisals/CNPC_0_A1_test_surprisals.csv")
m_0 = mean(B2_A1_0$mean_surprisal)
m_10 = mean(B2_A1_10$mean_surprisal)
ms = c(m_0, m_10)
condition = c("B2-A1", "B2-A1")
BA_df = data.frame(num_trained, ms, condition)

A1_A2_10 = read.csv("gpt2_satiation/output/surprisals/A1_train_A2_test_surprisals.csv")
A1_A2_0 = read.csv("gpt2_satiation/output/surprisals/CNPC_0_A2_test_surprisals.csv")
m_0 = mean(A1_A2_0$mean_surprisal)
m_10 = mean(A1_A2_10$mean_surprisal)
ms = c(m_0, m_10)
condition = c("A1-A2", "A1-A2")
AA_df = data.frame(num_trained, ms, condition)

surprisal_v_training = rbind(AB_df, BA_df, AA_df)

surprisal_v_training %>%
  ggplot((aes(x = num_trained, y= ms))) +
  geom_line(aes(group = condition, color = condition)) +
  geom_point(aes(color = condition)) +
  labs(title = "Training Sentences and Mean Surprisal A1-B2 Pattern", 
       x = "Sentences", 
       y = "Mean Surprisal") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text())

ggsave("gpt2_satiation/plots/CNPC_A1_B2_variation.png" )
