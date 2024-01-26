library(tidyverse)

disjunction = select(read.csv("acceptability_modeling/data/disjunction_cleaned.csv"), c("sentence_id", "condition_alt", "response"))

disjunction_means = disjunction %>%
  group_by(sentence_id, condition_alt) %>%
  dplyr::summarize(mean_acc = mean(response)) %>%
  dplyr::rename(condition = "condition_alt")
  
#write.csv(select(disjunction_means, c("sentence_id", "condition")), "data/disjunctionID_to_cond.csv", row.names = FALSE)

surps = read.csv("acceptability_modeling/data/disjunction_surprisals.csv")

disjunction_means$mean_surprisal = surps$mean_surprisal
disjunction_means$normalized_surprisal = surps$normalized

write.csv(disjunction_means, "acceptability_modeling/data/disjunctionRatings.csv", row.names=FALSE)