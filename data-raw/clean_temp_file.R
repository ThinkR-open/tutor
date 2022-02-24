library(purrr)
list.files(path = "inst/",pattern = "html$",recursive = TRUE,full.names = TRUE) %>% lapply(fs::file_delete)
list.dirs(path = "inst/",recursive = TRUE,full.names = TRUE) %>%
  str_subset(pattern = "_files$")%>% lapply(fs::dir_delete)
list.dirs()
