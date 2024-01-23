library(dplyr)
library(ggplot2)
library(ggthemes)
library(Rmisc)
library(lme4)
ratings <- read.csv("acceptability_modeling/data/genRatings.csv")
ratings2 <- read.csv("acceptability_modeling/data/adaptRatings.csv")
ratings <- rbind(ratings, ratings2)
islands = filter(ratings, condition != "FILL" & condition != "POLAR" & condition != "UNGRAM")
#mean_only = select(ratings, c("sentence_id", "condition","all_exposures", "mean_surprisal"))
write.csv(ratings, "acceptability_modeling/data/satiationRatings.csv", row.names=FALSE)
#surprisals <- read.csv("data/gen_surprisals.csv")

# Mean surprisal vs acceptability with all exposures
# for acceptability error bars: create lists of the mean, upper, and lower of confidence intervals for each condition
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

# put confidence interval numbers into a data frame for convenient access
CIs_acc = data.frame( 
  condition = c('WH', 'SUBJ', 'POLAR', 'FILL', 'UNGRAM', 'CNPC'),
  mean = CIs_acc_mean,
  upper = CIs_acc_upper,
  lower = CIs_acc_lower
)
print(CIs_acc)

# repeat for surprisal error bars
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

plot = ratings %>%
  ggplot((aes(x = mean_surprisal, y= all_exposures))) +
  geom_point(aes(color = condition)) +
  geom_smooth(method = "lm", se=FALSE) +
  labs(title = "Mean Acceptability and Surprisal", 
       x = "Mean Surprisal", 
       y = "Mean Acceptability") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text())

HEIGHT = 0.01
WIDTH = 0.1

plot = plot + geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='WH', 'mean'], ymin=CIs_acc[CIs_acc$condition=='WH', 'lower'], ymax=CIs_acc[CIs_acc$condition=='WH', 'upper']), width=WIDTH, size=0.3) +
  geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='SUBJ', 'mean'], ymin=CIs_acc[CIs_acc$condition=='SUBJ', 'lower'], ymax=CIs_acc[CIs_acc$condition=='SUBJ', 'upper']), width=WIDTH, size=0.3)+ 
  geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='POLAR', 'mean'], ymin=CIs_acc[CIs_acc$condition=='POLAR', 'lower'], ymax=CIs_acc[CIs_acc$condition=='POLAR', 'upper']), width=WIDTH, size=0.3)+
  geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='FILL', 'mean'], ymin=CIs_acc[CIs_acc$condition=='FILL', 'lower'], ymax=CIs_acc[CIs_acc$condition=='FILL', 'upper']), width=WIDTH, size=.3)+
  geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='UNGRAM', 'mean'], ymin=CIs_acc[CIs_acc$condition=='UNGRAM', 'lower'], ymax=CIs_acc[CIs_acc$condition=='UNGRAM', 'upper']), width=WIDTH, size=0.3)+
  geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='CNPC', 'mean'], ymin=CIs_acc[CIs_acc$condition=='CNPC', 'lower'], ymax=CIs_acc[CIs_acc$condition=='CNPC', 'upper']), width=WIDTH, size=0.3)+
  
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='WH', 'mean'], xmin=CIs_surp[CIs_surp$condition=='WH', 'lower'], xmax=CIs_surp[CIs_surp$condition=='WH', 'upper']), height=HEIGHT, size=0.3)+
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='SUBJ', 'mean'], xmin=CIs_surp[CIs_surp$condition=='SUBJ', 'lower'], xmax=CIs_surp[CIs_surp$condition=='SUBJ', 'upper']), height=HEIGHT, size=0.3)+
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='POLAR', 'mean'], xmin=CIs_surp[CIs_surp$condition=='POLAR', 'lower'], xmax=CIs_surp[CIs_surp$condition=='POLAR', 'upper']), height=HEIGHT, size=0.3)+
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='FILL', 'mean'], xmin=CIs_surp[CIs_surp$condition=='FILL', 'lower'], xmax=CIs_surp[CIs_surp$condition=='FILL', 'upper']), height=HEIGHT, size=0.3)+
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='UNGRAM', 'mean'], xmin=CIs_surp[CIs_surp$condition=='UNGRAM', 'lower'], xmax=CIs_surp[CIs_surp$condition=='UNGRAM', 'upper']), height=HEIGHT, size=0.3)+
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='CNPC', 'mean'], xmin=CIs_surp[CIs_surp$condition=='CNPC', 'lower'], xmax=CIs_surp[CIs_surp$condition=='CNPC', 'upper']), height=HEIGHT, size=0.3)
plot
ggsave(filename='all_v_mean.png', path='plots/')

#individual smoothing
plot = ratings %>%
  ggplot((aes(x = mean_surprisal, y= all_exposures, group = condition))) +
  geom_point(aes(color = condition)) +
  geom_smooth(method = "lm", se=FALSE) +
  labs(title = "Mean Acceptability and Surprisal", 
       x = "Mean Surprisal", 
       y = "Mean Acceptability") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text())

HEIGHT = 0.01
WIDTH = 0.1

plot = plot + geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='WH', 'mean'], ymin=CIs_acc[CIs_acc$condition=='WH', 'lower'], ymax=CIs_acc[CIs_acc$condition=='WH', 'upper']), width=WIDTH, size=0.3) +
  geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='SUBJ', 'mean'], ymin=CIs_acc[CIs_acc$condition=='SUBJ', 'lower'], ymax=CIs_acc[CIs_acc$condition=='SUBJ', 'upper']), width=WIDTH, size=0.3)+ 
  geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='POLAR', 'mean'], ymin=CIs_acc[CIs_acc$condition=='POLAR', 'lower'], ymax=CIs_acc[CIs_acc$condition=='POLAR', 'upper']), width=WIDTH, size=0.3)+
  geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='FILL', 'mean'], ymin=CIs_acc[CIs_acc$condition=='FILL', 'lower'], ymax=CIs_acc[CIs_acc$condition=='FILL', 'upper']), width=WIDTH, size=.3)+
  geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='UNGRAM', 'mean'], ymin=CIs_acc[CIs_acc$condition=='UNGRAM', 'lower'], ymax=CIs_acc[CIs_acc$condition=='UNGRAM', 'upper']), width=WIDTH, size=0.3)+
  geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='CNPC', 'mean'], ymin=CIs_acc[CIs_acc$condition=='CNPC', 'lower'], ymax=CIs_acc[CIs_acc$condition=='CNPC', 'upper']), width=WIDTH, size=0.3)+
  
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='WH', 'mean'], xmin=CIs_surp[CIs_surp$condition=='WH', 'lower'], xmax=CIs_surp[CIs_surp$condition=='WH', 'upper']), height=HEIGHT, size=0.3)+
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='SUBJ', 'mean'], xmin=CIs_surp[CIs_surp$condition=='SUBJ', 'lower'], xmax=CIs_surp[CIs_surp$condition=='SUBJ', 'upper']), height=HEIGHT, size=0.3)+
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='POLAR', 'mean'], xmin=CIs_surp[CIs_surp$condition=='POLAR', 'lower'], xmax=CIs_surp[CIs_surp$condition=='POLAR', 'upper']), height=HEIGHT, size=0.3)+
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='FILL', 'mean'], xmin=CIs_surp[CIs_surp$condition=='FILL', 'lower'], xmax=CIs_surp[CIs_surp$condition=='FILL', 'upper']), height=HEIGHT, size=0.3)+
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='UNGRAM', 'mean'], xmin=CIs_surp[CIs_surp$condition=='UNGRAM', 'lower'], xmax=CIs_surp[CIs_surp$condition=='UNGRAM', 'upper']), height=HEIGHT, size=0.3)+
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='CNPC', 'mean'], xmin=CIs_surp[CIs_surp$condition=='CNPC', 'lower'], xmax=CIs_surp[CIs_surp$condition=='CNPC', 'upper']), height=HEIGHT, size=0.3)
plot
ggsave(filename='all_v_mean_individual_smooth.png', path='plots/')

#means and error bars only
plot = CIs_surp %>%
  ggplot((aes(x = mean, y= CIs_acc$mean))) +
  geom_point(aes(color = condition)) +
  geom_smooth(method = "lm", se=FALSE) +
  labs(title = "Mean Acceptability and Surprisal", 
       x = "Mean Surprisal", 
       y = "Mean Acceptability") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text())

HEIGHT = 0.01
WIDTH = 0.1

plot = plot + geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='WH', 'mean'], ymin=CIs_acc[CIs_acc$condition=='WH', 'lower'], ymax=CIs_acc[CIs_acc$condition=='WH', 'upper']), width=WIDTH, size=0.3) +
  geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='SUBJ', 'mean'], ymin=CIs_acc[CIs_acc$condition=='SUBJ', 'lower'], ymax=CIs_acc[CIs_acc$condition=='SUBJ', 'upper']), width=WIDTH, size=0.3)+ 
  geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='POLAR', 'mean'], ymin=CIs_acc[CIs_acc$condition=='POLAR', 'lower'], ymax=CIs_acc[CIs_acc$condition=='POLAR', 'upper']), width=WIDTH, size=0.3)+
  geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='FILL', 'mean'], ymin=CIs_acc[CIs_acc$condition=='FILL', 'lower'], ymax=CIs_acc[CIs_acc$condition=='FILL', 'upper']), width=WIDTH, size=.3)+
  geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='UNGRAM', 'mean'], ymin=CIs_acc[CIs_acc$condition=='UNGRAM', 'lower'], ymax=CIs_acc[CIs_acc$condition=='UNGRAM', 'upper']), width=WIDTH, size=0.3)+
  geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='CNPC', 'mean'], ymin=CIs_acc[CIs_acc$condition=='CNPC', 'lower'], ymax=CIs_acc[CIs_acc$condition=='CNPC', 'upper']), width=WIDTH, size=0.3)+
  
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='WH', 'mean'], xmin=CIs_surp[CIs_surp$condition=='WH', 'lower'], xmax=CIs_surp[CIs_surp$condition=='WH', 'upper']), height=HEIGHT, size=0.3)+
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='SUBJ', 'mean'], xmin=CIs_surp[CIs_surp$condition=='SUBJ', 'lower'], xmax=CIs_surp[CIs_surp$condition=='SUBJ', 'upper']), height=HEIGHT, size=0.3)+
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='POLAR', 'mean'], xmin=CIs_surp[CIs_surp$condition=='POLAR', 'lower'], xmax=CIs_surp[CIs_surp$condition=='POLAR', 'upper']), height=HEIGHT, size=0.3)+
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='FILL', 'mean'], xmin=CIs_surp[CIs_surp$condition=='FILL', 'lower'], xmax=CIs_surp[CIs_surp$condition=='FILL', 'upper']), height=HEIGHT, size=0.3)+
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='UNGRAM', 'mean'], xmin=CIs_surp[CIs_surp$condition=='UNGRAM', 'lower'], xmax=CIs_surp[CIs_surp$condition=='UNGRAM', 'upper']), height=HEIGHT, size=0.3)+
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='CNPC', 'mean'], xmin=CIs_surp[CIs_surp$condition=='CNPC', 'lower'], xmax=CIs_surp[CIs_surp$condition=='CNPC', 'upper']), height=HEIGHT, size=0.3)
plot
ggsave(filename='all_v_mean_error_only.png', path='plots/')


