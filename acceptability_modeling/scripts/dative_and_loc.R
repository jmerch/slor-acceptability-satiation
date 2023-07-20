library(tidyverse)
library(ggplot2)
library(ggthemes)
library(Rmisc)

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
print(all_experiments[400,])

# Plot with Lu island data and dative,locative data

# for acceptability error bars: create lists of the mean, upper, and lower of confidence intervals for each condition
CIs_acc_mean = double(0)
CIs_acc_upper = double(0)
CIs_acc_lower = double(0)
for (cond in c('WH', 'SUBJ', 'POLAR', 'FILL', 'UNGRAM', 'CNPC', 'dative-match-gap', 'dative-match-nogap', 'dative-mismatch-gap', 'dative-mismatch-nogap','locative-match-gap', 'locative-match-nogap', 'locative-mismatch-gap', 'locative-mismatch-nogap')){
  CIs = CI(all_experiments[all_experiments$condition==cond, "mean_acc"], ci=0.95)
  CIs_acc_mean = append(CIs_acc_mean, CIs['mean'])
  CIs_acc_upper = append(CIs_acc_upper, CIs['upper'])
  CIs_acc_lower = append(CIs_acc_lower, CIs['lower'])
}
print(CIs_acc_mean)
print(CIs_acc_upper)

# put confidence interval numbers into a data frame for convenient access
CIs_acc = data.frame( 
  condition = c('WH', 'SUBJ', 'POLAR', 'FILL', 'UNGRAM', 'CNPC', 'dative-match-gap', 'dative-match-nogap', 'dative-mismatch-gap', 'dative-mismatch-nogap','locative-match-gap', 'locative-match-nogap', 'locative-mismatch-gap', 'locative-mismatch-nogap'),
  mean = CIs_acc_mean,
  upper = CIs_acc_upper,
  lower = CIs_acc_lower
)
print(CIs_acc)

# repeat for surprisal error bars
CIs_surp_mean = double(0)
CIs_surp_upper = double(0)
CIs_surp_lower = double(0)
for (cond in c('WH', 'SUBJ', 'POLAR', 'FILL', 'UNGRAM', 'CNPC', 'dative-match-gap', 'dative-match-nogap', 'dative-mismatch-gap', 'dative-mismatch-nogap','locative-match-gap', 'locative-match-nogap', 'locative-mismatch-gap', 'locative-mismatch-nogap')){
  CIs = CI(all_experiments[all_experiments$condition==cond, "mean_surprisal"], ci=0.95)
  CIs_surp_mean = append(CIs_surp_mean, CIs['mean'])
  CIs_surp_upper = append(CIs_surp_upper, CIs['upper'])
  CIs_surp_lower = append(CIs_surp_lower, CIs['lower'])
}

