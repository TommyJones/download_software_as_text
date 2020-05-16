# This downloads source code for gcc
# my intent is to use it as a corpus for my dissertation research

source_url <- "https://github.com/gcc-mirror/gcc/archive/master.zip"

source("R/00_get_repo.R")

gcc <- get_repo(source_url)

save(gcc, file = "data_derived/gcc.RData")
