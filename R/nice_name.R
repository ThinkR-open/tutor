nice_name <- function(n, lang = "fr") {
  n %>%
    basename() %>%
    str_split("-") %>%
    map_chr(~ {
      str_c(
        .x,
        collapse = "_"
      )
    }) %>%
    str_to_lower() %>%
    str_remove(paste0("_", lang)) %>%
    str_remove("^[0-9]*_") %>%
    str_remove("[.]rmd") %>%
    paste0(paste0("_", lang))
}