# Mean surprisal vs acceptability with first 3 exposures
CIs_acc_mean = double(0)
CIs_acc_upper = double(0)
CIs_acc_lower = double(0)
print(CIs_acc_mean)
for (cond in c('WH', 'SUBJ', 'POLAR', 'FILL', 'UNGRAM', 'CNPC')){
  CIs = CI(ratings[ratings$condition==cond, 'first_three_exposures'], ci=0.95)
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

plot = ratings %>%
  ggplot((aes(x = mean_surprisal, y= first_three_exposures))) +
  geom_point(aes(color = condition)) +
  geom_smooth(method = "lm", se=FALSE) +
  labs(title = "Mean Acceptability and Surprisal", 
       x = "Mean Surprisal", 
       y = "Mean Acceptability (within first three exposures)") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text())

HEIGHT = 0.01

plot = plot + geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='WH', 'mean'], ymin=CIs_acc[CIs_acc$condition=='WH', 'lower'], ymax=CIs_acc[CIs_acc$condition=='WH', 'upper']), width=.1, size=0.3) +
  geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='SUBJ', 'mean'], ymin=CIs_acc[CIs_acc$condition=='SUBJ', 'lower'], ymax=CIs_acc[CIs_acc$condition=='SUBJ', 'upper']), width=.1, size=0.3)+ 
  geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='POLAR', 'mean'], ymin=CIs_acc[CIs_acc$condition=='POLAR', 'lower'], ymax=CIs_acc[CIs_acc$condition=='POLAR', 'upper']), width=.1, size=0.3)+
  geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='FILL', 'mean'], ymin=CIs_acc[CIs_acc$condition=='FILL', 'lower'], ymax=CIs_acc[CIs_acc$condition=='FILL', 'upper']), width=.1, size=.3)+
  geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='UNGRAM', 'mean'], ymin=CIs_acc[CIs_acc$condition=='UNGRAM', 'lower'], ymax=CIs_acc[CIs_acc$condition=='UNGRAM', 'upper']), width=.1, size=0.3)+
  geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='CNPC', 'mean'], ymin=CIs_acc[CIs_acc$condition=='CNPC', 'lower'], ymax=CIs_acc[CIs_acc$condition=='CNPC', 'upper']), width=.1, size=0.3)+
  
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='WH', 'mean'], xmin=CIs_surp[CIs_surp$condition=='WH', 'lower'], xmax=CIs_surp[CIs_surp$condition=='WH', 'upper']), height=HEIGHT, size=0.3)+
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='SUBJ', 'mean'], xmin=CIs_surp[CIs_surp$condition=='SUBJ', 'lower'], xmax=CIs_surp[CIs_surp$condition=='SUBJ', 'upper']), height=HEIGHT, size=0.3)+
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='POLAR', 'mean'], xmin=CIs_surp[CIs_surp$condition=='POLAR', 'lower'], xmax=CIs_surp[CIs_surp$condition=='POLAR', 'upper']), height=HEIGHT, size=0.3)+
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='FILL', 'mean'], xmin=CIs_surp[CIs_surp$condition=='FILL', 'lower'], xmax=CIs_surp[CIs_surp$condition=='FILL', 'upper']), height=HEIGHT, size=0.3)+
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='UNGRAM', 'mean'], xmin=CIs_surp[CIs_surp$condition=='UNGRAM', 'lower'], xmax=CIs_surp[CIs_surp$condition=='UNGRAM', 'upper']), height=HEIGHT, size=0.3)+
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='CNPC', 'mean'], xmin=CIs_surp[CIs_surp$condition=='CNPC', 'lower'], xmax=CIs_surp[CIs_surp$condition=='CNPC', 'upper']), height=HEIGHT, size=0.3)
plot
ggsave(filename='f3_v_mean.png', path='plots/')

# Plot each weight of surprisal vs the two kinds of ratings (not used)

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

# Normalized surprisal vs. acceptability with all exposures
CIs_acc_mean = double(0)
CIs_acc_upper = double(0)
CIs_acc_lower = double(0)
for (cond in c('WH', 'SUBJ', 'POLAR', 'FILL', 'UNGRAM', 'CNPC')){
  CIs = CI(ratings[ratings$condition==cond, 'all_exposures'], ci=0.95)
  CIs_acc_mean = append(CIs_acc_mean, CIs['mean'])
  CIs_acc_upper = append(CIs_acc_upper, CIs['upper'])
  CIs_acc_lower = append(CIs_acc_lower, CIs['lower'])
}

CIs_acc = data.frame(
  condition = c('WH', 'SUBJ', 'POLAR', 'FILL', 'UNGRAM', 'CNPC'),
  mean = CIs_acc_mean,
  upper = CIs_acc_upper,
  lower = CIs_acc_lower
)

CIs_surp_mean = double(0)
CIs_surp_upper = double(0)
CIs_surp_lower = double(0)
for (cond in c('WH', 'SUBJ', 'POLAR', 'FILL', 'UNGRAM', 'CNPC')){
  CIs = CI(ratings[ratings$condition==cond, 'normalized'], ci=0.95)
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

plot = ratings %>%
  ggplot((aes(x = normalized, y= all_exposures))) +
  geom_point(aes(color = condition)) +
  geom_smooth(method = "lm", se=FALSE) +
  labs(title = "Acceptability and Surprisal", 
       x = "Normalized Mean Surprisal", 
       y = "Mean Acceptability") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text())

HEIGHT = 0.01
WIDTH = 0.01

plot = plot + geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='WH', 'mean'], ymin=CIs_acc[CIs_acc$condition=='WH', 'lower'], ymax=CIs_acc[CIs_acc$condition=='WH', 'upper']), width=WIDTH, size=0.3) +
  geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='SUBJ', 'mean'], ymin=CIs_acc[CIs_acc$condition=='SUBJ', 'lower'], ymax=CIs_acc[CIs_acc$condition=='SUBJ', 'upper']), width=WIDTH, size=0.3)+ 
  geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='POLAR', 'mean'], ymin=CIs_acc[CIs_acc$condition=='POLAR', 'lower'], ymax=CIs_acc[CIs_acc$condition=='POLAR', 'upper']), width=WIDTH, size=0.3)+
  geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='FILL', 'mean'], ymin=CIs_acc[CIs_acc$condition=='FILL', 'lower'], ymax=CIs_acc[CIs_acc$condition=='FILL', 'upper']), width=WIDTH, size=.3)+
  geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='UNGRAM', 'mean'], ymin=CIs_acc[CIs_acc$condition=='UNGRAM', 'lower'], ymax=CIs_acc[CIs_acc$condition=='UNGRAM', 'upper']), width=WIDTH, size=0.3)+
  geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='CNPC', 'mean'], ymin=CIs_acc[CIs_acc$condition=='CNPC', 'lower'], ymax=CIs_acc[CIs_acc$condition=='CNPC', 'upper']), width=WIDTH, size=0.3)+
  
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='WH', 'mean'], xmin=CIs_surp[CIs_surp$condition=='WH', 'lower'], xmax=CIs_surp[CIs_surp$condition=='WH', 'upper']), height=HEIGHT, size=0.3)+
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='SUBJ', 'mean'], xmin=CIs_surp[CIs_surp$condition=='SUBJ', 'lower'], xmax=CIs_surp[CIs_surp$condition=='SUBJ', 'upper']), height=HEIGHT, size=0.3)+
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='POLAR', 'mean'], xmin=CIs_surp[CIs_surp$condition=='POLAR', 'lower'], xmax=CIs_surp[CIs_surp$condition=='POLAR', 'upper']), height=HEIGHT, size=0.3)+
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='FILL', 'mean'], xmin=CIs_surp[CIs_surp$condition=='FILL', 'lower'], xmax=CIs_surp[CIs_surp$condition=='FILL', 'upper']), height=HEIGHT, size=0.3)+
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='UNGRAM', 'mean'], xmin=CIs_surp[CIs_surp$condition=='UNGRAM', 'lower'], xmax=CIs_surp[CIs_surp$condition=='UNGRAM', 'upper']), height=HEIGHT, size=0.3)+
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='CNPC', 'mean'], xmin=CIs_surp[CIs_surp$condition=='CNPC', 'lower'], xmax=CIs_surp[CIs_surp$condition=='CNPC', 'upper']), height=HEIGHT, size=0.3)
plot
ggsave(filename='all_v_normalized.png', path='plots/')

# plot with smoothing for each group rather than all data
plot = ratings %>%
  ggplot((aes(x = normalized, y= all_exposures, group = condition))) +
  geom_point(aes(color = condition)) +
  geom_smooth(method = "lm", se=FALSE) +
  labs(title = "Acceptability and Surprisal", 
       x = "Normalized Mean Surprisal", 
       y = "Mean Acceptability") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text())