CIs_surp = data.frame(
  condition = c('WH', 'SUBJ', 'POLAR', 'FILL', 'UNGRAM', 'CNPC', 'dative-match-gap', 'dative-match-nogap', 'dative-mismatch-gap', 'dative-mismatch-nogap','locative-match-gap', 'locative-match-nogap', 'locative-mismatch-gap', 'locative-mismatch-nogap'),
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
  geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='dative-match-gap', 'mean'], ymin=CIs_acc[CIs_acc$condition=='dative-match-gap', 'lower'], ymax=CIs_acc[CIs_acc$condition=='dative-match-gap', 'upper']), width=WIDTH, size=0.3)+
  geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='dative-match-nogap', 'mean'], ymin=CIs_acc[CIs_acc$condition=='dative-match-nogap', 'lower'], ymax=CIs_acc[CIs_acc$condition=='dative-match-nogap', 'upper']), width=WIDTH, size=0.3)+
  geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='dative-mismatch-gap', 'mean'], ymin=CIs_acc[CIs_acc$condition=='dative-mismatch-gap', 'lower'], ymax=CIs_acc[CIs_acc$condition=='dative-mismatch-gap', 'upper']), width=WIDTH, size=0.3)+
  geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='dative-mismatch-nogap', 'mean'], ymin=CIs_acc[CIs_acc$condition=='dative-mismatch-nogap', 'lower'], ymax=CIs_acc[CIs_acc$condition=='dative-mismatch-nogap', 'upper']), width=WIDTH, size=0.3)+
  geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='locative-match-gap', 'mean'], ymin=CIs_acc[CIs_acc$condition=='locative-match-gap', 'lower'], ymax=CIs_acc[CIs_acc$condition=='locative-match-gap', 'upper']), width=WIDTH, size=0.3)+
  geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='locative-match-nogap', 'mean'], ymin=CIs_acc[CIs_acc$condition=='locative-match-nogap', 'lower'], ymax=CIs_acc[CIs_acc$condition=='locative-match-nogap', 'upper']), width=WIDTH, size=0.3)+
  geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='locative-mismatch-gap', 'mean'], ymin=CIs_acc[CIs_acc$condition=='locative-mismatch-gap', 'lower'], ymax=CIs_acc[CIs_acc$condition=='locative-mismatch-gap', 'upper']), width=WIDTH, size=0.3)+
  geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='locative-mismatch-nogap', 'mean'], ymin=CIs_acc[CIs_acc$condition=='locative-mismatch-nogap', 'lower'], ymax=CIs_acc[CIs_acc$condition=='locative-mismatch-nogap', 'upper']), width=WIDTH, size=0.3)+
  
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='WH', 'mean'], xmin=CIs_surp[CIs_surp$condition=='WH', 'lower'], xmax=CIs_surp[CIs_surp$condition=='WH', 'upper']), height=HEIGHT, size=0.3)+
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='SUBJ', 'mean'], xmin=CIs_surp[CIs_surp$condition=='SUBJ', 'lower'], xmax=CIs_surp[CIs_surp$condition=='SUBJ', 'upper']), height=HEIGHT, size=0.3)+
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='POLAR', 'mean'], xmin=CIs_surp[CIs_surp$condition=='POLAR', 'lower'], xmax=CIs_surp[CIs_surp$condition=='POLAR', 'upper']), height=HEIGHT, size=0.3)+
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='FILL', 'mean'], xmin=CIs_surp[CIs_surp$condition=='FILL', 'lower'], xmax=CIs_surp[CIs_surp$condition=='FILL', 'upper']), height=HEIGHT, size=0.3)+
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='UNGRAM', 'mean'], xmin=CIs_surp[CIs_surp$condition=='UNGRAM', 'lower'], xmax=CIs_surp[CIs_surp$condition=='UNGRAM', 'upper']), height=HEIGHT, size=0.3)+
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='CNPC', 'mean'], xmin=CIs_surp[CIs_surp$condition=='CNPC', 'lower'], xmax=CIs_surp[CIs_surp$condition=='CNPC', 'upper']), height=HEIGHT, size=0.3)+
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='dative-match-gap', 'mean'], xmin=CIs_surp[CIs_surp$condition=='dative-match-gap', 'lower'], xmax=CIs_surp[CIs_surp$condition=='dative-match-gap', 'upper']), height=HEIGHT, size=0.3)+
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='dative-match-nogap', 'mean'], xmin=CIs_surp[CIs_surp$condition=='dative-match-nogap', 'lower'], xmax=CIs_surp[CIs_surp$condition=='dative-match-nogap', 'upper']), height=HEIGHT, size=0.3)+
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='dative-mismatch-gap', 'mean'], xmin=CIs_surp[CIs_surp$condition=='dative-mismatch-gap', 'lower'], xmax=CIs_surp[CIs_surp$condition=='dative-mismatch-gap', 'upper']), height=HEIGHT, size=0.3)+
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='dative-mismatch-nogap', 'mean'], xmin=CIs_surp[CIs_surp$condition=='dative-mismatch-nogap', 'lower'], xmax=CIs_surp[CIs_surp$condition=='dative-mismatch-nogap', 'upper']), height=HEIGHT, size=0.3)+
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='locative-match-gap', 'mean'], xmin=CIs_surp[CIs_surp$condition=='locative-match-gap', 'lower'], xmax=CIs_surp[CIs_surp$condition=='locative-match-gap', 'upper']), height=HEIGHT, size=0.3)+
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='locative-match-nogap', 'mean'], xmin=CIs_surp[CIs_surp$condition=='locative-match-nogap', 'lower'], xmax=CIs_surp[CIs_surp$condition=='locative-match-nogap', 'upper']), height=HEIGHT, size=0.3)+
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='locative-mismatch-gap', 'mean'], xmin=CIs_surp[CIs_surp$condition=='locative-mismatch-gap', 'lower'], xmax=CIs_surp[CIs_surp$condition=='locative-mismatch-gap', 'upper']), height=HEIGHT, size=0.3)+
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='locative-mismatch-nogap', 'mean'], xmin=CIs_surp[CIs_surp$condition=='locative-mismatch-nogap', 'lower'], xmax=CIs_surp[CIs_surp$condition=='locative-mismatch-nogap', 'upper']), height=HEIGHT, size=0.3)
plot
ggsave(filename = 'mean_surp_error_bars.png', path="plots/lu_kim_2022")

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
ggsave(filename = 'mean_surp.png', path="plots/lu_kim_2022")

