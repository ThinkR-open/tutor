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
#' @param auto_kill_delay delay in secon to kill jobs
#'
#' @export
#' @importFrom progress progress_bar
launch_learn <- function(file = sample(tous_les_programmes(), 1),
                         zoom = TRUE,auto_kill_delay = 60*60*4) {
  message(file)


  if (!is.null(tuto_env$running_tuto)) {
    .rs.api.stopJob(tuto_env$running_tuto$job)
    try(later::destroy_loop(tuto_env$loop_tuto))
    Sys.sleep(2)
  }
  .rs.tutorial.runTutorial(file, package = "tutor")

  tuto_env$running_tuto <- .rs.tutorial.registryGet(file, package = "tutor")


  later::later(
    function(){
      message("tutorial killing")
      .rs.api.stopJob(tuto_env$running_tuto$job)},delay = auto_kill_delay
    )


  if (zoom) {
    tuto_env$loop_tuto <- later::create_loop()


    # rstudioapi::executeCommand("layoutZoomTutorial")

    if (grepl(file, pattern = "_fr$")) {
      .rs.api.showDialog(
        "Information",
        "Veuillez patienter quelques instants le temps que l'exercice se charge dans l'onglet tutorial.

            Une fois charg\u00e9 l'exercice se mettra en Plein \u00e9cran, Pour le quitter cliquez sur le bouton 'stop' qui va apparaitre en haut \u00e0 gauche.

            Vous pouvez cliquer des \u00e0 pr\u00e9sent sur OK
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



flag <- 0
seuil <- 50
pb <- progress_bar$new(total = seuil)

    while ( is.null(tuto_env$running_tuto$browser_url) & flag < seuil ) {

      if ( .rs.api.getJobState(tuto_env$running_tuto$job) %in% c("failed","cancelled")){

        message(.rs.api.getJobState(tuto_env$running_tuto$job))

        break
      }
      # print(.rs.api.getJobState(tuto_env$running_tuto$job))
      # print(tuto_env$running_tuto$browser_url)
      pb$tick()
      Sys.sleep(2)
      flag <- flag + 1
    }
message("on sort")

    rstudioapi::executeCommand("layoutZoomTutorial")

    dezoom <- function() {
      if ( .rs.api.getJobState(tuto_env$running_tuto$job) != "running" ) {
        rstudioapi::executeCommand("layoutEndZoom")
        rstudioapi::executeCommand('activateConsole')
        # rstudioapi::executeCommand('consoleClear')

        # later::later(~ rstudioapi::executeCommand('consoleClear'), delay = 2, loop = later::global_loop())

        later::later(
          function(){later::destroy_loop(tuto_env$loop_tuto)},
          delay = 1,
          loop = later::global_loop())

        # later::later(~ rstudioapi::executeCommand('consoleClear'), delay = 2)
      }


      later::later(dezoom, 1, loop = tuto_env$loop_tuto)
    }
    later::later(dezoom, 1, loop = tuto_env$loop_tuto)
  }
}

tuto_env <- new.env()