HEIGHT = 0.01
WIDTH = 0.01

plot = plot + geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='WH', 'mean'], ymin=CIs_acc[CIs_acc$condition=='WH', 'lower'], ymax=CIs_acc[CIs_acc$condition=='WH', 'upper']), width=WIDTH, size=0.3) +
  geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='SUBJ', 'mean'], ymin=CIs_acc[CIs_acc$condition=='SUBJ', 'lower'], ymax=CIs_acc[CIs_acc$condition=='SUBJ', 'upper']), width=WIDTH, size=0.3)+ 
  geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='POLAR', 'mean'], ymin=CIs_acc[CIs_acc$condition=='POLAR', 'lower'], ymax=CIs_acc[CIs_acc$condition=='POLAR', 'upper']), width=WIDTH, size=0.3)+
  geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='FILL', 'mean'], ymin=CIs_acc[CIs_acc$condition=='FILL', 'lower'], ymax=CIs_acc[CIs_acc$condition=='FILL', 'upper']), width=WIDTH, size=.3)+
  geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='UNGRAM', 'mean'], ymin=CIs_acc[CIs_acc$condition=='UNGRAM', 'lower'], ymax=CIs_acc[CIs_acc$condition=='UNGRAM', 'upper']), width=WIDTH, size=0.3)+
  geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='CNPC', 'mean'], ymin=CIs_acc[CIs_acc$condition=='CNPC', 'lower'], ymax=CIs_acc[CIs_acc$condition=='CNPC', 'upper']), width=WIDTH, size=0.3)+
  
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='WH', 'mean'], xmin=CIs_surp[CIs_surp$condition=='WH', 'lower'], xmax=CIs_surp[CIs_surp$condition=='WH', 'upper']), height=HEIGHT, size=0.3)+
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='SUBJ', 'mean'], xmin=CIs_surp[CIs_surp$condition=='SUBJ', 'lower'], xmax=CIs_surp[CIs_surp$condition=='SUBJ', 'upper']), height=HEIGHT, size=0.3)+
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='POLAR', 'mean'], xmin=CIs_surp[CIs_surp$condition=='POLAR', 'lower'], xmax=CIs_surp[CIs_surp$condition=='POLAR', 'upper']), height=HEIGHT, size=0.3)+
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='FILL', 'mean'], xmin=CIs_surp[CIs_surp$condition=='FILL', 'lower'], xmax=CIs_surp[CIs_surp$condition=='FILL', 'upper']), height=HEIGHT, size=0.3)+
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='UNGRAM', 'mean'], xmin=CIs_surp[CIs_surp$condition=='UNGRAM', 'lower'], xmax=CIs_surp[CIs_surp$condition=='UNGRAM', 'upper']), height=HEIGHT, size=0.3)+
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='CNPC', 'mean'], xmin=CIs_surp[CIs_surp$condition=='CNPC', 'lower'], xmax=CIs_surp[CIs_surp$condition=='CNPC', 'upper']), height=HEIGHT, size=0.3)
plot
ggsave(filename='all_v_normalized_individual_smooth.png', path='plots/')

# means and error bars only

plot = CIs_surp %>%
  ggplot((aes(x = mean, y= CIs_acc$mean))) +
  geom_point(aes(color = condition)) +
  geom_smooth(method = "lm", se=FALSE) +
  labs(title = "Acceptability and Surprisal", 
       x = "Normalized Mean Surprisal", 
       y = "Mean Acceptability") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text())

HEIGHT = 0.01
WIDTH = 0.01

plot = plot + geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='WH', 'mean'], ymin=CIs_acc[CIs_acc$condition=='WH', 'lower'], ymax=CIs_acc[CIs_acc$condition=='WH', 'upper']), width=WIDTH, size=0.3) +
  geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='SUBJ', 'mean'], ymin=CIs_acc[CIs_acc$condition=='SUBJ', 'lower'], ymax=CIs_acc[CIs_acc$condition=='SUBJ', 'upper']), width=WIDTH, size=0.3)+ 
  geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='POLAR', 'mean'], ymin=CIs_acc[CIs_acc$condition=='POLAR', 'lower'], ymax=CIs_acc[CIs_acc$condition=='POLAR', 'upper']), width=WIDTH, size=0.3)+
  geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='FILL', 'mean'], ymin=CIs_acc[CIs_acc$condition=='FILL', 'lower'], ymax=CIs_acc[CIs_acc$condition=='FILL', 'upper']), width=WIDTH, size=.3)+
  geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='UNGRAM', 'mean'], ymin=CIs_acc[CIs_acc$condition=='UNGRAM', 'lower'], ymax=CIs_acc[CIs_acc$condition=='UNGRAM', 'upper']), width=WIDTH, size=0.3)+
  geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='CNPC', 'mean'], ymin=CIs_acc[CIs_acc$condition=='CNPC', 'lower'], ymax=CIs_acc[CIs_acc$condition=='CNPC', 'upper']), width=WIDTH, size=0.3)+
  
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='WH', 'mean'], xmin=CIs_surp[CIs_surp$condition=='WH', 'lower'], xmax=CIs_surp[CIs_surp$condition=='WH', 'upper']), height=HEIGHT, size=0.3)+
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='SUBJ', 'mean'], xmin=CIs_surp[CIs_surp$condition=='SUBJ', 'lower'], xmax=CIs_surp[CIs_surp$condition=='SUBJ', 'upper']), height=HEIGHT, size=0.3)+
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='POLAR', 'mean'], xmin=CIs_surp[CIs_surp$condition=='POLAR', 'lower'], xmax=CIs_surp[CIs_surp$condition=='POLAR', 'upper']), height=HEIGHT, size=0.3)+
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='FILL', 'mean'], xmin=CIs_surp[CIs_surp$condition=='FILL', 'lower'], xmax=CIs_surp[CIs_surp$condition=='FILL', 'upper']), height=HEIGHT, size=0.3)+
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='UNGRAM', 'mean'], xmin=CIs_surp[CIs_surp$condition=='UNGRAM', 'lower'], xmax=CIs_surp[CIs_surp$condition=='UNGRAM', 'upper']), height=HEIGHT, size=0.3)+
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='CNPC', 'mean'], xmin=CIs_surp[CIs_surp$condition=='CNPC', 'lower'], xmax=CIs_surp[CIs_surp$condition=='CNPC', 'upper']), height=HEIGHT, size=0.3)
plot
ggsave(filename='all_v_normalized_error_only.png', path='plots/')


# Normalized surprisal vs. acceptability with first 3 exposures
CIs_acc_mean = double(0)
CIs_acc_upper = double(0)
CIs_acc_lower = double(0)
for (cond in c('WH', 'SUBJ', 'POLAR', 'FILL', 'UNGRAM', 'CNPC')){
  CIs = CI(ratings[ratings$condition==cond, 'first_three_exposures'], ci=0.95)
  CIs_acc_mean = append(CIs_acc_mean, CIs['mean'])
  CIs_acc_upper = append(CIs_acc_upper, CIs['upper'])
  CIs_acc_lower = append(CIs_acc_lower, CIs['lower'])
}

CIs_acc = data.frame(
  condition = c('WH', 'SUBJ', 'POLAR', 'FILL', 'UNGRAM', 'CNPC'),
  mean = CIs_acc_mean,
  upper = CIs_acc_upper,
  lower = CIs_acc_lower
)

CIs_surp_mean = double(0)
CIs_surp_upper = double(0)
CIs_surp_lower = double(0)
for (cond in c('WH', 'SUBJ', 'POLAR', 'FILL', 'UNGRAM', 'CNPC')){
  CIs = CI(ratings[ratings$condition==cond, 'normalized'], ci=0.95)
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



HEIGHT = 0.01
WIDTH = 0.01

plot = plot + geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='WH', 'mean'], ymin=CIs_acc[CIs_acc$condition=='WH', 'lower'], ymax=CIs_acc[CIs_acc$condition=='WH', 'upper']), width=WIDTH, size=0.3) +
  geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='SUBJ', 'mean'], ymin=CIs_acc[CIs_acc$condition=='SUBJ', 'lower'], ymax=CIs_acc[CIs_acc$condition=='SUBJ', 'upper']), width=WIDTH, size=0.3)+ 
  geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='POLAR', 'mean'], ymin=CIs_acc[CIs_acc$condition=='POLAR', 'lower'], ymax=CIs_acc[CIs_acc$condition=='POLAR', 'upper']), width=WIDTH, size=0.3)+
  geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='FILL', 'mean'], ymin=CIs_acc[CIs_acc$condition=='FILL', 'lower'], ymax=CIs_acc[CIs_acc$condition=='FILL', 'upper']), width=WIDTH, size=.3)+
  geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='UNGRAM', 'mean'], ymin=CIs_acc[CIs_acc$condition=='UNGRAM', 'lower'], ymax=CIs_acc[CIs_acc$condition=='UNGRAM', 'upper']), width=WIDTH, size=0.3)+
  geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='CNPC', 'mean'], ymin=CIs_acc[CIs_acc$condition=='CNPC', 'lower'], ymax=CIs_acc[CIs_acc$condition=='CNPC', 'upper']), width=WIDTH, size=0.3)+
  
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='WH', 'mean'], xmin=CIs_surp[CIs_surp$condition=='WH', 'lower'], xmax=CIs_surp[CIs_surp$condition=='WH', 'upper']), height=HEIGHT, size=0.3)+
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='SUBJ', 'mean'], xmin=CIs_surp[CIs_surp$condition=='SUBJ', 'lower'], xmax=CIs_surp[CIs_surp$condition=='SUBJ', 'upper']), height=HEIGHT, size=0.3)+
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='POLAR', 'mean'], xmin=CIs_surp[CIs_surp$condition=='POLAR', 'lower'], xmax=CIs_surp[CIs_surp$condition=='POLAR', 'upper']), height=HEIGHT, size=0.3)+
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='FILL', 'mean'], xmin=CIs_surp[CIs_surp$condition=='FILL', 'lower'], xmax=CIs_surp[CIs_surp$condition=='FILL', 'upper']), height=HEIGHT, size=0.3)+
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='UNGRAM', 'mean'], xmin=CIs_surp[CIs_surp$condition=='UNGRAM', 'lower'], xmax=CIs_surp[CIs_surp$condition=='UNGRAM', 'upper']), height=HEIGHT, size=0.3)+
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='CNPC', 'mean'], xmin=CIs_surp[CIs_surp$condition=='CNPC', 'lower'], xmax=CIs_surp[CIs_surp$condition=='CNPC', 'upper']), height=HEIGHT, size=0.3)
plot
ggsave(filename='f3_v_normalized.png', path='plots/')