# Normalized plot
#CIs_acc is same as previous unnormalized
# calculate for surprisal error bars
CIs_surp_mean = double(0)
CIs_surp_upper = double(0)
CIs_surp_lower = double(0)
for (cond in c('WH', 'SUBJ', 'POLAR', 'FILL', 'UNGRAM', 'CNPC', 'dative-match-gap', 'dative-match-nogap', 'dative-mismatch-gap', 'dative-mismatch-nogap','locative-match-gap', 'locative-match-nogap', 'locative-mismatch-gap', 'locative-mismatch-nogap')){
  CIs = CI(all_experiments[all_experiments$condition==cond, "normalized"], ci=0.95)
  CIs_surp_mean = append(CIs_surp_mean, CIs['mean'])
  CIs_surp_upper = append(CIs_surp_upper, CIs['upper'])
  CIs_surp_lower = append(CIs_surp_lower, CIs['lower'])
}

CIs_surp = data.frame(
  condition = c('WH', 'SUBJ', 'POLAR', 'FILL', 'UNGRAM', 'CNPC', 'dative-match-gap', 'dative-match-nogap', 'dative-mismatch-gap', 'dative-mismatch-nogap','locative-match-gap', 'locative-match-nogap', 'locative-mismatch-gap', 'locative-mismatch-nogap'),
  mean = CIs_surp_mean,
  upper = CIs_surp_upper,
  lower = CIs_surp_lower
)
print(CIs_surp)

plot = CIs_surp %>%
  ggplot((aes(x = mean, y= CIs_acc$mean))) +
  geom_point(aes(color = condition)) +
  geom_smooth(method = "lm", se=FALSE) +
  labs(title = "Mean Acceptability and Normalized Surprisal", 
       x = "Normalized Surprisal", 
       y = "Mean Acceptability") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text())
plot
linear = lm(CIs_acc$mean~CIs_surp$mean, CIs_surp)

