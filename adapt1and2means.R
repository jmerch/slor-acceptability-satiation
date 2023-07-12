library(dplyr) 

#exp1c <- read.csv("data/satiation_baseline_cleaned.csv")
exp2 <- read.csv("data/satiation_exp2_cleaned.csv")
exp2 <- filter(exp2, phase == "exposure")
surprisals2 <- read.csv("data/adapt2_surprisals.csv")
#exp1c <- arrange(exp1c, list_number)
#exp1c <- arrange(exp1c, item_number)
uniqueIds <- read.csv("data/adapt2ids.csv")
ratings <- data.frame(matrix(ncol = 14, nrow = 0))
ids <- integer(nrow(exp2))
for(i in 1:nrow(exp2)) {
  row <- exp2[i,]
  item <- as.integer(row["item_number"])
  if (item %in% uniqueIds$item_number) {
    list <- as.integer(row["list_number"])
    id <- uniqueIds[uniqueIds$list_number == list & uniqueIds$item_number == item, 'sentence_id']
    ids[i] <- id
  }
}

exp2$sentence_id <- ids


for (id in min(exp2$sentence_id):max(exp2$sentence_id)){
      if (id %in% exp2$sentence_id) {
      all <- mean(exp2[exp2$sentence_id == id, 'response'])
      first_3 <- mean(exp2[exp2$sentence_id == id & exp2$block_sequence <= 3, 'response'])
      surprisal <- surprisals2$mean_surprisal[id + 1]
      first <- surprisals2$weight_first[id + 1]
      last <- surprisals2$weight_last[id + 1]
      normal <- surprisals2$normalized[id + 1]
      sum <- surprisals2$weight_sum[id + 1]
      sentence_id <- id
      condition <- subset(exp2, sentence_id == id)[1,]["condition"]
      gap <- surprisals2$gap[id + 1]
      #normalized_gap <- surprisals$normalized_gap[id - 1]
      #region <- surprisals$region_mean[id - 1]
      wh <- surprisals2$wh[id + 1]
      matrix <- surprisals2$matrix[id + 1]
      embedded <- surprisals2$embedded[id + 1]
      comp <- surprisals2$comp[id + 1]
      new_row <- c(sentence_id = id, condition = condition, all_exposures = all, first_three_exposures = first_3 , mean_surprisal = surprisal, weight_first = first, weight_last = last, weight_sum = sum, normalized = normal, wh = wh, matrix = matrix, comp = comp, embedded = embedded, gap = gap)
      ratings <- rbind(ratings, new_row)
      }
}
colnames(ratings) <- c('sentence_id', 'condition', 'all_exposures', 'first_three_exposures', 'mean_surprisal', 'weight_first', 'weight_last', 'weight_sum', 'normalized', 'wh', 'matrix', 'comp', 'embedded', 'gap')
type.convert(ratings)
write.csv(ratings, "data/adaptRatings.csv", row.names=FALSE)
sentence_types = ratings %>% select(c('sentence_id', 'condition'))
write.csv(sentence_types, "data/adapt2ID_to_cond.csv", row.names=FALSE)
