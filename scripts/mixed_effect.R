library(tidyverse)
library(lme4)

# load generalization data and add surprisal values for corresponding sentences

gen_data = read.csv("data/gen_exposure_acceptability.csv")
gen_surprisals = read.csv("data/gen_surprisals.csv")
gen_data$sentence_mean = double(nrow(gen_data))

for (i in 1:max(nrow(gen_data))) {
  row = gen_data[i,]
  #gen_data$sentence_mean[i] = 
  surps = gen_surprisals$mean_surprisal
  surp_idx = as.integer(row["sentence_id"]) - 1
  gen_data$sentence_mean[i] = surps[surp_idx]
}
gen_data = gen_data %>% 
  dplyr::rename(condition = "item_type")

# load adaptation data and add surprisal values for corresponding sentences

adapt_data = read.csv("data/adapt_exposure_acceptability.csv")
adapt_data = select(adapt_data, c("workerid",  "sentence_id", "block_sequence", "phase", "response", "condition"))
adapt_surprisals = read.csv("data/adapt2_surprisals.csv")
for (i in 1:max(nrow(adapt_data))) {
  row = adapt_data[i,]
  #gen_data$sentence_mean[i] = 
  surps = adapt_surprisals$mean_surprisal
  surp_idx = as.integer(row["sentence_id"]) + 1
  adapt_data$sentence_mean[i] = surps[surp_idx]
}

combined = rbind(gen_data, adapt_data)


plot = combined %>%
  ggplot((aes(x = sentence_mean, y= response))) +
  geom_point(aes(color = condition)) +
  geom_smooth(method = "lm", se=FALSE) +
  labs(title = "Mean Acceptability and Surprisal", 
       x = "Mean Surprisal", 
       y = "Acceptability") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text())
plot


intercept_only = lmer(response ~ 1 + (1 | workerid), combined)
summary(intercept_only)

surp_only = lmer(response ~ 1 + sentence_mean + (1 | workerid), combined)
summary(surp_only)

surp_cond = lmer(response ~ 1 + sentence_mean + condition + (1 | workerid), combined)
summary(surp_cond)

cond_only = lmer(response ~ 1 + condition + (1 | workerid), combined)
summary(cond_only)

