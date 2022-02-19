library(tidyverse)
rmd_run <- function(
  a_parcourir = list.files(
    path = (system.file("tutorials", package = "tutor")),
    pattern = "Rmd$",
    recursive = TRUE,
    full.names = TRUE
  ),
  output = tempdir()
) {
  safe_render <- purrr::safely(rmarkdown::render)

  res <- a_parcourir %>%
    map(
      ~ safe_render(.x, output_dir = output)
    ) %>%
    set_names(basename(a_parcourir))

  resultat <- list(
    res = res,
    output = output
  )
  resultat
}

some_test <- rmd_run()
les_erreurs <- some_test$res %>%
  transpose() %>% pluck("error")

expect_true(length(compact(les_erreurs)) == 0)
