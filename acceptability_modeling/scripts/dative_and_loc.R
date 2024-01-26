library(tidyverse)
library(ggplot2)
library(ggthemes)
library(Rmisc)

dative_base = read.csv("acceptability_modeling/data/lu_kim_2022/dativebaseRatings.csv")
dative_base_surps = read.csv("acceptability_modeling/data/lu_kim_2022/dativebase_surprisals.csv")
dative_base$normalized_surprisal = dative_base_surps$normalized
dative = read.csv("acceptability_modeling/data/lu_kim_2022/dativeRatings.csv")
dative_surps = read.csv('acceptability_modeling/data/lu_kim_2022/dative_surprisals.csv')
dative$normalized_surprisal = dative_surps$normalized
dative_all = rbind(dative_base, dative)


locative_base = read.csv("acceptability_modeling/data/lu_kim_2022/locative_baseline_fullRatings.csv")
locative_base_surps = read.csv("acceptability_modeling/data/lu_kim_2022/locative_baseline_full_surprisals.csv")
locative_base$normalized_surprisal = locative_base_surps$normalized
locative_results = read.csv("acceptability_modeling/data/lu_kim_2022/locativeresultsRatings.csv")
locative_results_surps = read.csv("acceptability_modeling/data/lu_kim_2022/locativeresults_surprisals.csv")
locative_results$normalized_surprisal = locative_results_surps$normalized
locative_all = rbind(locative_base, locative_results)

satiation = read.csv("acceptability_modeling/data/satiationRatings.csv")
satiation = select(satiation, c("sentence_id", "condition", "all_exposures", "mean_surprisal", "normalized"))
satiation = satiation %>%
  dplyr::rename(mean_acc = "all_exposures")
satiation = satiation %>%
  dplyr::rename(normalized_surprisal = "normalized")

disjunction = read.csv("acceptability_modeling/data/disjunctionRatings.csv")
disjunction = select(disjunction, c("sentence_id", "condition", "mean_acc", "mean_surprisal", "normalized_surprisal"))

loc_dat = rbind(locative_all, dative_all)
loc_dat$mean_acc = ((loc_dat$mean_acc*7) - 1)/6
loc_dat = select(loc_dat, c("sentence_id", "condition", "mean_acc", "mean_surprisal", "normalized_surprisal"))

all_experiments = rbind(loc_dat, satiation)
all_experiments = rbind(all_experiments, disjunction)

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
# 
# plot = CIs_surp %>%
#   ggplot((aes(x = mean, y= CIs_acc$mean))) +
#   geom_point(aes(color = condition)) +
#   geom_smooth(method = "lm", se=FALSE) +
#   labs(title = "Mean Acceptability and Surprisal", 
#        x = "Mean Surprisal", 
#        y = "Mean Acceptability") +
#   theme_fivethirtyeight() +
#   theme(axis.title = element_text())
# 
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
# ggsave(filename = 'mean_surp_error_bars.png', path="plots/lu_kim_2022")

# ***Plot with ALL experiments (incl disjunction)
# plot = all_experiments %>%
#   ggplot((aes(x = mean_surprisal, y= mean_acc))) +
#   geom_point(aes(color = condition), show.legend = FALSE) +
#   geom_smooth(method = "lm", se=FALSE) +
#   labs(title = "Mean Acceptability and Surprisal", 
#        x = "Mean Surprisal", 
#        y = "Mean Acceptability") +
#   theme_fivethirtyeight() +
#   theme(axis.title = element_text())
# plot
#ggsave(filename = 'mean_surp.png', path="plots/lu_kim_2022")