# for acceptability error bars: create lists of the mean, upper, and lower of confidence intervals for each condition
CIs_acc_mean = double(0)
CIs_acc_upper = double(0)
CIs_acc_lower = double(0)
print(CIs_acc_mean)
for (cond in c('WH', 'SUBJ', 'CNPC')){
  CIs = CI(islands[islands$condition==cond, 'all_exposures'], ci=0.95)
  CIs_acc_mean = append(CIs_acc_mean, CIs['mean'])
  CIs_acc_upper = append(CIs_acc_upper, CIs['upper'])
  CIs_acc_lower = append(CIs_acc_lower, CIs['lower'])
}
print(CIs_acc_upper)

# put confidence interval numbers into a data frame for convenient access
CIs_acc = data.frame( 
  condition = c('WH', 'SUBJ','CNPC'),
  mean = CIs_acc_mean,
  upper = CIs_acc_upper,
  lower = CIs_acc_lower
)
print(CIs_acc)

# repeat for surprisal error bars
CIs_surp_mean = double(0)
CIs_surp_upper = double(0)
CIs_surp_lower = double(0)
for (cond in c('WH', 'SUBJ','CNPC')){
  CIs = CI(islands[islands$condition==cond, 'gap'], ci=0.95)
  CIs_surp_mean = append(CIs_surp_mean, CIs['mean'])
  CIs_surp_upper = append(CIs_surp_upper, CIs['upper'])
  CIs_surp_lower = append(CIs_surp_lower, CIs['lower'])
}
print(CIs_surp_upper)

CIs_surp = data.frame(
  condition = c('WH', 'SUBJ','CNPC'),
  mean = CIs_surp_mean,
  upper = CIs_surp_upper,
  lower = CIs_surp_lower
)
print(CIs_surp)

plot = islands %>%
  ggplot((aes(x = gap, y= all_exposures))) +
  geom_point(aes(color = condition)) +
  geom_smooth(method = "lm", se=FALSE) +
  labs(title = "Acceptability and Surprisal", 
       x = "Surprisal at Gap", 
       y = "Mean Acceptability") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text())
plot


#Mean with error bars for embedded
HEIGHT = 0.01
WIDTH = 0.1
plot = CIs_surp %>%
  ggplot((aes(x = mean, y= CIs_acc$mean))) +
  geom_point(aes(color = condition)) +
  geom_smooth(method = "lm", se=FALSE) +
  labs(title = "Acceptability and Surprisal", 
       x = "Surprisal at Gap", 
       y = "Mean Acceptability") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text())
plot = plot + geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='WH', 'mean'], ymin=CIs_acc[CIs_acc$condition=='WH', 'lower'], ymax=CIs_acc[CIs_acc$condition=='WH', 'upper']), width=WIDTH, size=0.3) +
  geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='SUBJ', 'mean'], ymin=CIs_acc[CIs_acc$condition=='SUBJ', 'lower'], ymax=CIs_acc[CIs_acc$condition=='SUBJ', 'upper']), width=WIDTH, size=0.3)+ 
  #geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='POLAR', 'mean'], ymin=CIs_acc[CIs_acc$condition=='POLAR', 'lower'], ymax=CIs_acc[CIs_acc$condition=='POLAR', 'upper']), width=WIDTH, size=0.3)+
  #geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='FILL', 'mean'], ymin=CIs_acc[CIs_acc$condition=='FILL', 'lower'], ymax=CIs_acc[CIs_acc$condition=='FILL', 'upper']), width=WIDTH, size=.3)+
  #geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='UNGRAM', 'mean'], ymin=CIs_acc[CIs_acc$condition=='UNGRAM', 'lower'], ymax=CIs_acc[CIs_acc$condition=='UNGRAM', 'upper']), width=WIDTH, size=0.3)+
  geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='CNPC', 'mean'], ymin=CIs_acc[CIs_acc$condition=='CNPC', 'lower'], ymax=CIs_acc[CIs_acc$condition=='CNPC', 'upper']), width=WIDTH, size=0.3)+
  
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='WH', 'mean'], xmin=CIs_surp[CIs_surp$condition=='WH', 'lower'], xmax=CIs_surp[CIs_surp$condition=='WH', 'upper']), height=HEIGHT, size=0.3)+
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='SUBJ', 'mean'], xmin=CIs_surp[CIs_surp$condition=='SUBJ', 'lower'], xmax=CIs_surp[CIs_surp$condition=='SUBJ', 'upper']), height=HEIGHT, size=0.3)+
  #geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='POLAR', 'mean'], xmin=CIs_surp[CIs_surp$condition=='POLAR', 'lower'], xmax=CIs_surp[CIs_surp$condition=='POLAR', 'upper']), height=HEIGHT, size=0.3)+
  #geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='FILL', 'mean'], xmin=CIs_surp[CIs_surp$condition=='FILL', 'lower'], xmax=CIs_surp[CIs_surp$condition=='FILL', 'upper']), height=HEIGHT, size=0.3)+
  #geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='UNGRAM', 'mean'], xmin=CIs_surp[CIs_surp$condition=='UNGRAM', 'lower'], xmax=CIs_surp[CIs_surp$condition=='UNGRAM', 'upper']), height=HEIGHT, size=0.3)+
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='CNPC', 'mean'], xmin=CIs_surp[CIs_surp$condition=='CNPC', 'lower'], xmax=CIs_surp[CIs_surp$condition=='CNPC', 'upper']), height=HEIGHT, size=0.3)
plot

CIs_acc_mean = double(0)
CIs_acc_upper = double(0)
CIs_acc_lower = double(0)
print(CIs_acc_mean)
for (cond in c('WH', 'SUBJ', 'CNPC')){
  CIs = CI(islands[islands$condition==cond, 'all_exposures'], ci=0.95)
  CIs_acc_mean = append(CIs_acc_mean, CIs['mean'])
  CIs_acc_upper = append(CIs_acc_upper, CIs['upper'])
  CIs_acc_lower = append(CIs_acc_lower, CIs['lower'])
}
print(CIs_acc_upper)

# put confidence interval numbers into a data frame for convenient access
CIs_acc = data.frame( 
  condition = c('WH', 'SUBJ','CNPC'),
  mean = CIs_acc_mean,
  upper = CIs_acc_upper,
  lower = CIs_acc_lower
)
print(CIs_acc)

# repeat for surprisal error bars
CIs_surp_mean = double(0)
CIs_surp_upper = double(0)
CIs_surp_lower = double(0)
for (cond in c('WH', 'SUBJ','CNPC')){
  CIs = CI(islands[islands$condition==cond, 'embedded'], ci=0.95)
  CIs_surp_mean = append(CIs_surp_mean, CIs['mean'])
  CIs_surp_upper = append(CIs_surp_upper, CIs['upper'])
  CIs_surp_lower = append(CIs_surp_lower, CIs['lower'])
}
print(CIs_surp_upper)

CIs_surp = data.frame(
  condition = c('WH', 'SUBJ','CNPC'),
  mean = CIs_surp_mean,
  upper = CIs_surp_upper,
  lower = CIs_surp_lower
)
print(CIs_surp)
plot = islands %>%
  ggplot((aes(x = (embedded), y= all_exposures))) +
  geom_point(aes(color = condition)) +
  geom_smooth(method = "lm", se=FALSE) +
  labs(title = "Acceptability and Surprisal", 
       x = "Mean Surprisal in Embedded", 
       y = "Mean Acceptability") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text())
plot


HEIGHT = 0.01
WIDTH = 0.1

plot = CIs_surp %>%
  ggplot((aes(x = mean, y= CIs_acc$mean))) +
  geom_point(aes(color = condition)) +
  geom_smooth(method = "lm", se=FALSE) +
  labs(title = "Acceptability and Surprisal", 
       x = "Mean Surprisal in Embedded", 
       y = "Mean Acceptability") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text())
