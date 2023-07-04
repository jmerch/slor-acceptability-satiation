library(dplyr)

ratings <- read.csv("data/ratings.csv")
surprisals <- read.csv("data/surprisals.csv")
plot(ratings$mean_surprisal, ratings$all_exposures, col = 1, xlab="Mean Surprisal",ylab="Mean Acceptability")
surp_vs_all <- data.frame(x = ratings$mean_surprisal, y = ratings$all_exposures)
s_v_a_model <- lm(y~x, surp_vs_all)
x_axis <- seq(1, 14, length=14)
lines(x_axis, predict(s_v_a_model, data.frame(x=x_axis)), col='green')
plot(ratings$mean_surprisal, ratings$first_three_exposures, col = 1, xlab="Mean Surprisal",ylab="Mean Acceptability (<= 3 blocks)")
surp_vs_f3 <- data.frame(x = ratings$mean_surprisal, y = ratings$first_three_exposures)
s_v_f3_model <- lm(y~x, data=surp_vs_f3)
lines(x_axis, predict(s_v_f3_model, data.frame(x=x_axis)), col='green')

plot(ratings$weight_first, ratings$all_exposures, col = 1, xlab="Weighted Mean Surprisal (first word)",ylab="Mean Acceptability")

plot(ratings$weight_last, ratings$all_exposures, col = 1, xlab="Weighted Mean Surprisal (last word)",ylab="Mean Acceptability")

plot(ratings$weight_sum, ratings$all_exposures, col = 1, xlab="Weighted Mean Surprisal (sum)",ylab="Mean Acceptability")




# factor in condition:
all_cond_model <- lm(ratings$all_exposures~ratings$mean_surprisal*ratings$condition, ratings)
f3_cond_model <- lm(ratings$first_three_exposures~ratings$mean_surprisal*ratings$condition, ratings)
all_cond_last_model <- lm(ratings$all_exposures~ratings$weight_last*ratings$condition, ratings)
f3_cond_last_model <- lm(ratings$first_three_exposures~ratings$weight_last*ratings$condition, ratings)
summary(all_cond_model)
summary(f3_cond_model)
AIC(all_cond_model)
AIC(f3_cond_model)
AIC(s_v_a_model)
AIC(s_v_f3_model)
AIC(all_cond_last_model)
AIC(f3_cond_last_model)
BIC(all_cond_model)
BIC(f3_cond_model)
BIC(s_v_a_model)
BIC(s_v_f3_model)
BIC(all_cond_last_model)
BIC(f3_cond_last_model)