CIs_acc_mean = double(0)
CIs_acc_upper = double(0)
CIs_acc_lower = double(0)
for (cond in c('WH', 'SUBJ', 'POLAR', 'FILL', 'UNGRAM', 'CNPC', 'dative-match-gap', 'dative-match-nogap', 'dative-mismatch-gap', 'dative-mismatch-nogap','locative-match-gap', 'locative-match-nogap', 'locative-mismatch-gap', 'locative-mismatch-nogap', 'alt', 'no_alt', 'gram', 'filler_good', 'filler_bad')){
  CIs = CI(all_experiments[all_experiments$condition==cond, "mean_acc"], ci=0.95)
  CIs_acc_mean = append(CIs_acc_mean, CIs['mean'])
  CIs_acc_upper = append(CIs_acc_upper, CIs['upper'])
  CIs_acc_lower = append(CIs_acc_lower, CIs['lower'])
}
print(CIs_acc_mean)
print(CIs_acc_upper)

CIs_acc = data.frame( 
  condition = c('WH', 'SUBJ', 'POLAR', 'FILL', 'UNGRAM', 'CNPC', 'dative-match-gap', 'dative-match-nogap', 'dative-mismatch-gap', 'dative-mismatch-nogap','locative-match-gap', 'locative-match-nogap', 'locative-mismatch-gap', 'locative-mismatch-nogap', 'alt', 'no_alt', 'gram', 'filler_good', 'filler_bad'),
  mean = CIs_acc_mean,
  upper = CIs_acc_upper,
  lower = CIs_acc_lower
)
colnames(CIs_acc) = c('condition', 'mean_acc', 'upper_acc', 'lower_acc')
print(CIs_acc)

CIs_surp_mean = double(0)
CIs_surp_upper = double(0)
CIs_surp_lower = double(0)
for (cond in c('WH', 'SUBJ', 'POLAR', 'FILL', 'UNGRAM', 'CNPC', 'dative-match-gap', 'dative-match-nogap', 'dative-mismatch-gap', 'dative-mismatch-nogap','locative-match-gap', 'locative-match-nogap', 'locative-mismatch-gap', 'locative-mismatch-nogap', 'alt', 'no_alt', 'gram', 'filler_good', 'filler_bad')){
  CIs = CI(all_experiments[all_experiments$condition==cond, "mean_surprisal"], ci=0.95)
  CIs_surp_mean = append(CIs_surp_mean, CIs['mean'])
  CIs_surp_upper = append(CIs_surp_upper, CIs['upper'])
  CIs_surp_lower = append(CIs_surp_lower, CIs['lower'])
}

CIs_surp = data.frame(
  condition = c('WH', 'SUBJ', 'POLAR', 'FILL', 'UNGRAM', 'CNPC', 'dative-match-gap', 'dative-match-nogap', 'dative-mismatch-gap', 'dative-mismatch-nogap','locative-match-gap', 'locative-match-nogap', 'locative-mismatch-gap', 'locative-mismatch-nogap', 'alt', 'no_alt', 'gram', 'filler_good', 'filler_bad'),
  mean = CIs_surp_mean,
  upper = CIs_surp_upper,
  lower = CIs_surp_lower
)
colnames(CIs_surp) = c('condition', 'mean_surp', 'upper_surp', 'lower_surp')

CIs = cbind(CIs_acc, CIs_surp)[-c(5)]
CIs[CIs == 'dative-match-gap'] = 'dative 1'
CIs[CIs == 'dative-match-nogap'] = 'dative 2'
CIs[CIs == 'dative-mismatch-gap'] = 'dative 3'
CIs[CIs == 'dative-mismatch-nogap'] = 'dative 4'
CIs[CIs == 'locative-match-gap'] = 'locative 1'
CIs[CIs == 'locative-match-nogap'] = 'locative 2'
CIs[CIs == 'locative-mismatch-gap'] = 'locative 3'
CIs[CIs == 'locative-mismatch-nogap'] = 'locative 3'
CIs[CIs == 'alt'] = 'disjoined subject 1'
CIs[CIs == 'no_alt'] = 'disjoined subject 2'
CIs[CIs == 'WH'] = 'whether island'
CIs[CIs == 'SUBJ'] = 'subject island'
CIs[CIs == 'POLAR'] = 'polar question'
CIs[CIs == 'FILL'] = 'grammatical 1'
CIs[CIs == 'UNGRAM'] = 'ungrammatical 1'
CIs[CIs == 'CNPC'] = 'CNPC'
CIs[CIs == 'gram'] = 'grammatical 2'
CIs[CIs == 'filler_good'] = 'grammatical 3'
CIs[CIs == 'filler_bad'] = 'ungrammatical 2'
print(CIs)

