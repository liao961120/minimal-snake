# Call as:
#     Rscript this.py path/to/some.html path/to/output.csv

DIN = "raw/html/doc2.html"
DOUT = "made/word_freq.csv"

if (!interactive()) {
  args = commandArgs(TRUE)
  DIN = args[1]
  DOUT = args[2]
}

library(rvest)

html = read_html(DIN)
text = html %>% html_nodes("body p") %>% html_text(trim = T)

tokens = sapply( text, function(p) { 
  tokens = strsplit(p, "\\s+")[[1]]
  tokens = trimws(tokens, whitespace = "[,.;:!()]")
  tokens
}, USE.NAMES = F)

freq =  unlist(tokens) %>% table() %>% sort(decreasing = T)
df = freq[freq > 10] %>% as.data.frame()
df$file = trimws(basename(DIN), whitespace = "\\.html")
readr::write_csv(df, DOUT, col_names = FALSE)