plot = plot + geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='WH', 'mean'], ymin=CIs_acc[CIs_acc$condition=='WH', 'lower'], ymax=CIs_acc[CIs_acc$condition=='WH', 'upper']), width=WIDTH, size=0.3) +
  geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='SUBJ', 'mean'], ymin=CIs_acc[CIs_acc$condition=='SUBJ', 'lower'], ymax=CIs_acc[CIs_acc$condition=='SUBJ', 'upper']), width=WIDTH, size=0.3)+ 
  #geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='POLAR', 'mean'], ymin=CIs_acc[CIs_acc$condition=='POLAR', 'lower'], ymax=CIs_acc[CIs_acc$condition=='POLAR', 'upper']), width=WIDTH, size=0.3)+
  #geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='FILL', 'mean'], ymin=CIs_acc[CIs_acc$condition=='FILL', 'lower'], ymax=CIs_acc[CIs_acc$condition=='FILL', 'upper']), width=WIDTH, size=.3)+
  #geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='UNGRAM', 'mean'], ymin=CIs_acc[CIs_acc$condition=='UNGRAM', 'lower'], ymax=CIs_acc[CIs_acc$condition=='UNGRAM', 'upper']), width=WIDTH, size=0.3)+
  geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='CNPC', 'mean'], ymin=CIs_acc[CIs_acc$condition=='CNPC', 'lower'], ymax=CIs_acc[CIs_acc$condition=='CNPC', 'upper']), width=WIDTH, size=0.3)+
  
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='WH', 'mean'], xmin=CIs_surp[CIs_surp$condition=='WH', 'lower'], xmax=CIs_surp[CIs_surp$condition=='WH', 'upper']), height=HEIGHT, size=0.3)+
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='SUBJ', 'mean'], xmin=CIs_surp[CIs_surp$condition=='SUBJ', 'lower'], xmax=CIs_surp[CIs_surp$condition=='SUBJ', 'upper']), height=HEIGHT, size=0.3)+
  #geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='POLAR', 'mean'], xmin=CIs_surp[CIs_surp$condition=='POLAR', 'lower'], xmax=CIs_surp[CIs_surp$condition=='POLAR', 'upper']), height=HEIGHT, size=0.3)+
  #geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='FILL', 'mean'], xmin=CIs_surp[CIs_surp$condition=='FILL', 'lower'], xmax=CIs_surp[CIs_surp$condition=='FILL', 'upper']), height=HEIGHT, size=0.3)+
  #geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='UNGRAM', 'mean'], xmin=CIs_surp[CIs_surp$condition=='UNGRAM', 'lower'], xmax=CIs_surp[CIs_surp$condition=='UNGRAM', 'upper']), height=HEIGHT, size=0.3)+
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='CNPC', 'mean'], xmin=CIs_surp[CIs_surp$condition=='CNPC', 'lower'], xmax=CIs_surp[CIs_surp$condition=='CNPC', 'upper']), height=HEIGHT, size=0.3)
plot


# matrix
CIs_acc_mean = double(0)
CIs_acc_upper = double(0)
CIs_acc_lower = double(0)
print(CIs_acc_mean)
for (cond in c('WH', 'SUBJ', 'CNPC')){
  CIs = CI(islands[islands$condition==cond, 'all_exposures'], ci=0.95)
  CIs_acc_mean = append(CIs_acc_mean, CIs['mean'])
  CIs_acc_upper = append(CIs_acc_upper, CIs['upper'])
  CIs_acc_lower = append(CIs_acc_lower, CIs['lower'])
}
print(CIs_acc_upper)

# put confidence interval numbers into a data frame for convenient access
CIs_acc = data.frame( 
  condition = c('WH', 'SUBJ','CNPC'),
  mean = CIs_acc_mean,
  upper = CIs_acc_upper,
  lower = CIs_acc_lower
)
print(CIs_acc)

# repeat for surprisal error bars
CIs_surp_mean = double(0)
CIs_surp_upper = double(0)
CIs_surp_lower = double(0)
for (cond in c('WH', 'SUBJ','CNPC')){
  CIs = CI(islands[islands$condition==cond, 'matrix'], ci=0.95)
  CIs_surp_mean = append(CIs_surp_mean, CIs['mean'])
  CIs_surp_upper = append(CIs_surp_upper, CIs['upper'])
  CIs_surp_lower = append(CIs_surp_lower, CIs['lower'])
}
print(CIs_surp_upper)

CIs_surp = data.frame(
  condition = c('WH', 'SUBJ','CNPC'),
  mean = CIs_surp_mean,
  upper = CIs_surp_upper,
  lower = CIs_surp_lower
)
print(CIs_surp)
plot = islands %>%
  ggplot((aes(x = (matrix), y= all_exposures))) +
  geom_point(aes(color = condition)) +
  geom_smooth(method = "lm", se=FALSE) +
  labs(title = "Acceptability and Surprisal", 
       x = "Mean Surprisal in Matrix", 
       y = "Mean Acceptability") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text())
plot

plot = CIs_surp %>%
  ggplot((aes(x = mean, y= CIs_acc$mean))) +
  geom_point(aes(color = condition)) +
  geom_smooth(method = "lm", se=FALSE) +
  labs(title = "Acceptability and Surprisal", 
       x = "Mean Surprisal in Matrix", 
       y = "Mean Acceptability") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text())
plot = plot + geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='WH', 'mean'], ymin=CIs_acc[CIs_acc$condition=='WH', 'lower'], ymax=CIs_acc[CIs_acc$condition=='WH', 'upper']), width=WIDTH, size=0.3) +
  geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='SUBJ', 'mean'], ymin=CIs_acc[CIs_acc$condition=='SUBJ', 'lower'], ymax=CIs_acc[CIs_acc$condition=='SUBJ', 'upper']), width=WIDTH, size=0.3)+ 
  #geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='POLAR', 'mean'], ymin=CIs_acc[CIs_acc$condition=='POLAR', 'lower'], ymax=CIs_acc[CIs_acc$condition=='POLAR', 'upper']), width=WIDTH, size=0.3)+
  #geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='FILL', 'mean'], ymin=CIs_acc[CIs_acc$condition=='FILL', 'lower'], ymax=CIs_acc[CIs_acc$condition=='FILL', 'upper']), width=WIDTH, size=.3)+
  #geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='UNGRAM', 'mean'], ymin=CIs_acc[CIs_acc$condition=='UNGRAM', 'lower'], ymax=CIs_acc[CIs_acc$condition=='UNGRAM', 'upper']), width=WIDTH, size=0.3)+
  geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='CNPC', 'mean'], ymin=CIs_acc[CIs_acc$condition=='CNPC', 'lower'], ymax=CIs_acc[CIs_acc$condition=='CNPC', 'upper']), width=WIDTH, size=0.3)+
  
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='WH', 'mean'], xmin=CIs_surp[CIs_surp$condition=='WH', 'lower'], xmax=CIs_surp[CIs_surp$condition=='WH', 'upper']), height=HEIGHT, size=0.3)+
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='SUBJ', 'mean'], xmin=CIs_surp[CIs_surp$condition=='SUBJ', 'lower'], xmax=CIs_surp[CIs_surp$condition=='SUBJ', 'upper']), height=HEIGHT, size=0.3)+
  #geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='POLAR', 'mean'], xmin=CIs_surp[CIs_surp$condition=='POLAR', 'lower'], xmax=CIs_surp[CIs_surp$condition=='POLAR', 'upper']), height=HEIGHT, size=0.3)+
  #geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='FILL', 'mean'], xmin=CIs_surp[CIs_surp$condition=='FILL', 'lower'], xmax=CIs_surp[CIs_surp$condition=='FILL', 'upper']), height=HEIGHT, size=0.3)+
  #geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='UNGRAM', 'mean'], xmin=CIs_surp[CIs_surp$condition=='UNGRAM', 'lower'], xmax=CIs_surp[CIs_surp$condition=='UNGRAM', 'upper']), height=HEIGHT, size=0.3)+
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='CNPC', 'mean'], xmin=CIs_surp[CIs_surp$condition=='CNPC', 'lower'], xmax=CIs_surp[CIs_surp$condition=='CNPC', 'upper']), height=HEIGHT, size=0.3)
plot


# comp
CIs_acc_mean = double(0)
CIs_acc_upper = double(0)
CIs_acc_lower = double(0)
print(CIs_acc_mean)
for (cond in c('WH', 'SUBJ', 'CNPC')){
  CIs = CI(islands[islands$condition==cond, 'all_exposures'], ci=0.95)
  CIs_acc_mean = append(CIs_acc_mean, CIs['mean'])
  CIs_acc_upper = append(CIs_acc_upper, CIs['upper'])
  CIs_acc_lower = append(CIs_acc_lower, CIs['lower'])
}
print(CIs_acc_upper)

# put confidence interval numbers into a data frame for convenient access
CIs_acc = data.frame( 
  condition = c('WH', 'SUBJ','CNPC'),
  mean = CIs_acc_mean,
  upper = CIs_acc_upper,
  lower = CIs_acc_lower
)
print(CIs_acc)

# repeat for surprisal error bars
CIs_surp_mean = double(0)
CIs_surp_upper = double(0)
CIs_surp_lower = double(0)
for (cond in c('WH', 'SUBJ','CNPC')){
  CIs = CI(islands[islands$condition==cond, 'comp'], ci=0.95)
  CIs_surp_mean = append(CIs_surp_mean, CIs['mean'])
  CIs_surp_upper = append(CIs_surp_upper, CIs['upper'])
  CIs_surp_lower = append(CIs_surp_lower, CIs['lower'])
}
print(CIs_surp_upper)

CIs_surp = data.frame(
  condition = c('WH', 'SUBJ','CNPC'),
  mean = CIs_surp_mean,
  upper = CIs_surp_upper,
  lower = CIs_surp_lower
)
print(CIs_surp)
plot = islands %>%
  ggplot((aes(x = (comp), y= all_exposures))) +
  geom_point(aes(color = condition)) +
  geom_smooth(method = "lm", se=FALSE) +
  labs(title = "Acceptability and Surprisal", 
       x = "Surprisal of Comp", 
       y = "Mean Acceptability") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text())
plot

plot = CIs_surp %>%
  ggplot((aes(x = mean, y= CIs_acc$mean))) +
  geom_point(aes(color = condition)) +
  geom_smooth(method = "lm", se=FALSE) +
  labs(title = "Acceptability and Surprisal", 
       x = "Surprisal of Comp", 
       y = "Mean Acceptability") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text())