HEIGHT = 0.02
WIDTH = 0.1
SIZE = 0.3

plot = CIs %>%
  ggplot((aes(x=mean_surp, y=mean_acc))) +
  geom_point(aes(color=condition),size=3) +
  geom_smooth(method='lm', se=FALSE, color='black',size=0.5) +
  labs(x = "Mean surprisal", 
       y = "Mean acceptability") +
  theme_bw() +
  theme(axis.title = element_text(size=14)) +
  theme(axis.text = element_text(size=12)) +
  geom_errorbar(aes(ymin=lower_acc, ymax=upper_acc, color=condition), width=WIDTH, size=SIZE) + 
  geom_errorbarh(aes(xmin=lower_surp, xmax=upper_surp, color=condition), height=HEIGHT, size=SIZE)+
  theme(legend.position = "right") + 
  theme(legend.title=element_blank()) +
  theme(legend.text=element_text(size=12)) +
  geom_text(aes(x=7.15,y=0.55, label = "whether-island"), size=3.5, colour = "#FF699C", hjust = 0, vjust = 0, check_overlap = TRUE )+
  geom_text(aes(x=7.75,y=0.37, label = "subject island"), size=3.5, colour = "#DC72FB", hjust = 0, vjust = 0, check_overlap = TRUE ) +
  geom_text(aes(x=8.25,y=0.475, label = "CNPC"), size=3.5, colour = "#F8766D", hjust = 0, vjust = 0, check_overlap = TRUE )
plot
ggsave(filename = 'ALL_mean_surp_error_bars_labels.png', path="plots/lu_kim_2022", width=8, height=5)

CIs$condition = factor(CIs$condition, levels = unique(CIs$condition))
levels(CIs$condition) = unique(CIs$condition)
levels(CIs$condition)
contrasts(CIs$condition) = contr.sum(18)
cond_prediction_all = lm(mean_acc ~ mean_surp*condition, CIs)
summary(cond_prediction_all)


simple = lm(formula = mean_acc ~ mean_surp, data = CIs)
summary(simple)
AIC(simple)
interaction = lm(mean_acc ~ mean_surp*condition, CIs)
summary(interaction)



# SLOR plot
#CIs_acc is same as previous unnormalized
CIs_surp_mean = double(0)
CIs_surp_upper = double(0)
CIs_surp_lower = double(0)
for (cond in c('WH', 'SUBJ', 'POLAR', 'FILL', 'UNGRAM', 'CNPC', 'dative-match-gap', 'dative-match-nogap', 'dative-mismatch-gap', 'dative-mismatch-nogap','locative-match-gap', 'locative-match-nogap', 'locative-mismatch-gap', 'locative-mismatch-nogap', 'alt', 'no_alt', 'gram', 'filler_good', 'filler_bad')){
  CIs = CI(all_experiments[all_experiments$condition==cond, "normalized_surprisal"], ci=0.95)
  CIs_surp_mean = append(CIs_surp_mean, CIs['mean'])
  CIs_surp_upper = append(CIs_surp_upper, CIs['upper'])
  CIs_surp_lower = append(CIs_surp_lower, CIs['lower'])
}

CIs_surp = data.frame(
  condition = c('WH', 'SUBJ', 'POLAR', 'FILL', 'UNGRAM', 'CNPC', 'dative-match-gap', 'dative-match-nogap', 'dative-mismatch-gap', 'dative-mismatch-nogap','locative-match-gap', 'locative-match-nogap', 'locative-mismatch-gap', 'locative-mismatch-nogap', 'alt', 'no_alt', 'gram', 'filler_good', 'filler_bad'),
  mean = CIs_surp_mean,
  upper = CIs_surp_upper,
  lower = CIs_surp_lower
)
colnames(CIs_surp) = c('condition', 'mean_surp', 'upper_surp', 'lower_surp')
print(CIs_surp)

