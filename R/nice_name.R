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
