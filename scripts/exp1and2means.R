library(dplyr) 
MAX_BLOCK_SEQ <- 3
exp1 <- read.csv("data/exp1c_cleaned.csv")
exp2 <- read.csv("data/exp2_cleaned.csv")
exp1min <- exp1 %>% select(c("workerid", "sentence_id", "block_sequence", "phase", "response", "item_type"))
exp2min <- exp2 %>% select(c("workerid", "sentence_id", "block_sequence", "phase", "response", "item_type"))
exposure1 <- filter(exp1min, phase != 'test')
exposure2 <- filter(exp2min, phase != 'test')
all_exposure <- rbind(exposure1, exposure2)
all_exposure <- all_exposure %>% arrange(sentence_id)
write.csv(all_exposure, "data/gen_exposure_acceptability.csv", row.names=FALSE)
surprisals <- read.csv("data/gen_surprisals.csv")
ratings <- data.frame(matrix(ncol = 18, nrow = 0))
for (id in min(all_exposure$sentence_id):max(all_exposure$sentence_id)){
  if (id %in% all_exposure$sentence_id) {
    all <- mean(all_exposure[all_exposure$sentence_id == id, 'response'])
    first_3 <- mean(all_exposure[all_exposure$sentence_id == id & all_exposure$block_sequence <= MAX_BLOCK_SEQ, 'response'])
    surprisal <- surprisals$mean_surprisal[id - 1]
    first <- surprisals$weight_first[id - 1]
    last <- surprisals$weight_last[id - 1]
    normal <- surprisals$normalized[id-1]
    sum <- surprisals$weight_sum[id - 1]
    gap <- surprisals$gap[id-1]
    #normalized_gap <- surprisals$normalized_gap[id - 1]
    #region <- surprisals$region_mean[id - 1]
    wh <- surprisals$wh[id - 1]
    matrix <- surprisals$matrix[id - 1]
    embedded <- surprisals$embedded[id - 1]
    comp <- surprisals$comp[id - 1]
    matrix_norm = surprisals$matrix_norm[id - 1]
    comp_norm = surprisals$comp_norm[id - 1]
    embedded_norm = surprisals$embedded_norm[id - 1]
    gap_norm = surprisals$gap_norm[id - 1]
    condition <- subset(all_exposure, sentence_id == id)[1,]["item_type"]
    new_row <- c(sentence_id = id, condition = condition, all_exposures = all, first_three_exposures = first_3, mean_surprisal = surprisal, weight_first = first, weight_last = last, weight_sum = sum, normalized = normal, wh = wh, matrix = matrix, comp = comp, embedded = embedded, gap = gap, matrix_norm = matrix_norm, comp_norm = comp_norm, embedded_norm = embedded_norm, gap_norm = gap_norm)
    ratings <- rbind(ratings, new_row)
  }
}
colnames(ratings) <- c('sentence_id', 'condition', 'all_exposures', 'first_three_exposures', 'mean_surprisal', 'weight_first', 'weight_last', 'weight_sum', 'normalized', 'wh', 'matrix', 'comp', 'embedded', 'gap', 'matrix_norm', 'comp_norm', 'embedded_norm', 'gap_norm')
ratings = filter(ratings, sentence_id != 23 & sentence_id != 39)
ratings = type.convert(ratings)
write.csv(ratings, "data/genRatings.csv", row.names=FALSE)

sentence_types = ratings %>% select(c('sentence_id', 'condition'))
write.csv(sentence_types, "data/genID_to_cond.csv", row.names=FALSE)