plot = plot + geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='WH', 'mean'], ymin=CIs_acc[CIs_acc$condition=='WH', 'lower'], ymax=CIs_acc[CIs_acc$condition=='WH', 'upper']), width=WIDTH, size=0.3) +
  geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='SUBJ', 'mean'], ymin=CIs_acc[CIs_acc$condition=='SUBJ', 'lower'], ymax=CIs_acc[CIs_acc$condition=='SUBJ', 'upper']), width=WIDTH, size=0.3)+ 
  #geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='POLAR', 'mean'], ymin=CIs_acc[CIs_acc$condition=='POLAR', 'lower'], ymax=CIs_acc[CIs_acc$condition=='POLAR', 'upper']), width=WIDTH, size=0.3)+
  #geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='FILL', 'mean'], ymin=CIs_acc[CIs_acc$condition=='FILL', 'lower'], ymax=CIs_acc[CIs_acc$condition=='FILL', 'upper']), width=WIDTH, size=.3)+
  #geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='UNGRAM', 'mean'], ymin=CIs_acc[CIs_acc$condition=='UNGRAM', 'lower'], ymax=CIs_acc[CIs_acc$condition=='UNGRAM', 'upper']), width=WIDTH, size=0.3)+
  geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='CNPC', 'mean'], ymin=CIs_acc[CIs_acc$condition=='CNPC', 'lower'], ymax=CIs_acc[CIs_acc$condition=='CNPC', 'upper']), width=WIDTH, size=0.3)+
  
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='WH', 'mean'], xmin=CIs_surp[CIs_surp$condition=='WH', 'lower'], xmax=CIs_surp[CIs_surp$condition=='WH', 'upper']), height=HEIGHT, size=0.3)+
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='SUBJ', 'mean'], xmin=CIs_surp[CIs_surp$condition=='SUBJ', 'lower'], xmax=CIs_surp[CIs_surp$condition=='SUBJ', 'upper']), height=HEIGHT, size=0.3)+
  #geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='POLAR', 'mean'], xmin=CIs_surp[CIs_surp$condition=='POLAR', 'lower'], xmax=CIs_surp[CIs_surp$condition=='POLAR', 'upper']), height=HEIGHT, size=0.3)+
  #geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='FILL', 'mean'], xmin=CIs_surp[CIs_surp$condition=='FILL', 'lower'], xmax=CIs_surp[CIs_surp$condition=='FILL', 'upper']), height=HEIGHT, size=0.3)+
  #geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='UNGRAM', 'mean'], xmin=CIs_surp[CIs_surp$condition=='UNGRAM', 'lower'], xmax=CIs_surp[CIs_surp$condition=='UNGRAM', 'upper']), height=HEIGHT, size=0.3)+
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='CNPC', 'mean'], xmin=CIs_surp[CIs_surp$condition=='CNPC', 'lower'], xmax=CIs_surp[CIs_surp$condition=='CNPC', 'upper']), height=HEIGHT, size=0.3)
plot


### NORMALIZED ####


# for acceptability error bars: create lists of the mean, upper, and lower of confidence intervals for each condition
CIs_acc_mean = double(0)
CIs_acc_upper = double(0)
CIs_acc_lower = double(0)
print(CIs_acc_mean)
for (cond in c('WH', 'SUBJ', 'CNPC')){
  CIs = CI(islands[islands$condition==cond, 'all_exposures'], ci=0.95)
  CIs_acc_mean = append(CIs_acc_mean, CIs['mean'])
  CIs_acc_upper = append(CIs_acc_upper, CIs['upper'])
  CIs_acc_lower = append(CIs_acc_lower, CIs['lower'])
}
print(CIs_acc_upper)

# put confidence interval numbers into a data frame for convenient access
CIs_acc = data.frame( 
  condition = c('WH', 'SUBJ','CNPC'),
  mean = CIs_acc_mean,
  upper = CIs_acc_upper,
  lower = CIs_acc_lower
)
print(CIs_acc)

# repeat for surprisal error bars
CIs_surp_mean = double(0)
CIs_surp_upper = double(0)
CIs_surp_lower = double(0)
for (cond in c('WH', 'SUBJ','CNPC')){
  CIs = CI(islands[islands$condition==cond, 'gap_norm'], ci=0.95)
  CIs_surp_mean = append(CIs_surp_mean, CIs['mean'])
  CIs_surp_upper = append(CIs_surp_upper, CIs['upper'])
  CIs_surp_lower = append(CIs_surp_lower, CIs['lower'])
}
print(CIs_surp_upper)

CIs_surp = data.frame(
  condition = c('WH', 'SUBJ','CNPC'),
  mean = CIs_surp_mean,
  upper = CIs_surp_upper,
  lower = CIs_surp_lower
)
print(CIs_surp)

plot = islands %>%
  ggplot((aes(x = gap_norm, y= all_exposures))) +
  geom_point(aes(color = condition)) +
  geom_smooth(method = "lm", se=FALSE) +
  labs(title = "Acceptability and Surprisal", 
       x = "Normalized Surprisal at Gap", 
       y = "Mean Acceptability") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text())
plot


#Mean with error bars for embedded
HEIGHT = 0.01
WIDTH = 0.1
plot = CIs_surp %>%
  ggplot((aes(x = mean, y= CIs_acc$mean))) +
  geom_point(aes(color = condition)) +
  geom_smooth(method = "lm", se=FALSE) +
  labs(title = "Acceptability and Surprisal", 
       x = "Normalized Surprisal at Gap", 
       y = "Mean Acceptability") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text())
plot = plot + geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='WH', 'mean'], ymin=CIs_acc[CIs_acc$condition=='WH', 'lower'], ymax=CIs_acc[CIs_acc$condition=='WH', 'upper']), width=WIDTH, size=0.3) +
  geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='SUBJ', 'mean'], ymin=CIs_acc[CIs_acc$condition=='SUBJ', 'lower'], ymax=CIs_acc[CIs_acc$condition=='SUBJ', 'upper']), width=WIDTH, size=0.3)+ 
  #geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='POLAR', 'mean'], ymin=CIs_acc[CIs_acc$condition=='POLAR', 'lower'], ymax=CIs_acc[CIs_acc$condition=='POLAR', 'upper']), width=WIDTH, size=0.3)+
  #geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='FILL', 'mean'], ymin=CIs_acc[CIs_acc$condition=='FILL', 'lower'], ymax=CIs_acc[CIs_acc$condition=='FILL', 'upper']), width=WIDTH, size=.3)+
  #geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='UNGRAM', 'mean'], ymin=CIs_acc[CIs_acc$condition=='UNGRAM', 'lower'], ymax=CIs_acc[CIs_acc$condition=='UNGRAM', 'upper']), width=WIDTH, size=0.3)+
  geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='CNPC', 'mean'], ymin=CIs_acc[CIs_acc$condition=='CNPC', 'lower'], ymax=CIs_acc[CIs_acc$condition=='CNPC', 'upper']), width=WIDTH, size=0.3)+
  
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='WH', 'mean'], xmin=CIs_surp[CIs_surp$condition=='WH', 'lower'], xmax=CIs_surp[CIs_surp$condition=='WH', 'upper']), height=HEIGHT, size=0.3)+
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='SUBJ', 'mean'], xmin=CIs_surp[CIs_surp$condition=='SUBJ', 'lower'], xmax=CIs_surp[CIs_surp$condition=='SUBJ', 'upper']), height=HEIGHT, size=0.3)+
  #geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='POLAR', 'mean'], xmin=CIs_surp[CIs_surp$condition=='POLAR', 'lower'], xmax=CIs_surp[CIs_surp$condition=='POLAR', 'upper']), height=HEIGHT, size=0.3)+
  #geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='FILL', 'mean'], xmin=CIs_surp[CIs_surp$condition=='FILL', 'lower'], xmax=CIs_surp[CIs_surp$condition=='FILL', 'upper']), height=HEIGHT, size=0.3)+
  #geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='UNGRAM', 'mean'], xmin=CIs_surp[CIs_surp$condition=='UNGRAM', 'lower'], xmax=CIs_surp[CIs_surp$condition=='UNGRAM', 'upper']), height=HEIGHT, size=0.3)+
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='CNPC', 'mean'], xmin=CIs_surp[CIs_surp$condition=='CNPC', 'lower'], xmax=CIs_surp[CIs_surp$condition=='CNPC', 'upper']), height=HEIGHT, size=0.3)
plot

CIs_acc_mean = double(0)
CIs_acc_upper = double(0)
CIs_acc_lower = double(0)
print(CIs_acc_mean)
for (cond in c('WH', 'SUBJ', 'CNPC')){
  CIs = CI(islands[islands$condition==cond, 'all_exposures'], ci=0.95)
  CIs_acc_mean = append(CIs_acc_mean, CIs['mean'])
  CIs_acc_upper = append(CIs_acc_upper, CIs['upper'])
  CIs_acc_lower = append(CIs_acc_lower, CIs['lower'])
}
print(CIs_acc_upper)

# put confidence interval numbers into a data frame for convenient access
CIs_acc = data.frame( 
  condition = c('WH', 'SUBJ','CNPC'),
  mean = CIs_acc_mean,
  upper = CIs_acc_upper,
  lower = CIs_acc_lower
)
print(CIs_acc)

# repeat for surprisal error bars
CIs_surp_mean = double(0)
CIs_surp_upper = double(0)
CIs_surp_lower = double(0)
for (cond in c('WH', 'SUBJ','CNPC')){
  CIs = CI(islands[islands$condition==cond, 'embedded_norm'], ci=0.95)
  CIs_surp_mean = append(CIs_surp_mean, CIs['mean'])
  CIs_surp_upper = append(CIs_surp_upper, CIs['upper'])
  CIs_surp_lower = append(CIs_surp_lower, CIs['lower'])
}
print(CIs_surp_upper)

CIs_surp = data.frame(
  condition = c('WH', 'SUBJ','CNPC'),
  mean = CIs_surp_mean,
  upper = CIs_surp_upper,
  lower = CIs_surp_lower
)
print(CIs_surp)
plot = islands %>%
  ggplot((aes(x = (embedded_norm), y= all_exposures))) +
  geom_point(aes(color = condition)) +
  geom_smooth(method = "lm", se=FALSE) +
  labs(title = "Acceptability and Surprisal", 
       x = "Normalized Surprisal in Embedded", 
       y = "Mean Acceptability") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text())
plot


HEIGHT = 0.01
WIDTH = 0.1

