library(tidyverse)
tous <- tutor:::tous_les_programmes()
nice_name(tous)

cat(
glue::glue("
#' @export
#' @noRd
*tutor:::nice_name(tutor:::tous_les_programmes())* <- function(file=tutor:::tous_les_programmes()[*seq_along(tutor:::tous_les_programmes())*],...){tutor::launch_learn(file=file,...)}

           ",.open = "*",.close = "*"),file="R/all_functions.R",sep="\n")

