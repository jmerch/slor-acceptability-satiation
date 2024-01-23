library(tidyverse)
library(ggplot2)
library(ggthemes)
library(stringr)
library(Rmisc)


num_trained = as.integer(c(0, 10))

# Exp 1 - test on subject

WH_base = read.csv("gpt2_satiation/output/surprisals/gen_rep/SUBJ_baseline_noContext_surprisals.csv")
WH_test = read.csv("gpt2_satiation/output/surprisals/gen_rep/gen_WHtrain_SUBJtest_noContext_surprisals.csv")
m_0 = mean(WH_base$mean_surprisal)
m_10 = mean(WH_test$mean_surprisal)
ms = c(m_0, m_10)
condition = c("WH", "WH")
WH = data.frame(num_trained, ms, condition)

SUBJ_base = read.csv("gpt2_satiation/output/surprisals/gen_rep/SUBJ_baseline_noContext_surprisals.csv")
SUBJ_test = read.csv("gpt2_satiation/output/surprisals/gen_rep/gen_SUBJtrain_SUBJtest_noContext_surprisals.csv")
m_0 = mean(SUBJ_base$mean_surprisal)
m_10 = mean(SUBJ_test$mean_surprisal)
ms = c(m_0, m_10)
condition = c("SUBJ", "SUBJ")
SUBJ = data.frame(num_trained, ms, condition)

POLAR_base = read.csv("gpt2_satiation/output/surprisals/gen_rep/SUBJ_baseline_noContext_surprisals.csv")
POLAR_test = read.csv("gpt2_satiation/output/surprisals/gen_rep/gen_POLARtrain_SUBJtest_noContext_surprisals.csv")
m_0 = mean(POLAR_base$mean_surprisal)
m_10 = mean(POLAR_test$mean_surprisal)
ms = c(m_0, m_10)
condition = c("POLAR", "POLAR")
POLAR = data.frame(num_trained, ms, condition)


exp1 = rbind(WH, SUBJ, POLAR)
exp1[exp1=='WH'] = 'between-category (whether-island)'
exp1[exp1=='SUBJ'] = 'within-category (subject island)'
exp1[exp1=='POLAR'] = 'control (polar question)'

plot = exp1 %>%
  ggplot((aes(x = num_trained, y= ms))) +
  geom_line(aes(group = condition, color = condition), size=1.5) +
  geom_point(aes(color = condition), size=3) + 
  scale_x_continuous(breaks=c(0,10), labels = c('pre-exposure', 'post-exposure')) +
  ylim(3,9) +
  labs(y = 'Mean Surprisal') +
  theme_bw() +
  theme(legend.position = 'bottom') +
  theme(legend.text = element_text(size=10))+
  theme(axis.title.y = element_text(size=14), axis.title.x=element_blank()) +
  theme(legend.title = element_blank()) +
  theme(axis.text.x = element_text(size=13, hjust=0.6), axis.text.y = element_text(size=10)) +
  theme(plot.margin = margin(5, 15, 5, 5)) +
  scale_color_manual(values=c('#DDA239', '#78B6E5', '#4A9E78'))
plot
ggsave("gpt2_satiation/plots/gen_exp1_rep_new.png", width=7, height=5)

WH_test_new = WH_test[c('mean_surprisal')] %>% mutate(condition = 'between-category (whether-island)')
SUBJ_test_new = SUBJ_test[c('mean_surprisal')] %>% mutate(condition = 'within-category (subject island)')
POLAR_test_new = POLAR_test[c('mean_surprisal')] %>% mutate(condition = 'control (polar question)')

raw_test = rbind(WH_test_new, SUBJ_test_new, POLAR_test_new)
print(raw_test)

CIs_surp_mean = double(0)
CIs_surp_upper = double(0)
CIs_surp_lower = double(0)
for (cond in unique(raw_test$condition)){
  CIs = CI(raw_test[raw_test$condition==cond, "mean_surprisal"], ci=0.95)
  CIs_surp_mean = append(CIs_surp_mean, CIs['mean'])
  CIs_surp_upper = append(CIs_surp_upper, CIs['upper'])
  CIs_surp_lower = append(CIs_surp_lower, CIs['lower'])
}

CIs_surp = data.frame(
  condition = unique(raw_test$condition),
  mean = CIs_surp_mean,
  upper = CIs_surp_upper,
  lower = CIs_surp_lower
)
colnames(CIs_surp) = c('condition', 'mean_surp', 'upper_surp', 'lower_surp')

