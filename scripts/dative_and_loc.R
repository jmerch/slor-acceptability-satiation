library(tidyverse)
library(ggplot2)
library(ggthemes)

dative_base = read.csv("data/lu_kim_2022/dativebaseRatings.csv")
dative_base_surps = read.csv("data/lu_kim_2022/dativebase_surprisals.csv")
dative_base$normalized_surprisal = dative_base_surps$normalized
dative = read.csv("data/lu_kim_2022/dativeRatings.csv")
dative_surps = read.csv('data/lu_kim_2022/dative_surprisals.csv')
dative$normalized_surprisal = dative_surps$normalized
dative_all = rbind(dative_base, dative)
locative_base = read.csv("data/lu_kim_2022/locative_baseline_fullRatings.csv")
locative_base_surps = read.csv("data/lu_kim_2022/locative_baseline_full_surprisals.csv")
locative_base$normalized_surprisal = locative_base_surps$normalized
locative_results = read.csv("data/lu_kim_2022/locativeresultsRatings.csv")
locative_results_surps = read.csv("data/lu_kim_2022/locativeresults_surprisals.csv")
locative_results$normalized_surprisal = locative_results_surps$normalized
locative_all = rbind(locative_base, locative_results)

satiation = read.csv("data/satiationRatings.csv")
satiation = select(satiation, c("sentence_id", "condition", "all_exposures", "mean_surprisal", "normalized"))
satitation = satiation %>%
  dplyr::rename(mean_acc = "all_exposures")
all_experiments = rbind(locative_all, dative_all)
all_experiments$mean_acc = ((all_experiments$mean_acc*7) - 1)/6
all_experiments = all_experiments %>%
  dplyr::rename(normalized = "normalized_surprisal")
all_experiments = select(all_experiments, c("sentence_id", "condition", "mean_acc", "mean_surprisal", "normalized"))
all_experiments = rbind(all_experiments, satitation)

disjunction = read.csv("data/disjunctionRatings.csv")
#all_experiments = rbind(all_experiments, disjunction)
plot = all_experiments %>%
  ggplot((aes(x = mean_surprisal, y= mean_acc))) +
  geom_point(aes(color = condition)) +
  geom_smooth(method = "lm", se=FALSE) +
  labs(title = "Mean Acceptability and Surprisal", 
       x = "Mean Surprisal", 
       y = "Mean Acceptability") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text())
plot

plot = all_experiments %>%
  ggplot((aes(x = normalized, y= mean_acc))) +
  geom_point(aes(color = condition)) +
  geom_smooth(method = "lm", se=FALSE) +
  labs(title = "Mean Acceptability and Surprisal", 
       x = "Normalized Surprisal", 
       y = "Mean Acceptability") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text())
plot

plot = all_experiments %>%
  ggplot((aes(x = normalized, y= mean_acc))) +
  geom_point(aes(color = condition)) +
  geom_smooth(method = "lm", se=FALSE) +
  labs(title = "Mean Acceptability and Surprisal", 
       x = "Normalized Surprisal", 
       y = "Mean Acceptability") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text())
plot

plot = disjunction %>%
  ggplot((aes(x = normalized, y= mean_acc))) +
  geom_point(aes(color = condition)) +
  geom_smooth(method = "lm", se=FALSE) +
  labs(title = "Disjunction Mean Acceptability and Surprisal", 
       x = "Normalized Surprisal", 
       y = "Mean Acceptability") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text())
plot

plot = disjunction %>%
  ggplot((aes(x = mean_surprisal, y= mean_acc))) +
  geom_point(aes(color = condition)) +
  geom_smooth(method = "lm", se=FALSE) +
  labs(title = "Disjunction Mean Acceptability and Surprisal", 
       x = "Mean Surprisal", 
       y = "Mean Acceptability") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text()) +
  
plot

#logistic
plot = all_experiments %>%
  ggplot((aes(x = mean_surprisal, y= mean_acc))) +
  geom_point(aes(color = condition)) +
  geom_smooth(method = "glm", 
              method.args = list(family = "binomial"), 
              se = FALSE)  +
  labs(title = "Mean Acceptability and Surprisal", 
       x = "Normalized Surprisal", 
       y = "Mean Acceptability") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text())
plot

all_logistic = glm(mean_acc ~ mean_surprisal, all_experiments, family = "binomial")
all_linear = lm(mean_acc~mean_surprisal, all_experiments)
AIC(all_logistic)
AIC(all_linear)