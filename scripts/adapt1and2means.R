library(dplyr) 

#exp1c <- read.csv("data/satiation_baseline_cleaned.csv")
exp2 <- read.csv("data/satiation_exp2_cleaned.csv")
exp2 <- filter(exp2, phase == "exposure")
surprisals2 <- read.csv("data/adapt_surprisals.csv")
#exp1c <- arrange(exp1c, list_number)
#exp1c <- arrange(exp1c, item_number)
uniqueIds <- read.csv("data/adapt2ids.csv")

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
write.csv(exp2, "data/adapt_exposure_acceptability.csv", row.names = FALSE)


ratings <- data.frame(matrix(ncol = 18, nrow = 0))
colnames(ratings) <- c('sentence_id', 'condition', 'all_exposures', 'first_three_exposures', 'mean_surprisal', 'weight_first', 'weight_last', 'weight_sum', 'normalized', 'wh', 'matrix', 'comp', 'embedded', 'gap', 'matrix_norm', 'comp_norm', 'embedded_norm', 'gap_norm')
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
      wh <- surprisals2$wh[id + 1]
      matrix <- surprisals2$matrix[id + 1]
      embedded <- surprisals2$embedded[id + 1]
      comp <- surprisals2$comp[id + 1]
      matrix_norm = surprisals2$matrix_norm[id + 1]
      comp_norm = surprisals2$comp_norm[id + 1]
      embedded_norm = surprisals2$embedded_norm[id + 1]
      gap_norm = surprisals2$gap_norm[id + 1]
      #beyond = surprisals2$beyond[id + 1]
      new_row <- c(sentence_id = id, condition = condition, all_exposures = all, first_three_exposures = first_3 , mean_surprisal = surprisal, weight_first = first, weight_last = last, weight_sum = sum, normalized = normal, wh = wh, matrix = matrix, comp = comp, embedded = embedded, gap = gap, matrix_norm = matrix_norm, comp_norm = comp_norm, embedded_norm = embedded_norm, gap_norm = gap_norm)
      ratings <- rbind(ratings, new_row)
      }
}
type.convert(ratings)
ratings = ratings %>%
  dplyr::rename(condition = "condition.condition")
write.csv(ratings, "data/adaptRatings.csv", row.names=FALSE)


contextRatings <- data.frame(matrix(ncol = 18, nrow = 0))
contextSurprisals <- read.csv("data/adaptContext_surprisals.csv")
for (id in min(exp2$sentence_id):max(exp2$sentence_id)){
  if (id %in% exp2$sentence_id) {
    all <- mean(exp2[exp2$sentence_id == id, 'response'])
    first_3 <- mean(exp2[exp2$sentence_id == id & exp2$block_sequence <= 3, 'response'])
    surprisal <- contextSurprisals$mean_surprisal[id + 1]
    first <- contextSurprisals$weight_first[id + 1]
    last <- contextSurprisals$weight_last[id + 1]
    normal <- contextSurprisals$normalized[id + 1]
    sum <- contextSurprisals$weight_sum[id + 1]
    sentence_id <- id
    condition <- subset(exp2, sentence_id == id)[1,]["condition"]
    gap <- contextSurprisals$gap[id + 1]
    wh <- contextSurprisals$wh[id + 1]
    matrix <- contextSurprisals$matrix[id + 1]
    embedded <- contextSurprisals$embedded[id + 1]
    comp <- contextSurprisals$comp[id + 1]
    matrix_norm = contextSurprisals$matrix_norm[id + 1]
    comp_norm = contextSurprisals$comp_norm[id + 1]
    embedded_norm = contextSurprisals$embedded_norm[id + 1]
    gap_norm = contextSurprisals$gap_norm[id + 1]
    #beyond = contextSurprisals$beyond[id + 1]
    new_row <- c(sentence_id = id, condition = condition, all_exposures = all, first_three_exposures = first_3 , mean_surprisal = surprisal, weight_first = first, weight_last = last, weight_sum = sum, normalized = normal, wh = wh, matrix = matrix, comp = comp, embedded = embedded, gap = gap, matrix_norm = matrix_norm, comp_norm = comp_norm, embedded_norm = embedded_norm, gap_norm = gap_norm)
    contextRatings <- rbind(contextRatings, new_row)
  }
}
colnames(contextRatings) <- c('sentence_id', 'condition', 'all_exposures', 'first_three_exposures', 'mean_surprisal', 'weight_first', 'weight_last', 'weight_sum', 'normalized', 'wh', 'matrix', 'comp', 'embedded', 'gap', 'matrix_norm', 'comp_norm', 'embedded_norm', 'gap_norm')
type.convert(contextRatings)
write.csv(contextRatings, "data/adaptContextRatings.csv", row.names=FALSE)
sentence_types = contextRatings %>% select(c('sentence_id', 'condition'))
write.csv(sentence_types, "data/adapt2ID_to_cond.csv", row.names=FALSE)
