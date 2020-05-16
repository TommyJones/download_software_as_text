### The script defines a function to download a repo from github and format
# its files as a tibble. The file content is read in as text. Note that this 
# means not all files will be valid text input. For example if the repo contains
# an image or some other binary data, processing it as text can cause a crash.
# A mitigation I've made is to parse the file extensions as a variable. If an 
# extension indicates that the file isn't text, you can omit it. No guarantees
# that will work 100% though. 

library(tidyverse)

# this function writes to disk. buyer beware, etc. etc.
get_repo <- function(url_to_zip) {
  
  # download the file to a temporary location
  download.file(
    url = url_to_zip,
    destfile = "tmp.zip"
  )
  
  # get a list of all the files from the zip file
  file_list <- unzip(
    "tmp.zip",
    list = TRUE
  )
  
  file_list <- as_tibble(file_list)
  
  file_list <- 
    file_list %>%
    filter(Length > 0)
  
  # unzip and read in all the files
  unzip(
    "tmp.zip",
    exdir = "tmp"
  )
  
  
  file_list$text <- 
    parallel::mclapply(
      file_list$Name,
      function(x) {
        try({
          read_lines(
            paste0("tmp/", x)
          )
        }) %>%
          paste(collapse = "\n")
      },
      mc.cores = parallel::detectCores() - 1
    ) %>%
    unlist()
  
  # clean up that temporary zip file and extracted files
  file.remove("tmp.zip")
  
  unlink("tmp", recursive = TRUE)
  
  # do some formatting
  file_list <- 
    file_list %>%
    mutate(
      file_ext = Name %>%
        str_split(pattern = "\\.") %>%
        sapply(function(x) {
          if (length(x) > 1) {
            x[length(x)]
          } else {
            ""
          }
        })
    )
  
  file_list <- 
    file_list %>%
    mutate(name = Name, 
           file_ext = file_ext,
           size_bytes = Length,
           link_to_repo = url_to_zip,
           date_downloaded = Date,
           text = text) %>%
    select(
      name,
      file_ext,
      size_bytes,
      link_to_repo,
      date_downloaded,
      text
    )

  # return a tibble
  file_list
  
}


