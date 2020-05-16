# This downloads source code for Hugging Face transformers
# my intent is to use it as a corpus for my dissertation research

source_url <- "https://github.com/huggingface/transformers/archive/master.zip"


source("R/00_get_repo.R")

huggingface_transformers <- get_repo(source_url)

save(huggingface_transformers, file = "data_derived/huggingface_transformers.RData")


# library(tidyverse)
# 
# 
# # create the appropriate directory to store downloads
# in_folder <- "data_raw/huggingface_transformers"
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
#   url = source_url,
#   destfile = paste0(in_folder, "/master.zip")
# )
# 
# unzip(
#   zipfile = paste0(in_folder, "/master.zip"),
#   exdir = in_folder
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
# huggingface_transformers <- 
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
# huggingface_transformers <- do.call(rbind, huggingface_transformers)
# 
# huggingface_transformers$downloaded <- lubridate::ymd_hms(time)
# 
# # do some formatting
# huggingface_transformers$id <-
#   huggingface_transformers$id %>%
#   str_replace_all(
#     paste0(in_folder, "/"),
#     ""
#   )
# 
# huggingface_transformers <- 
#   huggingface_transformers %>%
#   mutate(
#     file_ext = id %>%
#       str_split(pattern = "\\.") %>%
#       sapply(function(x) {
#         if (length(x) > 1) {
#           x[length(x)]
#         } else {
#           ""
#         }
#       })
#       )
# 
#   
# 
# save(huggingface_transformers, file = "data_derived/huggingface_transformers.RData")
