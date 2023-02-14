stopwords = readLines("made/stopwords.txt")
d = readr::read_csv("made/merged.csv")
DOUT = "made/wordfreq.png"

# Call as:
#   Rscript this.R  path/to/merged.csv  path/to/stopwords.txt  path/to/output.png
if (!interactive()) {
  args = commandArgs(TRUE)
  d = readr::read_csv(args[1])
  stopwords = readLines(args[2])
  DOUT = args[3]
}


library(ggplot2)
library(dplyr)
theme_set(theme_bw())


d$isstop = tolower(d$token) %in% stopwords

plt = d %>% 
  filter(!isstop) %>% 
ggplot() +
  geom_bar( aes(reorder(token, freq), freq), stat = "identity" ) +
  facet_wrap( vars(file), ncol = 1, scales = "free_y") +
  labs( x = "Token", y = "Freq" ) +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))

ggsave(DOUT, plt, width = 12, height = 7.5)
