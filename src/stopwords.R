library(dplyr)

DOUT = commandArgs(TRUE)
tidytext::stop_words %>% 
  filter(lexicon == "snowball") %>% 
  .$word %>%
  writeLines(DOUT)
