library(dplyr)
library(ggplot2)
library(ggthemes)
ratings <- read.csv("data/ratings.csv")
surprisals <- read.csv("data/surprisals.csv")

#plot mean surprisal vs mean of all ratings, just first 3
ratings %>%
  ggplot((aes(x = mean_surprisal, y= all_exposures))) +
  geom_point(aes(color = condition)) +
  geom_smooth(method = "lm", se=FALSE) +
  labs(title = "Mean Acceptability and Surprisal", 
       x = "Mean Surprisal", 
       y = "Mean Acceptability") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text())

ratings %>%
  ggplot((aes(x = mean_surprisal, y= first_three_exposures))) +
  geom_point(aes(color = condition)) +
  geom_smooth(method = "lm", se=FALSE) +
  labs(title = "Mean Acceptability and Surprisal", 
       x = "Mean Surprisal", 
       y = "Mean Acceptability (within first three exposures)") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text())

#plot each weight of surprisal vs the two kinds of ratings

ratings %>%
  ggplot((aes(x = weight_first, y= all_exposures))) +
  geom_point(aes(color = condition)) +
  geom_smooth(method = "lm", se=FALSE) +
  labs(title = "Acceptability and Surprisal", 
       x = "Weighted Mean Surprisal (first word w/greatest weight)", 
       y = "Mean Acceptability") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text())

ratings %>%
  ggplot((aes(x = weight_first, y= first_three_exposures))) +
  geom_point(aes(color = condition)) +
  geom_smooth(method = "lm", se=FALSE) +
  labs(title = "Acceptability and Surprisal", 
       x = "Weighted Mean Surprisal (first word w/greatest weight)", 
       y = "Mean Acceptability (within first three exposures)") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text())


ratings %>%
  ggplot((aes(x = weight_last, y= all_exposures))) +
  geom_point(aes(color = condition)) +
  geom_smooth(method = "lm", se=FALSE) +
  labs(title = "Acceptability and Surprisal", 
       x = "Weighted Mean Surprisal (last word w/greatest weight)", 
       y = "Mean Acceptability") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text())

ratings %>%
  ggplot((aes(x = weight_last, y= first_three_exposures))) +
  geom_point(aes(color = condition)) +
  geom_smooth(method = "lm", se=FALSE) +
  labs(title = "Acceptability and Surprisal", 
       x = "Weighted Mean Surprisal (last word w/greatest weight)", 
       y = "Mean Acceptability (within first three exposures)") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text())

ratings %>%
  ggplot((aes(x = weight_sum, y= all_exposures))) +
  geom_point(aes(color = condition)) +
  geom_smooth(method = "lm", se=FALSE) +
  labs(title = "Acceptability and Surprisal", 
       x = "Weighted Mean Surprisal (sum of weights)", 
       y = "Mean Acceptability") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text())

ratings %>%
  ggplot((aes(x = weight_sum, y= first_three_exposures))) +
  geom_point(aes(color = condition)) +
  geom_smooth(method = "lm", se=FALSE) +
  labs(title = "Acceptability and Surprisal", 
       x = "Weighted Mean Surprisal (sum of weights)", 
       y = "Mean Acceptability (within first three exposures)") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text())


ratings %>%
  ggplot((aes(x = normalized, y= all_exposures))) +
  geom_point(aes(color = condition)) +
  geom_smooth(method = "lm", se=FALSE) +
  labs(title = "Acceptability and Surprisal", 
       x = "Normalized Mean Surprisal", 
       y = "Mean Acceptability") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text())

ratings %>%
  ggplot((aes(x = normalized, y= first_three_exposures))) +
  geom_point(aes(color = condition)) +
  geom_smooth(method = "lm", se=FALSE) +
  labs(title = "Acceptability and Surprisal", 
       x = "Normalized Mean Surprisal", 
       y = "Mean Acceptability (within first three exposures)") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text())


# mean, normalized, weight first, last, sum
all_mean <- lm(ratings$all_exposures~ratings$mean_surprisal, ratings)
all_norm <- lm(ratings$all_exposures~ratings$normalized, ratings)
all_first <- lm(ratings$all_exposures~ratings$weight_first, ratings)
all_last <- lm(ratings$all_exposures~ratings$weight_last, ratings)
all_sum <- lm(ratings$all_exposures~ratings$weight_sum, ratings)
f3_mean <- lm(ratings$first_three_exposures~ratings$mean_surprisal, ratings)
f3_norm <- lm(ratings$first_three_exposures~ratings$normalized, ratings)
f3_first <- lm(ratings$first_three_exposures~ratings$weight_first, ratings)
f3_last <- lm(ratings$first_three_exposures~ratings$weight_last, ratings)
f3_sum <- lm(ratings$first_three_exposures~ratings$weight_sum, ratings)
AIC(all_mean)
BIC(all_mean)
AIC(all_norm)
BIC(all_norm)
AIC(all_first)
BIC(all_first)
AIC(all_last)
BIC(all_last)
AIC(all_sum)
BIC(all_sum)
AIC(f3_mean)
BIC(f3_mean)
AIC(f3_norm)
BIC(f3_norm)
AIC(f3_first)
BIC(f3_first)
AIC(f3_last)
BIC(f3_last)
AIC(f3_sum)
BIC(f3_sum)

# factor in condition:
all_mean_cond <- lm(ratings$all_exposures~ratings$mean_surprisal*ratings$condition, ratings)
f3_mean_cond <- lm(ratings$first_three_exposures~ratings$mean_surprisal*ratings$condition, ratings)
all_norm_cond <- lm(ratings$all_exposures~ratings$normalized*ratings$condition, ratings)
f3_norm_cond <- lm(ratings$first_three_exposures~ratings$normalized*ratings$condition, ratings)
AIC(all_mean_cond)
BIC(all_mean_cond)
AIC(f3_mean_cond)
BIC(f3_mean_cond)
AIC(all_norm_cond)
BIC(all_norm_cond)
AIC(f3_norm_cond)
BIC(f3_norm_cond)
summary(f3_norm_cond)
summary(all_norm_cond)
summary(f3_norm)
summary(all_norm)