CIs_surp$wrap_condition = str_wrap(CIs_surp$condition, width = 7) # to wrap the labels
CIs_surp$wrap_condition = c('between-category\n(whether-island)', 'within-category\n(subject island)', 'control\n(polar question)')

print(CIs_surp)

HEIGHT = 0.02
WIDTH = 0.1
SIZE = 0.3
m_0 = mean(POLAR_base$mean_surprisal)
plot = CIs_surp %>%
  ggplot(aes(x=wrap_condition, y=mean_surp, fill=condition)) +
  geom_bar(stat="identity", width=0.75, show.legend=FALSE) +
  geom_errorbar(aes(ymin=lower_surp, ymax=upper_surp), width=WIDTH, size=SIZE) +
  geom_hline(yintercept=m_0, linetype='dashed', color='black') +
  geom_text(aes(x=2.25,y=7, label = "mean surprisal before additional training"), size=3.5, colour = "black", hjust = 0, vjust = 0, check_overlap = TRUE )+
  theme_bw() + 
  labs(x='Condition', y='Mean surprisal') +
  scale_x_discrete(limits=c(CIs_surp$wrap_condition[3], CIs_surp$wrap_condition[1], CIs_surp$wrap_condition[2])) +
  scale_fill_manual(values=c('#78B6E5','#DDA239', '#4A9E78')) #in alphabetical order of labels?
plot
ggsave("gpt2_satiation/plots/gen_exp1_rep_bar.png", width=7, height=5)


# Exp 1 - SLOR
n_0 = mean(POLAR_base$normalized)
WH_test_new = WH_test[c('normalized')] %>% mutate(condition = 'between-category (whether-island)')
SUBJ_test_new = SUBJ_test[c('normalized')] %>% mutate(condition = 'within-category (subject island)')
POLAR_test_new = POLAR_test[c('normalized')] %>% mutate(condition = 'control (polar question)')

raw_test = rbind(WH_test_new, SUBJ_test_new, POLAR_test_new)
print(raw_test)

CIs_surp_mean = double(0)
CIs_surp_upper = double(0)
CIs_surp_lower = double(0)
for (cond in unique(raw_test$condition)){
  CIs = CI(raw_test[raw_test$condition==cond, "normalized"], ci=0.95)
  CIs_surp_mean = append(CIs_surp_mean, CIs['mean'])
  CIs_surp_upper = append(CIs_surp_upper, CIs['upper'])
  CIs_surp_lower = append(CIs_surp_lower, CIs['lower'])
}

CIs_surp = data.frame(
  condition = unique(raw_test$condition),
  mean = CIs_surp_mean,
  upper = CIs_surp_upper,
  lower = CIs_surp_lower
)
colnames(CIs_surp) = c('condition', 'mean_surp', 'upper_surp', 'lower_surp')

CIs_surp$wrap_condition = c('between-category\n(whether-island)', 'within-category\n(subject island)', 'control\n(polar question)')
CIs_surp$condition = c('whether-island','subject island', 'polar question')
CIs_surp$exposure_cond = c('between-category', 'within-category', 'control')
print(CIs_surp)

HEIGHT = 0.02
WIDTH = 0.1
SIZE = 0.3
CIs_surp
plot = CIs_surp %>%
  ggplot(aes(x=exposure_cond, y=mean_surp, fill=condition)) +
  geom_bar(stat="identity", width=0.75, show.legend=FALSE) +
  geom_errorbar(aes(ymin=lower_surp, ymax=upper_surp), width=WIDTH, size=SIZE) +
  geom_hline(yintercept=n_0, linetype='dashed', color='black') +
  geom_text(aes(x=2,y=2.4, label = "mean SLOR before additional training"), size=4.5, colour = "black", hjust = 0, vjust = 0, check_overlap = TRUE )+
  theme_bw() + 
  labs(x='condition', y='Mean SLOR') +
  ylim(0,5.25) +
  theme(legend.position = 'right') +
  theme(axis.title.y = element_text(size=16), axis.title.x=element_blank())+
  theme(legend.text = element_text(size=12)) +
  theme(legend.title = element_blank()) + 
  theme(axis.text.x = element_text(size=14.5, hjust=0.63), axis.text.y = element_text(size=10)) +
  scale_x_discrete(limits=c(CIs_surp$exposure_cond[3], CIs_surp$exposure_cond[1], CIs_surp$exposure_cond[2])) +
  scale_fill_manual(values=c('#DDA239', '#4A9E78', '#78B6E5'))
