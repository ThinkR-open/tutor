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
  tous_les_rmd <- list.files(
    system.file("tutorials/", package = "tutor"),
    all.files = TRUE,
    full.names = TRUE,
    include.dirs = FALSE,
    no.. = FALSE,
    recursive = FALSE,
    pattern = paste0("*_", lang)
  )

  to_be_check <- list.files(
    tous_les_rmd,
    all.files = TRUE,
    full.names = TRUE,
    include.dirs = FALSE,
    no.. = FALSE,
    recursive = TRUE,
    pattern = "*.Rmd"
  )

  a_garder <- to_be_check %>%
    map(get_header) %>%
    map_lgl(is_shiny_prerendered)

  basename(tous_les_rmd[a_garder])

}

#' Launch learnr
#'
#' @param file file to launch
#' @param zoom zoom on tutorial windows
#'
#' @export
#'
launch_learn <- function(file = sample(tous_les_programmes(), 1),
                         zoom = TRUE) {
  message(file)

    # if (rstudioapi::isAvailable()) {
      if (!is.null(tuto_env$running_tuto)) {
        .rs.api.stopJob(tuto_env$running_tuto$job)
        try(later::destroy_loop(loop_tuto), silent = TRUE)
        Sys.sleep(2)
      }
      .rs.tutorial.runTutorial(file, package = "tutor")

      tuto_env$running_tuto <-
        .rs.tutorial.registryGet(file, package = "tutor")

      if (zoom) {
        tuto_env$loop_tuto <- later::create_loop()
        # rstudioapi::executeCommand("layoutZoomTutorial")
        # rstudioapi::executeCommand("layoutZoomTutorial")
        # rstudioapi::executeCommand("layoutZoomTutorial")
        # later::later(function(){rstudioapi::executeCommand("layoutZoomTutorial")}, 5)
        # later::later(function(){rstudioapi::executeCommand("layoutZoomTutorial")}, 10)
        later::later(function(){rstudioapi::executeCommand("layoutZoomTutorial")}, 1)
        # later::later(function(){rstudioapi::executeCommand("layoutZoomTutorial")}, 20)
        # later::later(function(){rstudioapi::executeCommand("layoutZoomTutorial")}, 25)
        # later::later(function(){rstudioapi::executeCommand("layoutZoomTutorial")}, 30)
        # later::later(function(){rstudioapi::executeCommand("layoutZoomTutorial")}, 35)
        # later::later(function(){rstudioapi::executeCommand("layoutZoomTutorial")}, 40)

        if (grepl(file, pattern = "_fr$")) {
          .rs.api.showDialog(
            "Information",
            "Veuillez patienter quelques instants le temps que l'exercice se charge dans l'onglet tutorial.

            Une fois chargé l'exercice qui se mettra en Plein écran, Pour le quitter cliquez sur le bouton 'stop' qui va apparaitre en haut a gauche.

            Vous pouvez cliquer des à présent sur OK
            "
          )
        } else{
          .rs.api.showDialog(
            "Information",
            "Please wait a few moments for the exercise to load in the tutorial tab.

            Once the exercise is loaded, it will be displayed in full screen mode. To exit the exercise, click on the 'stop' button that will appear on the top left.

            You can now click on OK
            "
          )
        }

        dezoom <- function() {
          message("dezoom1")
          if (.rs.api.getJobState(tuto_env$running_tuto$job) != "running") {

          message("dezoom2")
            message(".rs.api.getJobState(tuto_env$running_tuto$job)")

            rstudioapi::executeCommand("layoutEndZoom")
            # rstudioapi::executeCommand("layoutEndZoom")
            # rstudioapi::executeCommand('activateConsole')


            ## premiere aproche
            # if (grepl(file, pattern = "_fr$")) {
            #   .rs.api.showDialog("", "On relance votre session.")
            # } else{
            #   .rs.api.showDialog("", "We restart your session.")
            # }

            # .rs.restartR("rstudioapi::executeCommand('consoleClear')")

            ## second approche
            later::later(function(){rstudioapi::executeCommand('consoleClear')}, 1)
#             later::destroy_loop(tuto_env$loop_tuto)
            stop("fin de loop")
          }
          later::later(dezoom, 2, loop = tuto_env$loop_tuto)
        }
        later::later(dezoom, 2, loop = tuto_env$loop_tuto)

      }
    # } else{
    #   stop("Please use this fct with rstudio")
    # }
  }

tuto_env <- new.env()
