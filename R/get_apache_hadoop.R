# This downloads source code for apache hadoop
# my intent is to use it as a corpus for my dissertation research

source_url <- "https://github.com/apache/hadoop/archive/trunk.zip"

source("R/00_get_repo.R")

apache_hadoop <- get_repo(source_url)

save(apache_hadoop, file = "data_derived/apache_hadoop.RData")





# library(tidyverse)
# 
# 
# # create the appropriate directory to store downloads
# in_folder <- "data_raw/apache_hadoop"
# 
# if (! dir.exists(in_folder))
#   dir.create(in_folder)
# 
# time <- 
#   Sys.time() %>%
#   as.character() %>%
#   str_replace(pattern = "( |:)", replacement = "\\.")
# 
# in_folder <- paste(in_folder, time, sep = "/")
# 
# if (! dir.exists(in_folder))
#   dir.create(in_folder)
# 
# # download and unzip the file
# download.file(
#   url = "https://github.com/apache/hadoop/archive/trunk.zip",
#   destfile = paste0(in_folder, "/trunk.zip")
# )
# 
# unzip(
#   zipfile = paste0(in_folder, "/trunk.zip"),
#   exdir = paste0(in_folder, "/trunk/")
# )
# 
# # read in each file as its own document
# in_file_list <- 
#   list.files(
#     path = in_folder,
#     recursive = TRUE,
#     full.names = TRUE
#   )
# 
# in_file_list <- in_file_list[! str_detect(in_file_list, "\\.zip")]
# 
# apache_hadoop <- 
#   parallel::mclapply(
#     in_file_list,
#     function(x) {
#       # read the file in
#       file <- read_lines(x, skip_empty_rows = FALSE)
#       
#       file[is.na(file)] <- ""
#       
#       # collapse by newline
#       file <- paste(file, collapse = "\n")
#       
#       # create a one line tibble
#       out <- tibble(
#         id = x,
#         text = file
#       )
#       
#       out
#     },
#     mc.cores = parallel::detectCores() - 1
#   )
# 
# apache_hadoop <- do.call(rbind, apache_hadoop)
# 
# apache_hadoop$downloaded <- lubridate::ymd_hms(time)
# 
# save(apache_hadoop, file = "data_derived/apache_hadoop.RData")
