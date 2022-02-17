library(tidyverse)
tous <- tutor:::tous_les_programmes(lang = 'en')
tutor:::nice_name(tous,lang="en")

cat(
glue::glue("
#' Lance *tutor:::nice_name(tutor:::tous_les_programmes())*
#' @param file name of the learnr to launch
#' @param ... other params
#' @export
*tutor:::nice_name(tutor:::tous_les_programmes())* <- function(file=tutor:::tous_les_programmes()[*seq_along(tutor:::tous_les_programmes())*],...){tutor::launch_learn(file=file,...)}

           ",.open = "*",.close = "*"),file="R/all_functions.R",sep="\n")

cat(
glue::glue("
#' launch *tutor:::nice_name(tutor:::tous_les_programmes(lang='en'),lang='en')*
#' @param file name of the learnr to launch
#' @param ... other params
#' @export
*tutor:::nice_name(tutor:::tous_les_programmes(lang='en'),lang='en')* <- function(file=tutor:::tous_les_programmes(lang='en')[*seq_along(tutor:::tous_les_programmes(lang='en'))*],...){tutor::launch_learn(file=file,...)}

           ",.open = "*",.close = "*"),file="R/all_functions_en.R",sep="\n")




