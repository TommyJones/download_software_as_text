### The script defines a function to download a repo from github and format
# its files as a tibble. The file content is read in as text. Note that this 
# means not all files will be valid text input. For example if the repo contains
# an image or some other binary data, processing it as text can cause a crash.
# I've made two mitigations: 
# (a) parse file extensions as a variable for filtering
# (b) added a flag for valid UTF-8 text
#
# (a) requires knowlede and manual filtering
# (b) could fail because you could have valid text that just needs to be
# converted to UTF-8 using str_conv. Also note that if you use use str_conv on
# not valid text (e.g. from a png) validUTF8() will say that the result is 
# valid text. But parsing it as text (e.g. tokenization) may result in a crash 
# or error.


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
    mutate(
           link_to_repo = url_to_zip,
           valid_utf8 = validUTF8(text)
           ) %>%
    select(
      name = Name,
      valid_utf8,
      file_ext,
      size_bytes = Length,
      link_to_repo,
      date_downloaded = Date,
      text
    )

  # return a tibble
  file_list
  
}


