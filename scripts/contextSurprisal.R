library(tidyverse)
library(ggplot2)
library(ggthemes)

adapt = read.csv("data/adaptContextRatings.csv")
gen = read.csv("data/genContextRatings.csv")
all = rbind(adapt, gen)
islands = filter(all, condition %in% c("CNPC", "SUBJ", "WH"))
plot = all %>%
  ggplot((aes(x = mean_surprisal, y= all_exposures))) +
  geom_point(aes(color = condition)) +
  geom_smooth(method = "lm", se=FALSE) +
  labs(title = "Mean Acceptability and Surprisal", 
       x = "Mean Surprisal", 
       y = "Mean Acceptability") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text())
plot

plot = all %>%
  ggplot((aes(x = normalized, y= all_exposures))) +
  geom_point(aes(color = condition)) +
  geom_smooth(method = "lm", se=FALSE) +
  labs(title = "Mean Acceptability and Surprisal", 
       x = "Normalized Surprisal", 
       y = "Mean Acceptability") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text())
plot

plot = islands %>%
  ggplot((aes(x = gap, y= all_exposures, group = condition, color = condition))) +
  geom_point(aes(color = condition)) +
  geom_smooth(method = "lm") +
  labs(title = "Mean Acceptability and Surprisal", 
       x = "Post Gap Surprisal", 
       y = "Mean Acceptability") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text())
plot

# Error bars for post gap surprisal graph
CIs_acc_mean = double(0)
CIs_acc_upper = double(0)
CIs_acc_lower = double(0)
for (cond in c('CNPC', 'SUBJ', 'WH')){
  CIs = CI(islands[islands$condition==cond, "all_exposures"], ci=0.95)
  CIs_acc_mean = append(CIs_acc_mean, CIs['mean'])
  CIs_acc_upper = append(CIs_acc_upper, CIs['upper'])
  CIs_acc_lower = append(CIs_acc_lower, CIs['lower'])
}

# put confidence interval numbers into a data frame for convenient access
CIs_acc = data.frame( 
  condition = c('CNPC', 'SUBJ', 'WH'),
  mean = CIs_acc_mean,
  upper = CIs_acc_upper,
  lower = CIs_acc_lower
)

# repeat for surprisal error bars
CIs_surp_mean = double(0)
CIs_surp_upper = double(0)
CIs_surp_lower = double(0)
for (cond in c('CNPC', 'SUBJ', 'WH')){
  CIs = CI(islands[islands$condition==cond, "gap"], ci=0.95)
  CIs_surp_mean = append(CIs_surp_mean, CIs['mean'])
  CIs_surp_upper = append(CIs_surp_upper, CIs['upper'])
  CIs_surp_lower = append(CIs_surp_lower, CIs['lower'])
}
print(CIs_surp_mean)
print(mean(islands$mean_surprisal))

CIs_surp = data.frame(
  condition = c('CNPC', 'SUBJ', 'WH'),
  mean = CIs_surp_mean,
  upper = CIs_surp_upper,
  lower = CIs_surp_lower
)
print(CIs_surp)

plot = CIs_surp %>%
  ggplot((aes(x = mean, y= CIs_acc$mean))) +
  geom_point(aes(color = condition)) +
  geom_smooth(method = "lm", se=FALSE) +
  labs(title = "Mean Acceptability and Surprisal", 
       x = "Post-Gap Surprisal", 
       y = "Mean Acceptability") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text())

HEIGHT = 0.01
WIDTH = 0.1
plot = plot + geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='WH', 'mean'], ymin=CIs_acc[CIs_acc$condition=='WH', 'lower'], ymax=CIs_acc[CIs_acc$condition=='WH', 'upper']), width=WIDTH, size=0.3) +
  geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='SUBJ', 'mean'], ymin=CIs_acc[CIs_acc$condition=='SUBJ', 'lower'], ymax=CIs_acc[CIs_acc$condition=='SUBJ', 'upper']), width=WIDTH, size=0.3)+ 
  geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='CNPC', 'mean'], ymin=CIs_acc[CIs_acc$condition=='CNPC', 'lower'], ymax=CIs_acc[CIs_acc$condition=='CNPC', 'upper']), width=WIDTH, size=0.3)+

  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='WH', 'mean'], xmin=CIs_surp[CIs_surp$condition=='WH', 'lower'], xmax=CIs_surp[CIs_surp$condition=='WH', 'upper']), height=HEIGHT, size=0.3)+
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='SUBJ', 'mean'], xmin=CIs_surp[CIs_surp$condition=='SUBJ', 'lower'], xmax=CIs_surp[CIs_surp$condition=='SUBJ', 'upper']), height=HEIGHT, size=0.3)+
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='CNPC', 'mean'], xmin=CIs_surp[CIs_surp$condition=='CNPC', 'lower'], xmax=CIs_surp[CIs_surp$condition=='CNPC', 'upper']), height=HEIGHT, size=0.3)
plot
ggsave(filename = 'post_gap_islands_w_context_error_bars.png', path="plots")

plot = islands %>%
  ggplot((aes(x = gap, y= all_exposures))) +
  geom_point(aes(color = condition)) +
  geom_smooth(method = "lm", se=FALSE) +
  labs(title = "Mean Acceptability and Surprisal", 
       x = "Post Gap Surprisal", 
       y = "Mean Acceptability") +
  xlim(0, 30) + 
  ylim(0, 1) + 
  theme_fivethirtyeight() +
  theme(axis.title = element_text())
plot
ggsave(filename = 'mean_surp.png', path="plots/lu_kim_2022")


test = filter(islands, condition %in% c("WH", "CNPC"))