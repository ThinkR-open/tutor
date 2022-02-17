lang <- "en"

dirs_lg <- list.dirs(paste0("inst/learnr/",lang), recursive = FALSE) %>% list.dirs(recursive = FALSE)

clean_names <- paste0(basename(tolower(dirs_lg)), "_" ,lang)

fs::dir_copy(dirs_lg, file.path("inst","tutorials", clean_names))
basename(dirs_lg)

target_learnr_and_delete <- function(){
  target_tutorial_dir <- list.files(system.file(package = "learnr"), pattern = "^tutorials$", full.names = TRUE)
  fs::dir_delete(target_tutorial_dir)
}
