DOUT = commandArgs(TRUE)
for ( fp in DOUT )
    writeLines(LETTERS, fp)