HEIGHT = 0.01
WIDTH = 0.1
plot = plot + geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='WH', 'mean'], ymin=CIs_acc[CIs_acc$condition=='WH', 'lower'], ymax=CIs_acc[CIs_acc$condition=='WH', 'upper']), width=WIDTH, size=0.3) +
  geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='SUBJ', 'mean'], ymin=CIs_acc[CIs_acc$condition=='SUBJ', 'lower'], ymax=CIs_acc[CIs_acc$condition=='SUBJ', 'upper']), width=WIDTH, size=0.3)+ 
  geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='POLAR', 'mean'], ymin=CIs_acc[CIs_acc$condition=='POLAR', 'lower'], ymax=CIs_acc[CIs_acc$condition=='POLAR', 'upper']), width=WIDTH, size=0.3)+
  geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='FILL', 'mean'], ymin=CIs_acc[CIs_acc$condition=='FILL', 'lower'], ymax=CIs_acc[CIs_acc$condition=='FILL', 'upper']), width=WIDTH, size=.3)+
  geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='UNGRAM', 'mean'], ymin=CIs_acc[CIs_acc$condition=='UNGRAM', 'lower'], ymax=CIs_acc[CIs_acc$condition=='UNGRAM', 'upper']), width=WIDTH, size=0.3)+
  geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='CNPC', 'mean'], ymin=CIs_acc[CIs_acc$condition=='CNPC', 'lower'], ymax=CIs_acc[CIs_acc$condition=='CNPC', 'upper']), width=WIDTH, size=0.3)+
  geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='dative-match-gap', 'mean'], ymin=CIs_acc[CIs_acc$condition=='dative-match-gap', 'lower'], ymax=CIs_acc[CIs_acc$condition=='dative-match-gap', 'upper']), width=WIDTH, size=0.3)+
  geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='dative-match-nogap', 'mean'], ymin=CIs_acc[CIs_acc$condition=='dative-match-nogap', 'lower'], ymax=CIs_acc[CIs_acc$condition=='dative-match-nogap', 'upper']), width=WIDTH, size=0.3)+
  geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='dative-mismatch-gap', 'mean'], ymin=CIs_acc[CIs_acc$condition=='dative-mismatch-gap', 'lower'], ymax=CIs_acc[CIs_acc$condition=='dative-mismatch-gap', 'upper']), width=WIDTH, size=0.3)+
  geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='dative-mismatch-nogap', 'mean'], ymin=CIs_acc[CIs_acc$condition=='dative-mismatch-nogap', 'lower'], ymax=CIs_acc[CIs_acc$condition=='dative-mismatch-nogap', 'upper']), width=WIDTH, size=0.3)+
  geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='locative-match-gap', 'mean'], ymin=CIs_acc[CIs_acc$condition=='locative-match-gap', 'lower'], ymax=CIs_acc[CIs_acc$condition=='locative-match-gap', 'upper']), width=WIDTH, size=0.3)+
  geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='locative-match-nogap', 'mean'], ymin=CIs_acc[CIs_acc$condition=='locative-match-nogap', 'lower'], ymax=CIs_acc[CIs_acc$condition=='locative-match-nogap', 'upper']), width=WIDTH, size=0.3)+
  geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='locative-mismatch-gap', 'mean'], ymin=CIs_acc[CIs_acc$condition=='locative-mismatch-gap', 'lower'], ymax=CIs_acc[CIs_acc$condition=='locative-mismatch-gap', 'upper']), width=WIDTH, size=0.3)+
  geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='locative-mismatch-nogap', 'mean'], ymin=CIs_acc[CIs_acc$condition=='locative-mismatch-nogap', 'lower'], ymax=CIs_acc[CIs_acc$condition=='locative-mismatch-nogap', 'upper']), width=WIDTH, size=0.3)+
  
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='WH', 'mean'], xmin=CIs_surp[CIs_surp$condition=='WH', 'lower'], xmax=CIs_surp[CIs_surp$condition=='WH', 'upper']), height=HEIGHT, size=0.3)+
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='SUBJ', 'mean'], xmin=CIs_surp[CIs_surp$condition=='SUBJ', 'lower'], xmax=CIs_surp[CIs_surp$condition=='SUBJ', 'upper']), height=HEIGHT, size=0.3)+
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='POLAR', 'mean'], xmin=CIs_surp[CIs_surp$condition=='POLAR', 'lower'], xmax=CIs_surp[CIs_surp$condition=='POLAR', 'upper']), height=HEIGHT, size=0.3)+
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='FILL', 'mean'], xmin=CIs_surp[CIs_surp$condition=='FILL', 'lower'], xmax=CIs_surp[CIs_surp$condition=='FILL', 'upper']), height=HEIGHT, size=0.3)+
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='UNGRAM', 'mean'], xmin=CIs_surp[CIs_surp$condition=='UNGRAM', 'lower'], xmax=CIs_surp[CIs_surp$condition=='UNGRAM', 'upper']), height=HEIGHT, size=0.3)+
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='CNPC', 'mean'], xmin=CIs_surp[CIs_surp$condition=='CNPC', 'lower'], xmax=CIs_surp[CIs_surp$condition=='CNPC', 'upper']), height=HEIGHT, size=0.3)+
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='dative-match-gap', 'mean'], xmin=CIs_surp[CIs_surp$condition=='dative-match-gap', 'lower'], xmax=CIs_surp[CIs_surp$condition=='dative-match-gap', 'upper']), height=HEIGHT, size=0.3)+
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='dative-match-nogap', 'mean'], xmin=CIs_surp[CIs_surp$condition=='dative-match-nogap', 'lower'], xmax=CIs_surp[CIs_surp$condition=='dative-match-nogap', 'upper']), height=HEIGHT, size=0.3)+
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='dative-mismatch-gap', 'mean'], xmin=CIs_surp[CIs_surp$condition=='dative-mismatch-gap', 'lower'], xmax=CIs_surp[CIs_surp$condition=='dative-mismatch-gap', 'upper']), height=HEIGHT, size=0.3)+
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='dative-mismatch-nogap', 'mean'], xmin=CIs_surp[CIs_surp$condition=='dative-mismatch-nogap', 'lower'], xmax=CIs_surp[CIs_surp$condition=='dative-mismatch-nogap', 'upper']), height=HEIGHT, size=0.3)+
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='locative-match-gap', 'mean'], xmin=CIs_surp[CIs_surp$condition=='locative-match-gap', 'lower'], xmax=CIs_surp[CIs_surp$condition=='locative-match-gap', 'upper']), height=HEIGHT, size=0.3)+
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='locative-match-nogap', 'mean'], xmin=CIs_surp[CIs_surp$condition=='locative-match-nogap', 'lower'], xmax=CIs_surp[CIs_surp$condition=='locative-match-nogap', 'upper']), height=HEIGHT, size=0.3)+
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='locative-mismatch-gap', 'mean'], xmin=CIs_surp[CIs_surp$condition=='locative-mismatch-gap', 'lower'], xmax=CIs_surp[CIs_surp$condition=='locative-mismatch-gap', 'upper']), height=HEIGHT, size=0.3)+
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='locative-mismatch-nogap', 'mean'], xmin=CIs_surp[CIs_surp$condition=='locative-mismatch-nogap', 'lower'], xmax=CIs_surp[CIs_surp$condition=='locative-mismatch-nogap', 'upper']), height=HEIGHT, size=0.3)
plot
ggsave(filename = 'norm_surp_error_bars.png', path="plots/lu_kim_2022")

