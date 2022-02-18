library(tidyverse)
tous <- tutor:::tous_les_programmes(lang = "en")
tutor:::nice_name(tous, lang = "en")

cat(
  glue::glue("
#' Lance *tutor:::nice_name(tutor:::tous_les_programmes())*
#' @param ... other params
#' @export
*tutor:::nice_name(tutor:::tous_les_programmes())* <- function(...){tutor::launch_learn(file=tous_les_programmes()[*seq_along(tutor:::tous_les_programmes())*],...)}

           ", .open = "*", .close = "*"),
  file = "R/all_functions.R",
  sep = "\n"
)

cat(
  glue::glue("
#' launch *tutor:::nice_name(tutor:::tous_les_programmes(lang='en'),lang='en')*
#' @param ... other params
#' @export
*tutor:::nice_name(tutor:::tous_les_programmes(lang='en'),lang='en')* <- function(...){tutor::launch_learn(file=tous_les_programmes(lang='en')[*seq_along(tutor:::tous_les_programmes(lang='en'))*],...)}

           ", .open = "*", .close = "*"),
  file = "R/all_functions_en.R",
  sep = "\n"
)