plot
ggsave("gpt2_satiation/plots/gen_exp1_rep_bar_SLOR.png", width=7, height=5)


# Exp 2

WH_base = read.csv("gpt2_satiation/output/surprisals/gen_rep/gen_WH_baseline_surprisals.csv")
WH_test = read.csv("gpt2_satiation/output/surprisals/gen_rep/gen_WHtrain_WHtest_noContext_surprisals.csv")
m_0 = mean(WH_base$mean_surprisal)
m_10 = mean(WH_test$mean_surprisal)
ms = c(m_0, m_10)
condition = c("WH", "WH")
WH = data.frame(num_trained, ms, condition)

SUBJ_base = read.csv("gpt2_satiation/output/surprisals/gen_rep/gen_WH_baseline_surprisals.csv")
SUBJ_test = read.csv("gpt2_satiation/output/surprisals/gen_rep/gen_SUBJtrain_WHtest_noContext_surprisals.csv")
m_0 = mean(SUBJ_base$mean_surprisal)
m_10 = mean(SUBJ_test$mean_surprisal)
ms = c(m_0, m_10)
condition = c("SUBJ", "SUBJ")
SUBJ = data.frame(num_trained, ms, condition)

POLAR_base = read.csv("gpt2_satiation/output/surprisals/gen_rep/gen_WH_baseline_surprisals.csv")
POLAR_test = read.csv("gpt2_satiation/output/surprisals/gen_rep/gen_POLARtrain_WHtest_noContext_surprisals.csv")
m_0 = mean(POLAR_base$mean_surprisal)
m_10 = mean(POLAR_test$mean_surprisal)
ms = c(m_0, m_10)
condition = c("POLAR", "POLAR")
POLAR = data.frame(num_trained, ms, condition)

exp2 = rbind(WH, SUBJ, POLAR)
exp2[exp2=='WH'] = 'whether-island'
exp2[exp2=='SUBJ'] = 'subject island'
exp2[exp2=='POLAR'] = 'control (polar question)'

plot = exp2 %>%
  ggplot((aes(x = num_trained, y= ms))) +
  geom_line(aes(group = condition, color = condition), size=1.5) +
  geom_point(aes(color = condition), size=3) + 
  scale_x_continuous(breaks=c(0,10), labels = c('pre-exposure', 'post-exposure')) +
  ylim(3,9) +
  labs(y = 'Mean Surprisal') +
  theme_bw() +
  theme(legend.position = 'bottom') +
  theme(legend.text = element_text(size=10))+
  theme(axis.title.y = element_text(size=14), axis.title.x=element_blank()) +
  theme(legend.title = element_blank()) +
  theme(axis.text.x = element_text(size=13, hjust=0.6), axis.text.y = element_text(size=10)) +
  theme(plot.margin = margin(5, 15, 5, 5)) +
  scale_color_manual(values=c('#DDA239', '#78B6E5', '#4A9E78'))
plot

# Bar plots (with CIs)
WH_test_new = WH_test[c('mean_surprisal')] %>% mutate(condition = 'whether-island')
SUBJ_test_new = SUBJ_test[c('mean_surprisal')] %>% mutate(condition = 'subject island')
POLAR_test_new = POLAR_test[c('mean_surprisal')] %>% mutate(condition = 'control (polar question)')

raw_test = rbind(WH_test_new, SUBJ_test_new, POLAR_test_new)
print(raw_test)

CIs_surp_mean = double(0)
CIs_surp_upper = double(0)
CIs_surp_lower = double(0)
for (cond in unique(raw_test$condition)){
  CIs = CI(raw_test[raw_test$condition==cond, "mean_surprisal"], ci=0.95)
  CIs_surp_mean = append(CIs_surp_mean, CIs['mean'])
  CIs_surp_upper = append(CIs_surp_upper, CIs['upper'])
  CIs_surp_lower = append(CIs_surp_lower, CIs['lower'])
}

CIs_surp = data.frame(
  condition = unique(raw_test$condition),
  mean = CIs_surp_mean,
  upper = CIs_surp_upper,
  lower = CIs_surp_lower
)
colnames(CIs_surp) = c('condition', 'mean_surp', 'upper_surp', 'lower_surp')

