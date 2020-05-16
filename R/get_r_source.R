# This downloads source code for R source code
# my intent is to use it as a corpus for my dissertation research



source_url <- "https://github.com/wch/r-source/archive/trunk.zip"

source("R/00_get_repo.R")

r_source <- get_repo(source_url)

save(r_source, file = "data_derived/r_source.RData")
