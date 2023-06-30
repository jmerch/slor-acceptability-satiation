library(dplyr) 
MAX_BLOCK_SEQ <- 3
exp1 <- read.csv("data/exp1c_cleaned.csv")
exp2 <- read.csv("data/exp2_cleaned.csv")
exp1min <- exp1 %>% select(c("sentence_id", "block_sequence", "phase", "response", "item_type"))
exp2min <- exp2 %>% select(c("sentence_id", "block_sequence", "phase", "response", "item_type"))
exposure1 <- filter(exp1min, phase != 'test')
exposure2 <- filter(exp2min, phase != 'test')
#exposure1 <- filter(exposure1, item_type != "UNGRAM" & item_type != "POLAR" & item_type != "FILL")
#exposure2 <- filter(exposure2, item_type != "UNGRAM" & item_type != "POLAR" & item_type != "FILL") 
all_exposure <- rbind(exposure1, exposure2)
surprisals <- read.csv("data/mean_surprisal.csv")
surprisals
### create df for mean acceptability 
# will have id, all, first_three
ratings <- data.frame(matrix(ncol = 4, nrow = 0))

#provide column names
for (id in min(all_exposure$sentence_id):max(all_exposure$sentence_id)){
  if (id %in% all_exposure$sentence_id) {
    all <- mean(all_exposure[all_exposure$sentence_id == id, 'response'])
    first_3 <- mean(all_exposure[all_exposure$sentence_id == id & all_exposure$block_sequence <= MAX_BLOCK_SEQ, 'response'])
    surprisal <- surprisals$mean_surprisal[id - 1]
    new_row <- c(sentence_id = id, all_exposures = all, first_three_exposures = first_3, mean_surprisal = surprisal)
    ratings <- rbind(ratings, new_row)
  }
}
colnames(ratings) <- c('sentence_id', 'all_exposures', 'first_three_exposures', 'mean_surprisal')
ratings
plot(ratings$mean_surprisal, ratings$all_exposures, col = 1, xlab="Mean Surprisal",ylab="Mean Acceptability")
surp_vs_all <- data.frame(x = ratings$mean_surprisal, y = ratings$all_exposures)
s_v_a_model <- lm(y~x, data=surp_vs_all)
surprisal_range <- seq(1, 14, length=14)
# add curve of each model to plot
lines(x_axis, predict(s_v_a_model, data.frame(x=surprisal_range)), col='green')
plot(ratings$mean_surprisal, ratings$first_three_exposures, col = 1, xlab="Mean Surprisal",ylab="Mean Acceptability (<= 3 blocks)")
surp_vs_f3 <- data.frame(x = ratings$mean_surprisal, y = ratings$first_three_exposures)
s_v_f3_model <- lm(y~x, data=surp_vs_f3)
lines(x_axis, predict(s_v_f3_model, data.frame(x=surprisal_range)), col='green')
summary(s_v_a_model)
