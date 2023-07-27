library(tidyverse)
library(ggplot2)
library(ggthemes)
data1 = read.csv("gpt2_satiation/output/gen_CNPC30_CNPCtest_WordByWord_surprisals.csv")
data2 = read.csv("gpt2_satiation/output/gen_CNPC0_CNPCtest_WordByWord_surprisals.csv")
data = data2
data$surprisal = data1$surprisal - data2$surprisal
data %>%
  filter(sentence == 10 | sentence == 11) %>%
  ggplot((aes(x = word, y= surprisal))) +
  geom_line(aes(group = sentence, color = sentence)) +
  geom_point(aes(color = sentence)) +
  #geom_smooth(method = "lm", se=FALSE) +
  labs(title = "Word By Word Surprisal", 
       x = "Word Number in Sentence", 
       y = "Difference in Surprisal (Tested on self)") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text())
