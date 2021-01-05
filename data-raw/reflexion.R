library(tidyverse)
tous <- tutor:::tous_les_programmes()
nice_name <- function(n){
  n %>%
    basename() %>%
    str_split("-") %>%
    map_chr(~{
      str_c(    .x
                # [-c(1,length(.x))]
                ,collapse = "_")
    }) %>% str_to_lower()%>%
    str_remove("_fr") %>%
    str_remove("^[0-9]*_") %>%
    str_remove("[.]rmd") %>%
    paste0("_fr")

}

nice_name(tous)

cat(
glue::glue("
#' @export
#' @noRd
*nice_name(tutor:::tous_les_programmes())* <- function(file=tutor:::tous_les_programmes()[*seq_along(tutor:::tous_les_programmes())*],...){tutor::launch_learn(file=file,...)}

           ",.open = "*",.close = "*"),file="R/all_functions.R",sep="\n")

