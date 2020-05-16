# This downloads source code for linux
# my intent is to use it as a corpus for my dissertation research

source_url <- "https://github.com/torvalds/linux/archive/master.zip"

source("R/00_get_repo.R")

linux <- get_repo(source_url)

save(linux, file = "data_derived/linux.RData")