CIs = cbind(CIs_acc, CIs_surp)[-c(5)]
# CIs[CIs == 'dative-match-gap'] = 'dative 1'
# CIs[CIs == 'dative-match-nogap'] = 'dative 2'
# CIs[CIs == 'dative-mismatch-gap'] = 'dative 3'
# CIs[CIs == 'dative-mismatch-nogap'] = 'dative 4'
# CIs[CIs == 'locative-match-gap'] = 'locative 1'
# CIs[CIs == 'locative-match-nogap'] = 'locative 2'
# CIs[CIs == 'locative-mismatch-gap'] = 'locative 3'
# CIs[CIs == 'locative-mismatch-nogap'] = 'locative 3'
CIs[CIs == 'alt'] = 'disjunction-match'
CIs[CIs == 'no_alt'] = 'disjunction-mismatch'
CIs[CIs == 'WH'] = 'whether-island'
CIs[CIs == 'SUBJ'] = 'subject island'
CIs[CIs == 'POLAR'] = 'polar question'
CIs[CIs == 'FILL'] = 'grammatical-question'
CIs[CIs == 'UNGRAM'] = 'ungrammatical 1'
CIs[CIs == 'CNPC'] = 'complex-NP island'
CIs[CIs == 'gram'] = 'grammatical-disjunction'
CIs[CIs == 'filler_good'] = 'grammatical'
CIs[CIs == 'filler_bad'] = 'ungrammatical 2'
print(CIs)

HEIGHT = 0.02
WIDTH = 0.1
SIZE = 0.3

plot = CIs %>%
  ggplot((aes(x=mean_surp, y=mean_acc))) +
  geom_point(aes(color=condition),size=3) +
  geom_smooth(method='lm', se=FALSE, color='black',size=0.5) +
  labs(x = "Mean SLOR", 
       y = "Mean acceptability") +
  theme_bw() +
  theme(axis.title = element_text(size=14)) +
  theme(axis.text = element_text(size=12)) +
  geom_errorbar(aes(ymin=lower_acc, ymax=upper_acc, color=condition), width=WIDTH, size=SIZE) + 
  geom_errorbarh(aes(xmin=lower_surp, xmax=upper_surp, color=condition), height=HEIGHT, size=SIZE)+
  theme(legend.position = "right") +
  theme(legend.title=element_blank())+
  theme(legend.text=element_text(size=12))+
  theme(plot.margin = margin(10, 15, 5, 15)) + 
  #theme(plot.margin = margin(20, 5, 5, 17)) + 
  geom_text(aes(x=2.55,y=0.55, label = "whether-island"), size=4.5, colour = "#FF699C", hjust = 0, vjust = 0, check_overlap = TRUE )+
  geom_text(aes(x=2.25,y=0.4, label = "subject island"), size=4.5, colour = "#DC72FB", hjust = 0, vjust = 0, check_overlap = TRUE ) +
  geom_text(aes(x=2.65,y=0.475, label = "complex-NP island"), size=4.5, colour = "#F8766D", hjust = 0, vjust = 0, check_overlap = TRUE )
plot
ggsave(filename = 'ALL_SLOR_surp_error_bars_right.png', path="plots/lu_kim_2022", width=10, height=8)

simple_SLOR = lm(formula = mean_acc ~ mean_surp, data = CIs)
summary(simple_SLOR)

CIs$condition = factor(CIs$condition, levels = unique(CIs$condition))
levels(CIs$condition) = unique(CIs$condition)
levels(CIs$condition)
contrasts(CIs$condition) = contr.sum(18)
cond_prediction_all = lm(mean_acc ~ mean_surprisal*condition, all_experiments)
summary(cond_prediction_all)

