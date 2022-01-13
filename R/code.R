#' @importFrom  magrittr %>%
#' @import stringr
#' @import purrr
get_header <- function(file){
  suppressWarnings(
    base <- file %>%    readLines() # on ouvre le fihcier ligne a ligne
  )
  pos <- base %>%
    str_detect("---") %>%
    which() # on detecte les balise d'ouverture et fermeture

  if (length(pos)>=2){return(base[pos[1]:pos[2]])} # on retourne le header

  return("")
}

is_shiny_prerendered <- function(header,balise="runtime:shiny_prerendered"){

  res <-  header %>%
    map_chr(~str_remove_all(.x,"\\s")) %>%
    str_detect(balise) %>% sum()
  res >= 1
}

tous_les_programmes <- function(lang="fr"){
  tous_les_rmd<-list.files(system.file("learnr",lang, package = "tutor"),
                           all.files = TRUE,full.names = TRUE,
                           include.dirs = FALSE,no.. = FALSE,
                           recursive = TRUE
                           ,
                           pattern = "*.Rmd$"
  )
  a_garder <- tous_les_rmd %>%
    map(get_header) %>%
    map_lgl(is_shiny_prerendered)
  tous_les_rmd[a_garder]
}

#' Title
#'
#' @param file file to launch
#' @param host host
#' @param port port to use
#'
#' @importFrom httpuv randomPort
#' @export
#'
launch_learn <- function(file=sample(tous_les_programmes(),1),port=httpuv::randomPort(),host='0.0.0.0'){
  message(file)
  # browser()
  bacasable <- tempdir()
  try(fs::dir_copy(path = dirname(file), new_path = bacasable
                   # ,overwrite = TRUE
                   )

  )

  rmarkdown::run(file = file.path(bacasable,basename(dirname(file))     ,basename(file)),

                   # basename(file),
                 # dir = file.path(bacasable,basename(file)),
                 shiny_args = list(port = port,host=host))
}