CIs_surp$wrap_condition = str_wrap(CIs_surp$condition, width = 7) # to wrap the labels
CIs_surp$wrap_condition = c('within-category\n(whether-island)', 'between-category\n(subject island)', 'control\n(polar question)')

print(CIs_surp)

HEIGHT = 0.02
WIDTH = 0.1
SIZE = 0.3
m_0 = mean(POLAR_base$mean_surprisal)

# plot = CIs_surp %>%
#   ggplot(aes(x=exposure_cond, y=mean_surp, fill=condition)) +
#   geom_bar(stat="identity", width=0.75, show.legend=FALSE) +
#   geom_errorbar(aes(ymin=lower_surp, ymax=upper_surp), width=WIDTH, size=SIZE) +
#   geom_hline(yintercept=m_0, linetype='dashed', color='black') +
#   geom_text(aes(x=2.25,y=8.35, label = "mean surprisal before additional training"), size=3.5, colour = "black", hjust = 0, vjust = 0, check_overlap = TRUE )+
#   theme_bw() + 
#   labs(x='condition', y='mean surprisal') +
#   scale_x_discrete(limits=c(CIs_surp$exposure_cond[3], CIs_surp$exposure_cond[2], CIs_surp$exposure_cond[1])) +
#   scale_fill_manual(values=c('#DDA239','#4A9E78', '#78B6E5'))
# plot
# ggsave("gpt2_satiation/plots/gen_exp2_rep_bar.png", width=7, height=5)

# Exp 2 - SLOR
n_0 = mean(POLAR_base$normalized)

WH_test_new = WH_test[c('normalized')] %>% mutate(condition = 'within-category\n(whether-island)')
SUBJ_test_new = SUBJ_test[c('normalized')] %>% mutate(condition = 'between-category\n(subject island)')
POLAR_test_new = POLAR_test[c('normalized')] %>% mutate(condition = 'control\n(polar question)')

raw_test = rbind(WH_test_new, SUBJ_test_new, POLAR_test_new)
print(raw_test)

CIs_surp_mean = double(0)
CIs_surp_upper = double(0)
CIs_surp_lower = double(0)
for (cond in unique(raw_test$condition)){
  CIs = CI(raw_test[raw_test$condition==cond, "normalized"], ci=0.95)
  CIs_surp_mean = append(CIs_surp_mean, CIs['mean'])
  CIs_surp_upper = append(CIs_surp_upper, CIs['upper'])
  CIs_surp_lower = append(CIs_surp_lower, CIs['lower'])
}

CIs_surp = data.frame(
  condition = unique(raw_test$condition),
  mean = CIs_surp_mean,
  upper = CIs_surp_upper,
  lower = CIs_surp_lower
)
colnames(CIs_surp) = c('condition', 'mean_surp', 'upper_surp', 'lower_surp')
CIs_surp$condition = c('whether-island','subject island', 'polar question')
CIs_surp$exposure_cond = c('within-category', 'between-category', 'control')
print(CIs_surp)

HEIGHT = 0.02
WIDTH = 0.1
SIZE = 0.3
print(CIs_surp)
plot = CIs_surp %>%
  ggplot(aes(x=exposure_cond, y=mean_surp, fill=condition)) +
  geom_bar(stat="identity", width=0.75, show.legend=FALSE) +
  geom_errorbar(aes(ymin=lower_surp, ymax=upper_surp), width=WIDTH, size=SIZE) +
  geom_hline(yintercept=n_0, linetype='dashed', color='black') +
  geom_text(aes(x=2,y=1.1, label = "mean SLOR before additional training"), size=4.5, colour = "black", hjust = 0, vjust = 0, check_overlap = TRUE )+
  theme_bw() + 
  ylim(0,5.25) +
  theme(axis.title.y = element_text(size=16), axis.title.x=element_blank())+
  theme(legend.text = element_text(size=12)) +
  theme(legend.title = element_blank()) + 
  theme(axis.text.x = element_text(size=14.5, hjust=0.63), axis.text.y = element_text(size=10)) +
  labs(x='condition', y='Mean SLOR') +
  scale_x_discrete(limits=c(CIs_surp$exposure_cond[3], CIs_surp$exposure_cond[2], CIs_surp$exposure_cond[1])) +
  scale_fill_manual(values=c('#DDA239','#4A9E78', '#78B6E5'))
plot
ggsave("gpt2_satiation/plots/gen_exp2_rep_bar_SLOR.png", width=7, height=5)
