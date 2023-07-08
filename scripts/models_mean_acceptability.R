library(dplyr)
library(ggplot2)
library(ggthemes)
library(Rmisc)
ratings <- read.csv("data/genRatings.csv")
ratings2 <- read.csv("data/adaptRatings.csv")
ratings <- rbind(ratings, ratings2)
#surprisals <- read.csv("data/gen_surprisals.csv")

#plot mean surprisal vs mean of all ratings, just first 3
group_means <- ratings %>%
  group_by(condition) %>%
  summarise(all_exposures = mean(all_exposures), mean_surprisal=mean(mean_surprisal))
print(group_means)

print(ratings$condition)

CIs_acc_mean = double(0)
CIs_acc_upper = double(0)
CIs_acc_lower = double(0)
print(CIs_acc_mean)
for (cond in c('WH', 'SUBJ', 'POLAR', 'FILL', 'UNGRAM', 'CNPC')){
  CIs = CI(ratings[ratings$condition==cond, 'all_exposures'], ci=0.95)
  CIs_acc_mean = append(CIs_acc_mean, CIs['mean'])
  CIs_acc_upper = append(CIs_acc_upper, CIs['upper'])
  CIs_acc_lower = append(CIs_acc_lower, CIs['lower'])
}
print(CIs_acc_upper)

CIs_acc = data.frame(
  condition = c('WH', 'SUBJ', 'POLAR', 'FILL', 'UNGRAM', 'CNPC'),
  mean = CIs_acc_mean,
  upper = CIs_acc_upper,
  lower = CIs_acc_lower
)
print(CIs_acc)

CIs_surp_mean = double(0)
CIs_surp_upper = double(0)
CIs_surp_lower = double(0)
for (cond in c('WH', 'SUBJ', 'POLAR', 'FILL', 'UNGRAM', 'CNPC')){
  CIs = CI(ratings[ratings$condition==cond, 'mean_surprisal'], ci=0.95)
  CIs_surp_mean = append(CIs_surp_mean, CIs['mean'])
  CIs_surp_upper = append(CIs_surp_upper, CIs['upper'])
  CIs_surp_lower = append(CIs_surp_lower, CIs['lower'])
}
print(CIs_surp_upper)

CIs_surp = data.frame(
  condition = c('WH', 'SUBJ', 'POLAR', 'FILL', 'UNGRAM', 'CNPC'),
  mean = CIs_surp_mean,
  upper = CIs_surp_upper,
  lower = CIs_surp_lower
)
print(CIs_surp)

# CIs_acc = c(
#   'WH' = CI(ratings[ratings$condition=='WH', 'all_exposures'], ci=0.95),
#   'SUBJ' = CI(ratings[ratings$condition=='SUBJ', 'all_exposures'], ci=0.95),
#   'POLAR' = CI(ratings[ratings$condition=='POLAR', 'all_exposures'], ci=0.95),
#   'FILL' = CI(ratings[ratings$condition=='FILL', 'all_exposures'], ci=0.95),
#   'UNGRAM' = CI(ratings[ratings$condition=='UNGRAM', 'all_exposures'], ci=0.95),
#   'CNPC' = CI(ratings[ratings$condition=='CNPC', 'all_exposures'], ci=0.95)
# )
# print(CIs_acc)
# CIs_surp = c(
#   'WH' = CI(ratings[ratings$condition=='WH', 'mean_surprisal'], ci=0.95),
#   'SUBJ' = CI(ratings[ratings$condition=='SUBJ', 'mean_surprisal'], ci=0.95),
#   'POLAR' = CI(ratings[ratings$condition=='POLAR', 'mean_surprisal'], ci=0.95),
#   'FILL' = CI(ratings[ratings$condition=='FILL', 'mean_surprisal'], ci=0.95),
#   'UNGRAM' = CI(ratings[ratings$condition=='UNGRAM', 'mean_surprisal'], ci=0.95),
#   'CNPC' = CI(ratings[ratings$condition=='CNPC', 'mean_surprisal'], ci=0.95)
# )
# 
# CI_polar = CI(ratings[ratings$condition=='POLAR', 'all_exposures'], ci=0.95)
# print(CI_polar)
# CI_polar_surp = CI(ratings[ratings$condition=='POLAR', 'mean_surprisal'], ci=0.95)
# print(CI_polar_surp)
# 
# CI_wh_acc = CI(ratings[ratings$condition=='WH', 'all_exposures'], ci=0.95)
# print(CI_wh_acc)
# CI_wh_surp = CI(ratings[ratings$condition=='WH', 'mean_surprisal'], ci=0.95)
# print(CI_wh_surp)

plot = ratings %>%
  ggplot((aes(x = mean_surprisal, y= all_exposures))) +
  geom_point(aes(color = condition)) +
  geom_smooth(method = "lm", se=FALSE) +
  labs(title = "Mean Acceptability and Surprisal", 
       x = "Mean Surprisal", 
       y = "Mean Acceptability") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text())

for (cond in c('WH', 'SUBJ', 'POLAR', 'FILL', 'UNGRAM', 'CNPC')){
  plot + geom_errorbar(aes(x = CIs_surp[CIs_surp$condition==cond, 'mean'], ymin=CIs_acc[CIs_acc$condition==cond, 'lower'], ymax=CIs_acc[CIs_acc$condition==cond, 'upper']))
}


# ratings %>%
#   ggplot((aes(x = mean_surprisal, y= all_exposures))) +
#   geom_point(aes(color = condition)) +
#   geom_point(data=group_means, shape=4) +
#   geom_errorbar(aes(x = CIs_surp['mean'], ymin=CI_polar['lower'], ymax=CI_polar['upper']), width=.2) +
#   geom_errorbar(aes(x = CI_wh_surp['mean'], ymin=CI_wh_acc['lower'], ymax=CI_wh_acc['upper']), width=.2) +
#   geom_smooth(method = "lm", se=FALSE) +
#   labs(title = "Mean Acceptability and Surprisal", 
#        x = "Mean Surprisal", 
#        y = "Mean Acceptability") +
#   theme_fivethirtyeight() +
#   theme(axis.title = element_text())

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