plot = CIs_surp %>%
  ggplot((aes(x = mean, y= CIs_acc$mean))) +
  geom_point(aes(color = condition)) +
  geom_smooth(method = "lm", se=FALSE) +
  labs(title = "Acceptability and Surprisal", 
       x = "Normalized Surprisal in Embedded", 
       y = "Mean Acceptability") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text())
plot = plot + geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='WH', 'mean'], ymin=CIs_acc[CIs_acc$condition=='WH', 'lower'], ymax=CIs_acc[CIs_acc$condition=='WH', 'upper']), width=WIDTH, size=0.3) +
  geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='SUBJ', 'mean'], ymin=CIs_acc[CIs_acc$condition=='SUBJ', 'lower'], ymax=CIs_acc[CIs_acc$condition=='SUBJ', 'upper']), width=WIDTH, size=0.3)+ 
  #geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='POLAR', 'mean'], ymin=CIs_acc[CIs_acc$condition=='POLAR', 'lower'], ymax=CIs_acc[CIs_acc$condition=='POLAR', 'upper']), width=WIDTH, size=0.3)+
  #geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='FILL', 'mean'], ymin=CIs_acc[CIs_acc$condition=='FILL', 'lower'], ymax=CIs_acc[CIs_acc$condition=='FILL', 'upper']), width=WIDTH, size=.3)+
  #geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='UNGRAM', 'mean'], ymin=CIs_acc[CIs_acc$condition=='UNGRAM', 'lower'], ymax=CIs_acc[CIs_acc$condition=='UNGRAM', 'upper']), width=WIDTH, size=0.3)+
  geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='CNPC', 'mean'], ymin=CIs_acc[CIs_acc$condition=='CNPC', 'lower'], ymax=CIs_acc[CIs_acc$condition=='CNPC', 'upper']), width=WIDTH, size=0.3)+
  
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='WH', 'mean'], xmin=CIs_surp[CIs_surp$condition=='WH', 'lower'], xmax=CIs_surp[CIs_surp$condition=='WH', 'upper']), height=HEIGHT, size=0.3)+
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='SUBJ', 'mean'], xmin=CIs_surp[CIs_surp$condition=='SUBJ', 'lower'], xmax=CIs_surp[CIs_surp$condition=='SUBJ', 'upper']), height=HEIGHT, size=0.3)+
  #geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='POLAR', 'mean'], xmin=CIs_surp[CIs_surp$condition=='POLAR', 'lower'], xmax=CIs_surp[CIs_surp$condition=='POLAR', 'upper']), height=HEIGHT, size=0.3)+
  #geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='FILL', 'mean'], xmin=CIs_surp[CIs_surp$condition=='FILL', 'lower'], xmax=CIs_surp[CIs_surp$condition=='FILL', 'upper']), height=HEIGHT, size=0.3)+
  #geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='UNGRAM', 'mean'], xmin=CIs_surp[CIs_surp$condition=='UNGRAM', 'lower'], xmax=CIs_surp[CIs_surp$condition=='UNGRAM', 'upper']), height=HEIGHT, size=0.3)+
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='CNPC', 'mean'], xmin=CIs_surp[CIs_surp$condition=='CNPC', 'lower'], xmax=CIs_surp[CIs_surp$condition=='CNPC', 'upper']), height=HEIGHT, size=0.3)
plot


# matrix
CIs_acc_mean = double(0)
CIs_acc_upper = double(0)
CIs_acc_lower = double(0)
print(CIs_acc_mean)
for (cond in c('WH', 'SUBJ', 'CNPC')){
  CIs = CI(islands[islands$condition==cond, 'all_exposures'], ci=0.95)
  CIs_acc_mean = append(CIs_acc_mean, CIs['mean'])
  CIs_acc_upper = append(CIs_acc_upper, CIs['upper'])
  CIs_acc_lower = append(CIs_acc_lower, CIs['lower'])
}
print(CIs_acc_upper)

# put confidence interval numbers into a data frame for convenient access
CIs_acc = data.frame( 
  condition = c('WH', 'SUBJ','CNPC'),
  mean = CIs_acc_mean,
  upper = CIs_acc_upper,
  lower = CIs_acc_lower
)
print(CIs_acc)

# repeat for surprisal error bars
CIs_surp_mean = double(0)
CIs_surp_upper = double(0)
CIs_surp_lower = double(0)
for (cond in c('WH', 'SUBJ','CNPC')){
  CIs = CI(islands[islands$condition==cond, 'matrix_norm'], ci=0.95)
  CIs_surp_mean = append(CIs_surp_mean, CIs['mean'])
  CIs_surp_upper = append(CIs_surp_upper, CIs['upper'])
  CIs_surp_lower = append(CIs_surp_lower, CIs['lower'])
}
print(CIs_surp_upper)

CIs_surp = data.frame(
  condition = c('WH', 'SUBJ','CNPC'),
  mean = CIs_surp_mean,
  upper = CIs_surp_upper,
  lower = CIs_surp_lower
)
print(CIs_surp)
plot = islands %>%
  ggplot((aes(x = (matrix_norm), y= all_exposures))) +
  geom_point(aes(color = condition)) +
  geom_smooth(method = "lm", se=FALSE) +
  labs(title = "Acceptability and Surprisal", 
       x = "Normalized Surprisal in Matrix", 
       y = "Mean Acceptability") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text())
plot

plot = CIs_surp %>%
  ggplot((aes(x = mean, y= CIs_acc$mean))) +
  geom_point(aes(color = condition)) +
  geom_smooth(method = "lm", se=FALSE) +
  labs(title = "Acceptability and Surprisal", 
       x = "Normalized Surprisal in Matrix", 
       y = "Mean Acceptability") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text())
plot = plot + geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='WH', 'mean'], ymin=CIs_acc[CIs_acc$condition=='WH', 'lower'], ymax=CIs_acc[CIs_acc$condition=='WH', 'upper']), width=WIDTH, size=0.3) +
  geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='SUBJ', 'mean'], ymin=CIs_acc[CIs_acc$condition=='SUBJ', 'lower'], ymax=CIs_acc[CIs_acc$condition=='SUBJ', 'upper']), width=WIDTH, size=0.3)+ 
  #geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='POLAR', 'mean'], ymin=CIs_acc[CIs_acc$condition=='POLAR', 'lower'], ymax=CIs_acc[CIs_acc$condition=='POLAR', 'upper']), width=WIDTH, size=0.3)+
  #geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='FILL', 'mean'], ymin=CIs_acc[CIs_acc$condition=='FILL', 'lower'], ymax=CIs_acc[CIs_acc$condition=='FILL', 'upper']), width=WIDTH, size=.3)+
  #geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='UNGRAM', 'mean'], ymin=CIs_acc[CIs_acc$condition=='UNGRAM', 'lower'], ymax=CIs_acc[CIs_acc$condition=='UNGRAM', 'upper']), width=WIDTH, size=0.3)+
  geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='CNPC', 'mean'], ymin=CIs_acc[CIs_acc$condition=='CNPC', 'lower'], ymax=CIs_acc[CIs_acc$condition=='CNPC', 'upper']), width=WIDTH, size=0.3)+
  
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='WH', 'mean'], xmin=CIs_surp[CIs_surp$condition=='WH', 'lower'], xmax=CIs_surp[CIs_surp$condition=='WH', 'upper']), height=HEIGHT, size=0.3)+
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='SUBJ', 'mean'], xmin=CIs_surp[CIs_surp$condition=='SUBJ', 'lower'], xmax=CIs_surp[CIs_surp$condition=='SUBJ', 'upper']), height=HEIGHT, size=0.3)+
  #geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='POLAR', 'mean'], xmin=CIs_surp[CIs_surp$condition=='POLAR', 'lower'], xmax=CIs_surp[CIs_surp$condition=='POLAR', 'upper']), height=HEIGHT, size=0.3)+
  #geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='FILL', 'mean'], xmin=CIs_surp[CIs_surp$condition=='FILL', 'lower'], xmax=CIs_surp[CIs_surp$condition=='FILL', 'upper']), height=HEIGHT, size=0.3)+
  #geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='UNGRAM', 'mean'], xmin=CIs_surp[CIs_surp$condition=='UNGRAM', 'lower'], xmax=CIs_surp[CIs_surp$condition=='UNGRAM', 'upper']), height=HEIGHT, size=0.3)+
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='CNPC', 'mean'], xmin=CIs_surp[CIs_surp$condition=='CNPC', 'lower'], xmax=CIs_surp[CIs_surp$condition=='CNPC', 'upper']), height=HEIGHT, size=0.3)
plot


# comp
CIs_acc_mean = double(0)
CIs_acc_upper = double(0)
CIs_acc_lower = double(0)
print(CIs_acc_mean)
for (cond in c('WH', 'SUBJ', 'CNPC')){
  CIs = CI(islands[islands$condition==cond, 'all_exposures'], ci=0.95)
  CIs_acc_mean = append(CIs_acc_mean, CIs['mean'])
  CIs_acc_upper = append(CIs_acc_upper, CIs['upper'])
  CIs_acc_lower = append(CIs_acc_lower, CIs['lower'])
}
print(CIs_acc_upper)

# put confidence interval numbers into a data frame for convenient access
CIs_acc = data.frame( 
  condition = c('WH', 'SUBJ','CNPC'),
  mean = CIs_acc_mean,
  upper = CIs_acc_upper,
  lower = CIs_acc_lower
)
print(CIs_acc)

# repeat for surprisal error bars
CIs_surp_mean = double(0)
CIs_surp_upper = double(0)
CIs_surp_lower = double(0)
for (cond in c('WH', 'SUBJ','CNPC')){
  CIs = CI(islands[islands$condition==cond, 'comp_norm'], ci=0.95)
  CIs_surp_mean = append(CIs_surp_mean, CIs['mean'])
  CIs_surp_upper = append(CIs_surp_upper, CIs['upper'])
  CIs_surp_lower = append(CIs_surp_lower, CIs['lower'])
}
print(CIs_surp_upper)