# Plotting individual examples as data points
plot = all_experiments %>%
  ggplot((aes(x=normalized_surprisal, y=mean_acc))) +
  geom_point() + 
  geom_smooth(method='lm', se=FALSE, color='black',size=0.5) +
  labs(x = "SLOR", 
       y = "Mean acceptability") +
  theme_bw() +
  theme(axis.title = element_text(size=14)) +
  theme(axis.text = element_text(size=12))
plot

SLOR_all_datapoints = lm(formula = mean_acc ~ normalized_surprisal, data=all_experiments)
summary(SLOR_all_datapoints)

# plot = CIs_surp %>%
#   ggplot((aes(x = mean, y= CIs_acc$mean))) +
#   geom_point(aes(color = condition)) +
#   geom_smooth(method = "lm", se=FALSE) +
#   labs(title = "Mean Acceptability and Normalized Surprisal", 
#        x = "Normalized Surprisal", 
#        y = "Mean Acceptability") +
#   theme_fivethirtyeight() +
#   theme(axis.title = element_text())
# plot
# linear = lm(CIs_acc$mean~CIs_surp$mean, CIs_surp)
# 
# HEIGHT = 0.01
# WIDTH = 0.1
# plot = plot + geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='WH', 'mean'], ymin=CIs_acc[CIs_acc$condition=='WH', 'lower'], ymax=CIs_acc[CIs_acc$condition=='WH', 'upper']), width=WIDTH, size=0.3) +
#   geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='SUBJ', 'mean'], ymin=CIs_acc[CIs_acc$condition=='SUBJ', 'lower'], ymax=CIs_acc[CIs_acc$condition=='SUBJ', 'upper']), width=WIDTH, size=0.3)+ 
#   geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='POLAR', 'mean'], ymin=CIs_acc[CIs_acc$condition=='POLAR', 'lower'], ymax=CIs_acc[CIs_acc$condition=='POLAR', 'upper']), width=WIDTH, size=0.3)+
#   geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='FILL', 'mean'], ymin=CIs_acc[CIs_acc$condition=='FILL', 'lower'], ymax=CIs_acc[CIs_acc$condition=='FILL', 'upper']), width=WIDTH, size=.3)+
#   geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='UNGRAM', 'mean'], ymin=CIs_acc[CIs_acc$condition=='UNGRAM', 'lower'], ymax=CIs_acc[CIs_acc$condition=='UNGRAM', 'upper']), width=WIDTH, size=0.3)+
#   geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='CNPC', 'mean'], ymin=CIs_acc[CIs_acc$condition=='CNPC', 'lower'], ymax=CIs_acc[CIs_acc$condition=='CNPC', 'upper']), width=WIDTH, size=0.3)+
#   geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='dative-match-gap', 'mean'], ymin=CIs_acc[CIs_acc$condition=='dative-match-gap', 'lower'], ymax=CIs_acc[CIs_acc$condition=='dative-match-gap', 'upper']), width=WIDTH, size=0.3)+
#   geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='dative-match-nogap', 'mean'], ymin=CIs_acc[CIs_acc$condition=='dative-match-nogap', 'lower'], ymax=CIs_acc[CIs_acc$condition=='dative-match-nogap', 'upper']), width=WIDTH, size=0.3)+
#   geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='dative-mismatch-gap', 'mean'], ymin=CIs_acc[CIs_acc$condition=='dative-mismatch-gap', 'lower'], ymax=CIs_acc[CIs_acc$condition=='dative-mismatch-gap', 'upper']), width=WIDTH, size=0.3)+
#   geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='dative-mismatch-nogap', 'mean'], ymin=CIs_acc[CIs_acc$condition=='dative-mismatch-nogap', 'lower'], ymax=CIs_acc[CIs_acc$condition=='dative-mismatch-nogap', 'upper']), width=WIDTH, size=0.3)+
#   geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='locative-match-gap', 'mean'], ymin=CIs_acc[CIs_acc$condition=='locative-match-gap', 'lower'], ymax=CIs_acc[CIs_acc$condition=='locative-match-gap', 'upper']), width=WIDTH, size=0.3)+
#   geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='locative-match-nogap', 'mean'], ymin=CIs_acc[CIs_acc$condition=='locative-match-nogap', 'lower'], ymax=CIs_acc[CIs_acc$condition=='locative-match-nogap', 'upper']), width=WIDTH, size=0.3)+
#   geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='locative-mismatch-gap', 'mean'], ymin=CIs_acc[CIs_acc$condition=='locative-mismatch-gap', 'lower'], ymax=CIs_acc[CIs_acc$condition=='locative-mismatch-gap', 'upper']), width=WIDTH, size=0.3)+
#   geom_errorbar(aes(x = CIs_surp[CIs_surp$condition=='locative-mismatch-nogap', 'mean'], ymin=CIs_acc[CIs_acc$condition=='locative-mismatch-nogap', 'lower'], ymax=CIs_acc[CIs_acc$condition=='locative-mismatch-nogap', 'upper']), width=WIDTH, size=0.3)+
#   
#   geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='WH', 'mean'], xmin=CIs_surp[CIs_surp$condition=='WH', 'lower'], xmax=CIs_surp[CIs_surp$condition=='WH', 'upper']), height=HEIGHT, size=0.3)+
#   geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='SUBJ', 'mean'], xmin=CIs_surp[CIs_surp$condition=='SUBJ', 'lower'], xmax=CIs_surp[CIs_surp$condition=='SUBJ', 'upper']), height=HEIGHT, size=0.3)+
#   geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='POLAR', 'mean'], xmin=CIs_surp[CIs_surp$condition=='POLAR', 'lower'], xmax=CIs_surp[CIs_surp$condition=='POLAR', 'upper']), height=HEIGHT, size=0.3)+
#   geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='FILL', 'mean'], xmin=CIs_surp[CIs_surp$condition=='FILL', 'lower'], xmax=CIs_surp[CIs_surp$condition=='FILL', 'upper']), height=HEIGHT, size=0.3)+
#   geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='UNGRAM', 'mean'], xmin=CIs_surp[CIs_surp$condition=='UNGRAM', 'lower'], xmax=CIs_surp[CIs_surp$condition=='UNGRAM', 'upper']), height=HEIGHT, size=0.3)+
#   geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='CNPC', 'mean'], xmin=CIs_surp[CIs_surp$condition=='CNPC', 'lower'], xmax=CIs_surp[CIs_surp$condition=='CNPC', 'upper']), height=HEIGHT, size=0.3)+
#   geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='dative-match-gap', 'mean'], xmin=CIs_surp[CIs_surp$condition=='dative-match-gap', 'lower'], xmax=CIs_surp[CIs_surp$condition=='dative-match-gap', 'upper']), height=HEIGHT, size=0.3)+
#   geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='dative-match-nogap', 'mean'], xmin=CIs_surp[CIs_surp$condition=='dative-match-nogap', 'lower'], xmax=CIs_surp[CIs_surp$condition=='dative-match-nogap', 'upper']), height=HEIGHT, size=0.3)+
#   geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='dative-mismatch-gap', 'mean'], xmin=CIs_surp[CIs_surp$condition=='dative-mismatch-gap', 'lower'], xmax=CIs_surp[CIs_surp$condition=='dative-mismatch-gap', 'upper']), height=HEIGHT, size=0.3)+
#   geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='dative-mismatch-nogap', 'mean'], xmin=CIs_surp[CIs_surp$condition=='dative-mismatch-nogap', 'lower'], xmax=CIs_surp[CIs_surp$condition=='dative-mismatch-nogap', 'upper']), height=HEIGHT, size=0.3)+
#   geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='locative-match-gap', 'mean'], xmin=CIs_surp[CIs_surp$condition=='locative-match-gap', 'lower'], xmax=CIs_surp[CIs_surp$condition=='locative-match-gap', 'upper']), height=HEIGHT, size=0.3)+
#   geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='locative-match-nogap', 'mean'], xmin=CIs_surp[CIs_surp$condition=='locative-match-nogap', 'lower'], xmax=CIs_surp[CIs_surp$condition=='locative-match-nogap', 'upper']), height=HEIGHT, size=0.3)+
#   geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='locative-mismatch-gap', 'mean'], xmin=CIs_surp[CIs_surp$condition=='locative-mismatch-gap', 'lower'], xmax=CIs_surp[CIs_surp$condition=='locative-mismatch-gap', 'upper']), height=HEIGHT, size=0.3)+
#   geom_errorbarh(aes(y = CIs_acc[CIs_acc$condition=='locative-mismatch-nogap', 'mean'], xmin=CIs_surp[CIs_surp$condition=='locative-mismatch-nogap', 'lower'], xmax=CIs_surp[CIs_surp$condition=='locative-mismatch-nogap', 'upper']), height=HEIGHT, size=0.3)
# plot
# ggsave(filename = 'norm_surp_error_bars.png', path="plots/lu_kim_2022")
# 
# plot = all_experiments %>%
#   ggplot((aes(x = normalized, y= mean_acc))) +
#   geom_point(aes(color = condition)) +
#   geom_smooth(method = "lm", se=FALSE) +
#   labs(title = "Mean Acceptability and Normalized Surprisal",
#        x = "Normalized Surprisal",
#        y = "Mean Acceptability") +
#   theme_fivethirtyeight() +
#   theme(axis.title = element_text())
# plot
# ggsave(filename = 'norm_surp.png', path="plots/lu_kim_2022")


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