plot = all_experiments %>%
  ggplot((aes(x = normalized, y= mean_acc))) +
  geom_point(aes(color = condition)) +
  geom_smooth(method = "lm", se=FALSE) +
  labs(title = "Mean Acceptability and Normalized Surprisal",
       x = "Normalized Surprisal",
       y = "Mean Acceptability") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text())
plot
ggsave(filename = 'norm_surp.png', path="plots/lu_kim_2022")


# Error bars for disjunction
CIs_acc_mean = double(0)
CIs_acc_upper = double(0)
CIs_acc_lower = double(0)
for (cond in c('alt', 'filler_bad', 'filler_good', 'gram', 'no_alt')){
  CIs = CI(disjunction[disjunction$condition==cond, "mean_acc"], ci=0.95)
  CIs_acc_mean = append(CIs_acc_mean, CIs['mean'])
  CIs_acc_upper = append(CIs_acc_upper, CIs['upper'])
  CIs_acc_lower = append(CIs_acc_lower, CIs['lower'])
}
CIs_acc = data.frame( 
  condition = c('alt', 'filler_bad', 'filler_good', 'gram', 'no_alt'),
  mean = CIs_acc_mean,
  upper = CIs_acc_upper,
  lower = CIs_acc_lower
)

CIs_surp_mean = double(0)
CIs_surp_upper = double(0)
CIs_surp_lower = double(0)
for (cond in c('alt', 'filler_bad', 'filler_good', 'gram', 'no_alt')){
  CIs = CI(disjunction[disjunction$condition==cond, "mean_surprisal"], ci=0.95)
  CIs_surp_mean = append(CIs_surp_mean, CIs['mean'])
  CIs_surp_upper = append(CIs_surp_upper, CIs['upper'])
  CIs_surp_lower = append(CIs_surp_lower, CIs['lower'])
}
CIs_surp = data.frame(
  condition = c('alt', 'filler_bad', 'filler_good', 'gram', 'no_alt'),
  mean = CIs_surp_mean,
  upper = CIs_surp_upper,
  lower = CIs_surp_lower
)
print(CIs_surp)