CIs_surp = data.frame(
  condition = c('WH', 'SUBJ','CNPC'),
  mean = CIs_surp_mean,
  upper = CIs_surp_upper,
  lower = CIs_surp_lower
)
print(CIs_surp)
plot = islands %>%
  ggplot((aes(x = comp_norm, y= all_exposures))) +
  geom_point(aes(color = condition)) +
  geom_smooth(method = "lm", se=FALSE) +
  labs(title = "Acceptability and Surprisal", 
       x = "Surprisal of Comp", 
       y = "Mean Acceptability") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text())
plot

plot = CIs_surp %>%
  ggplot((aes(x = mean, y= CIs_acc$mean))) +
  geom_point(aes(color = condition)) +
  geom_smooth(method = "lm", se=FALSE) +
  labs(title = "Acceptability and Surprisal", 
       x = "Normalized Surprisal of Comp", 
       y = "Mean Acceptability") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text())
plot = plot + geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='WH', 'mean'], ymin=CIs_acc[CIs_acc$condition=='WH', 'lower'], ymax=CIs_acc[CIs_acc$condition=='WH', 'upper']), width=WIDTH, size=0.3) +
  geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='SUBJ', 'mean'], ymin=CIs_acc[CIs_acc$condition=='SUBJ', 'lower'], ymax=CIs_acc[CIs_acc$condition=='SUBJ', 'upper']), width=WIDTH, size=0.3)+ 
  #geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='POLAR', 'mean'], ymin=CIs_acc[CIs_acc$condition=='POLAR', 'lower'], ymax=CIs_acc[CIs_acc$condition=='POLAR', 'upper']), width=WIDTH, size=0.3)+
  #geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='FILL', 'mean'], ymin=CIs_acc[CIs_acc$condition=='FILL', 'lower'], ymax=CIs_acc[CIs_acc$condition=='FILL', 'upper']), width=WIDTH, size=.3)+
  #geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='UNGRAM', 'mean'], ymin=CIs_acc[CIs_acc$condition=='UNGRAM', 'lower'], ymax=CIs_acc[CIs_acc$condition=='UNGRAM', 'upper']), width=WIDTH, size=0.3)+
  geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='CNPC', 'mean'], ymin=CIs_acc[CIs_acc$condition=='CNPC', 'lower'], ymax=CIs_acc[CIs_acc$condition=='CNPC', 'upper']), width=WIDTH, size=0.3)+
  
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='WH', 'mean'], xmin=CIs_surp[CIs_surp$condition=='WH', 'lower'], xmax=CIs_surp[CIs_surp$condition=='WH', 'upper']), height=HEIGHT, size=0.3)+
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='SUBJ', 'mean'], xmin=CIs_surp[CIs_surp$condition=='SUBJ', 'lower'], xmax=CIs_surp[CIs_surp$condition=='SUBJ', 'upper']), height=HEIGHT, size=0.3)+
  #geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='POLAR', 'mean'], xmin=CIs_surp[CIs_surp$condition=='POLAR', 'lower'], xmax=CIs_surp[CIs_surp$condition=='POLAR', 'upper']), height=HEIGHT, size=0.3)+
  #geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='FILL', 'mean'], xmin=CIs_surp[CIs_surp$condition=='FILL', 'lower'], xmax=CIs_surp[CIs_surp$condition=='FILL', 'upper']), height=HEIGHT, size=0.3)+
  #geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='UNGRAM', 'mean'], xmin=CIs_surp[CIs_surp$condition=='UNGRAM', 'lower'], xmax=CIs_surp[CIs_surp$condition=='UNGRAM', 'upper']), height=HEIGHT, size=0.3)+
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='CNPC', 'mean'], xmin=CIs_surp[CIs_surp$condition=='CNPC', 'lower'], xmax=CIs_surp[CIs_surp$condition=='CNPC', 'upper']), height=HEIGHT, size=0.3)
plot

HEIGHT = 0.01
WIDTH = 0.1

### with threshold == 8.9 (mean surprisal of all sentences)
CIs_acc_mean = double(0)
CIs_acc_upper = double(0)
CIs_acc_lower = double(0)
print(CIs_acc_mean)
for (cond in c('WH', 'SUBJ', 'CNPC')){
  CIs = CI(islands[islands$condition==cond, 'all_exposures'], ci=0.95)
  CIs_acc_mean = append(CIs_acc_mean, CIs['mean'])
  CIs_acc_upper = append(CIs_acc_upper, CIs['upper'])
  CIs_acc_lower = append(CIs_acc_lower, CIs['lower'])
}
print(CIs_acc_upper)

# put confidence interval numbers into a data frame for convenient access
CIs_acc = data.frame( 
  condition = c('WH', 'SUBJ','CNPC'),
  mean = CIs_acc_mean,
  upper = CIs_acc_upper,
  lower = CIs_acc_lower
)
print(CIs_acc)

# repeat for surprisal error bars
CIs_surp_mean = double(0)
CIs_surp_upper = double(0)
CIs_surp_lower = double(0)
for (cond in c('WH', 'SUBJ','CNPC')){
  CIs = CI(islands[islands$condition==cond, 'beyond'], ci=0.95)
  CIs_surp_mean = append(CIs_surp_mean, CIs['mean'])
  CIs_surp_upper = append(CIs_surp_upper, CIs['upper'])
  CIs_surp_lower = append(CIs_surp_lower, CIs['lower'])
}
print(CIs_surp_upper)

CIs_surp = data.frame(
  condition = c('WH', 'SUBJ','CNPC'),
  mean = CIs_surp_mean,
  upper = CIs_surp_upper,
  lower = CIs_surp_lower
)
print(CIs_surp)
plot = islands %>%
  ggplot((aes(x = beyond, y= all_exposures, group = condition, color = condition))) +
  geom_point(aes(color = condition)) +
  geom_smooth(method = "lm", se=FALSE) +
  labs(title = "Acceptability and Surprisal", 
       x = "Mean Surprisal Beyond Threshold", 
       y = "Mean Acceptability") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text())
plot

plot = CIs_surp %>%
  ggplot((aes(x = mean, y= CIs_acc$mean))) +
  geom_point(aes(color = condition)) +
  geom_smooth(method = "lm", se=FALSE) +
  labs(title = "Acceptability and Surprisal", 
       x = "Mean Surprisal Beyond Threshold", 
       y = "Mean Acceptability") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text())
plot = plot + geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='WH', 'mean'], ymin=CIs_acc[CIs_acc$condition=='WH', 'lower'], ymax=CIs_acc[CIs_acc$condition=='WH', 'upper']), width=WIDTH, size=0.3) +
  geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='SUBJ', 'mean'], ymin=CIs_acc[CIs_acc$condition=='SUBJ', 'lower'], ymax=CIs_acc[CIs_acc$condition=='SUBJ', 'upper']), width=WIDTH, size=0.3)+ 
  #geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='POLAR', 'mean'], ymin=CIs_acc[CIs_acc$condition=='POLAR', 'lower'], ymax=CIs_acc[CIs_acc$condition=='POLAR', 'upper']), width=WIDTH, size=0.3)+
  #geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='FILL', 'mean'], ymin=CIs_acc[CIs_acc$condition=='FILL', 'lower'], ymax=CIs_acc[CIs_acc$condition=='FILL', 'upper']), width=WIDTH, size=.3)+
  #geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='UNGRAM', 'mean'], ymin=CIs_acc[CIs_acc$condition=='UNGRAM', 'lower'], ymax=CIs_acc[CIs_acc$condition=='UNGRAM', 'upper']), width=WIDTH, size=0.3)+
  geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='CNPC', 'mean'], ymin=CIs_acc[CIs_acc$condition=='CNPC', 'lower'], ymax=CIs_acc[CIs_acc$condition=='CNPC', 'upper']), width=WIDTH, size=0.3)+
  
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='WH', 'mean'], xmin=CIs_surp[CIs_surp$condition=='WH', 'lower'], xmax=CIs_surp[CIs_surp$condition=='WH', 'upper']), height=HEIGHT, size=0.3)+
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='SUBJ', 'mean'], xmin=CIs_surp[CIs_surp$condition=='SUBJ', 'lower'], xmax=CIs_surp[CIs_surp$condition=='SUBJ', 'upper']), height=HEIGHT, size=0.3)+
  #geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='POLAR', 'mean'], xmin=CIs_surp[CIs_surp$condition=='POLAR', 'lower'], xmax=CIs_surp[CIs_surp$condition=='POLAR', 'upper']), height=HEIGHT, size=0.3)+
  #geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='FILL', 'mean'], xmin=CIs_surp[CIs_surp$condition=='FILL', 'lower'], xmax=CIs_surp[CIs_surp$condition=='FILL', 'upper']), height=HEIGHT, size=0.3)+
  #geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='UNGRAM', 'mean'], xmin=CIs_surp[CIs_surp$condition=='UNGRAM', 'lower'], xmax=CIs_surp[CIs_surp$condition=='UNGRAM', 'upper']), height=HEIGHT, size=0.3)+
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='CNPC', 'mean'], xmin=CIs_surp[CIs_surp$condition=='CNPC', 'lower'], xmax=CIs_surp[CIs_surp$condition=='CNPC', 'upper']), height=HEIGHT, size=0.3)
plot

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

islands_all_chunks <- lm(all_exposures ~ wh*matrix*comp*embedded*gap, islands)
islands_all_embedded <- lm(first_three_exposures ~ embedded, islands)
summary(islands_all_chunks)
summary(islands_all_embedded)

islands_all_gap <- lm(all_exposures ~ gap, islands)
summary(islands_all_gap)
islands_all_embedded_gap <- lm(all_exposures ~ embedded*gap, islands)
summary(islands_all_embedded_gap)

islands_all_gap <- lm(all_exposures~gap, islands)
summary(islands_all_gap)

islands_all_norm <- lm(all_exposures~normalized, islands)
summary(islands_all_norm)

islands_all_mean <- lm(all_exposures~mean_surprisal, islands)
summary(islands_all_mean)