print(all_experiments) # Dataframe with mean acc, mean surp, norm surp for all conditions


all_logistic = glm(mean_acc ~ mean_surprisal, all_experiments, family = "binomial")
all_linear = lm(mean_acc~mean_surprisal, all_experiments)
AIC(all_logistic)
AIC(all_linear)
summary(all_linear)

#factored_cond = all_experiments$condition
# ALL conditions, incl. disjunction
all_experiments$condition = factor(all_experiments$condition, levels = unique(all_experiments$condition))
#all_experiments$condition = factored_cond
levels(all_experiments$condition) = unique(all_experiments$condition)
levels(all_experiments$condition)
contrasts(all_experiments$condition) = contr.sum(19)
cond_prediction_all = lm(mean_acc ~ mean_surprisal*condition, all_experiments)
summary(cond_prediction_all)

cond_prediction_all = lm(mean_acc ~ condition, all_experiments)
summary(cond_prediction_all)

# Islands, polar, ungram/gram
satiation$condition = factor(satiation$condition, levels = unique(satiation$condition))
unique(satiation$condition)
contrasts(satiation$condition) = contr.sum(6)
cond_prediction_islands = lm(mean_acc ~ mean_surprisal*condition, satiation)
summary(cond_prediction_islands)

# Just islands
just_islands = satiation %>% filter(condition=='CNPC' | condition=='WH' | condition=='SUBJ')
just_islands$condition = factor(just_islands$condition, levels = unique(just_islands$condition))
levels(just_islands$condition) = unique(just_islands$condition)
levels(just_islands$condition)
contrasts(just_islands$condition) = contr.sum(3)
cond_prediction_just_islands = lm(mean_acc ~ mean_surprisal*condition, satiation)
summary(cond_prediction_just_islands)

# Everything but the grammatical and ungrammatical conditions
test_conds_only = all_experiments%>% filter(!condition=='gram' & !condition=='filler_good' & !condition=='filler_bad' & !condition=='FILL' & !condition=='POLAR' & !condition=='UNGRAM')
test_conds_only$condition = factor(test_conds_only$condition, levels = unique(test_conds_only$condition))
levels(test_conds_only$condition) = unique(test_conds_only$condition)
levels(test_conds_only$condition)
contrasts(test_conds_only$condition) = contr.sum(13)
test_conds_only_prediction = lm(mean_acc ~ mean_surprisal*condition, test_conds_only)
summary(test_conds_only_prediction)