plot = CIs_surp %>%
  ggplot((aes(x = mean, y= CIs_acc$mean))) +
  geom_point(aes(color = condition)) +
  geom_smooth(method = "lm", se=FALSE) +
  labs(title = "Disjunction Mean Acceptability and Surprisal", 
       x = "Mean Surprisal", 
       y = "Mean Acceptability") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text())

HEIGHT = 0.01
WIDTH = 0.1
plot = plot + geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='alt', 'mean'], ymin=CIs_acc[CIs_acc$condition=='alt', 'lower'], ymax=CIs_acc[CIs_acc$condition=='alt', 'upper']), width=WIDTH, size=0.3) +
  geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='filler_good', 'mean'], ymin=CIs_acc[CIs_acc$condition=='filler_good', 'lower'], ymax=CIs_acc[CIs_acc$condition=='filler_good', 'upper']), width=WIDTH, size=0.3)+ 
  geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='filler_bad', 'mean'], ymin=CIs_acc[CIs_acc$condition=='filler_bad', 'lower'], ymax=CIs_acc[CIs_acc$condition=='filler_bad', 'upper']), width=WIDTH, size=0.3)+
  geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='gram', 'mean'], ymin=CIs_acc[CIs_acc$condition=='gram', 'lower'], ymax=CIs_acc[CIs_acc$condition=='gram', 'upper']), width=WIDTH, size=.3)+
  geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='no_alt', 'mean'], ymin=CIs_acc[CIs_acc$condition=='no_alt', 'lower'], ymax=CIs_acc[CIs_acc$condition=='no_alt', 'upper']), width=WIDTH, size=0.3)+

  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='alt', 'mean'], xmin=CIs_surp[CIs_surp$condition=='alt', 'lower'], xmax=CIs_surp[CIs_surp$condition=='alt', 'upper']), height=HEIGHT, size=0.3)+
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='filler_good', 'mean'], xmin=CIs_surp[CIs_surp$condition=='filler_good', 'lower'], xmax=CIs_surp[CIs_surp$condition=='filler_good', 'upper']), height=HEIGHT, size=0.3)+
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='filler_bad', 'mean'], xmin=CIs_surp[CIs_surp$condition=='filler_bad', 'lower'], xmax=CIs_surp[CIs_surp$condition=='filler_bad', 'upper']), height=HEIGHT, size=0.3)+
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='gram', 'mean'], xmin=CIs_surp[CIs_surp$condition=='gram', 'lower'], xmax=CIs_surp[CIs_surp$condition=='gram', 'upper']), height=HEIGHT, size=0.3)+
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='no_alt', 'mean'], xmin=CIs_surp[CIs_surp$condition=='no_alt', 'lower'], xmax=CIs_surp[CIs_surp$condition=='no_alt', 'upper']), height=HEIGHT, size=0.3)
plot
ggsave(filename = 'mean_surp_error_bars.png', path="plots/disjunction")

plot = disjunction %>%
  ggplot((aes(x = mean_surprisal, y= mean_acc))) +
  geom_point(aes(color = condition)) +
  geom_smooth(method = "lm", se=FALSE) +
  labs(title = "Disjunction Mean Acceptability and Surprisal", 
       x = "Mean Surprisal", 
       y = "Mean Acceptability") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text()) 
plot
ggsave(filename = 'mean_surp.png', path="plots/disjunction")

#for normalized disjunction
CIs_surp_mean = double(0)
CIs_surp_upper = double(0)
CIs_surp_lower = double(0)
for (cond in c('alt', 'filler_bad', 'filler_good', 'gram', 'no_alt')){
  CIs = CI(disjunction[disjunction$condition==cond, "normalized"], ci=0.95)
  CIs_surp_mean = append(CIs_surp_mean, CIs['mean'])
  CIs_surp_upper = append(CIs_surp_upper, CIs['upper'])
  CIs_surp_lower = append(CIs_surp_lower, CIs['lower'])
}
CIs_surp = data.frame(
  condition = c('alt', 'filler_bad', 'filler_good', 'gram', 'no_alt'),
  mean = CIs_surp_mean,
  upper = CIs_surp_upper,
  lower = CIs_surp_lower
)
print(CIs_surp)

plot = CIs_surp %>%
  ggplot((aes(x = mean, y= CIs_acc$mean))) +
  geom_point(aes(color = condition)) +
  geom_smooth(method = "lm", se=FALSE) +
  labs(title = "Disjunction Mean Acceptability and Normalized Surprisal", 
       x = "Normalized Surprisal", 
       y = "Mean Acceptability") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text())

HEIGHT = 0.01
WIDTH = 0.1
plot = plot + geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='alt', 'mean'], ymin=CIs_acc[CIs_acc$condition=='alt', 'lower'], ymax=CIs_acc[CIs_acc$condition=='alt', 'upper']), width=WIDTH, size=0.3) +
  geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='filler_good', 'mean'], ymin=CIs_acc[CIs_acc$condition=='filler_good', 'lower'], ymax=CIs_acc[CIs_acc$condition=='filler_good', 'upper']), width=WIDTH, size=0.3)+ 
  geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='filler_bad', 'mean'], ymin=CIs_acc[CIs_acc$condition=='filler_bad', 'lower'], ymax=CIs_acc[CIs_acc$condition=='filler_bad', 'upper']), width=WIDTH, size=0.3)+
  geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='gram', 'mean'], ymin=CIs_acc[CIs_acc$condition=='gram', 'lower'], ymax=CIs_acc[CIs_acc$condition=='gram', 'upper']), width=WIDTH, size=.3)+
  geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='no_alt', 'mean'], ymin=CIs_acc[CIs_acc$condition=='no_alt', 'lower'], ymax=CIs_acc[CIs_acc$condition=='no_alt', 'upper']), width=WIDTH, size=0.3)+
  
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='alt', 'mean'], xmin=CIs_surp[CIs_surp$condition=='alt', 'lower'], xmax=CIs_surp[CIs_surp$condition=='alt', 'upper']), height=HEIGHT, size=0.3)+
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='filler_good', 'mean'], xmin=CIs_surp[CIs_surp$condition=='filler_good', 'lower'], xmax=CIs_surp[CIs_surp$condition=='filler_good', 'upper']), height=HEIGHT, size=0.3)+
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='filler_bad', 'mean'], xmin=CIs_surp[CIs_surp$condition=='filler_bad', 'lower'], xmax=CIs_surp[CIs_surp$condition=='filler_bad', 'upper']), height=HEIGHT, size=0.3)+
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='gram', 'mean'], xmin=CIs_surp[CIs_surp$condition=='gram', 'lower'], xmax=CIs_surp[CIs_surp$condition=='gram', 'upper']), height=HEIGHT, size=0.3)+
  geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='no_alt', 'mean'], xmin=CIs_surp[CIs_surp$condition=='no_alt', 'lower'], xmax=CIs_surp[CIs_surp$condition=='no_alt', 'upper']), height=HEIGHT, size=0.3)
plot
ggsave(filename = 'norm_surp_error_bars.png', path="plots/disjunction")

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
ggsave(filename = 'norm_surp.png', path="plots/disjunction")

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
summary(all_linear)