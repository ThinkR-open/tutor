#' @importFrom  magrittr %>%
#' @import stringr
#' @import purrr
get_header <- function(file) {
  suppressWarnings(
    base <- readLines(file) # on ouvre le fihcier ligne a ligne
  )
  pos <- base %>%
    str_detect("---") %>%
    which() # on detecte les balise d'ouverture et fermeture

  if (length(pos) >= 2) {
    return(base[pos[1]:pos[2]])
  } # on retourne le header

  return("")
}

is_shiny_prerendered <- function(
  header,
  balise = "runtime:shiny_prerendered"
) {
  res <- header %>%
    map_chr(~ str_remove_all(.x, "\\s")) %>%
    str_detect(balise) %>%
    sum()
  res >= 1
}

tous_les_programmes <- function(lang = "fr") {
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
#' @param light light mode, boolean. if TRUE it goes direct to the point
#'
#' @export
#' @importFrom progress progress_bar
#' @importFrom httpuv randomPort startServer
launch_learn <- function(
  file = sample(tous_les_programmes(), 1),
  zoom = TRUE,
  auto_kill_delay = 60 * 60 * 4,
  light = TRUE
) {


  if (light){
    out <- .rs.tutorial.runTutorial(
      file,
      package = "tutor"
    )
   if (zoom){
     rstudioapi::executeCommand("layoutZoomTutorial")
   }
    return(invisible(out))
  }



  message(file)

  if (!is.null(tuto_env$running_tuto)) {

    message("tuto_env$running_tuto existe deja, on efface tout avant de recommencer")

    .rs.api.stopJob(tuto_env$running_tuto$job)
    try(later::destroy_loop(tuto_env$loop_tuto))
    message("on patiente 2 sec")
    Sys.sleep(2)
  }
  choosen_port <- httpuv::randomPort()
  url_cible <- paste0("http://127.0.0.1:", choosen_port)


  message("on lance ",file, " sur ",choosen_port)
  message("URL cible ", url_cible)
  # message("URL cible exist ", RCurl::url.exists(url_cible))
  .rs.tutorial.runTutorial(
    file,
    package = "tutor",
    shiny_args = list(port = choosen_port)
  )

  tuto_env$running_tuto <- .rs.tutorial.registryGet(file, package = "tutor")

  message("on capture ",tuto_env$running_tuto$job )



  later::later(
    function() {
      message("tutorial killing")
      .rs.api.stopJob(tuto_env$running_tuto$job)
    },
    delay = auto_kill_delay
  )


  if (zoom) {

    message("zoom demande ")

    tuto_env$loop_tuto <- later::create_loop()

    if (
      grepl(
        file,
        pattern = "_fr$"
      )) {
      .rs.api.showDialog(
        "Information",
        "Veuillez patienter quelques instants le temps que l'exercice se charge dans l'onglet tutorial.

            Une fois charg\u00e9 l'exercice se mettra en Plein \u00e9cran, Pour le quitter cliquez sur le bouton rouge 'stop' qui va apparaitre en haut \u00e0 gauche.

            Vous pouvez cliquer des \u00e0 pr\u00e9sent sur OK
            "
      )
    } else {
      .rs.api.showDialog(
        "Information",
        "Please wait a few moments for the exercise to load in the tutorial tab.

            Once the exercise is loaded, it will be displayed in full screen mode. To exit the exercise, click on the red 'stop' button that will appear on the top left.

            You can now click on OK
            "
      )
    }
message("init des flag du while")
    flag <- 0
    flag2 <- 0
    seuil <- 50
    pb <- progress_bar$new(total = seuil)

    while (
      is.null(tuto_env$running_tuto$shiny_url) & flag < seuil) {
      message("dans le while")
      if (
        .rs.api.getJobState(tuto_env$running_tuto$job) %in% c("failed", "cancelled")
      ) {
        message("")
        message("failed ou cancelled detecte avec flag2 ", flag2, "et flag ",flag)
        message("shiny_url ", tuto_env$running_tuto$shiny_url)
        message("browser_url ", tuto_env$running_tuto$browser_url)
        message("running_tuto$job ", .rs.api.getJobState(tuto_env$running_tuto$job))
        # message("URL cible exist ", RCurl::url.exists(url_cible))
        if (flag2 > 3) {

          message("flag2 > 3")

          if (port_busy(choosen_port)) {
            message("port_busy")
            # message("URL cible exist ", RCurl::url.exists(url_cible))
            meta <- list(
              shiny_url = structure(
                paste0("http://127.0.0.1:", choosen_port),
                class = "rs.scalar"
              ),
              job = structure(
                tuto_env$running_tuto$job,
                class = "rs.scalar"
              ),
              package = structure(
                "tutor",
                class = "rs.scalar"
              ),
              name = structure(
                file,
                class = "rs.scalar"
              )
            )
            message(".rs.invokeShinyTutorialViewer")
            message(url_cible)
            .rs.invokeShinyTutorialViewer(
              url_cible,
              meta = meta
            )
            Sys.sleep(2)
          }
          message("on break le while")
          break
        }
        message("on incremente flag2")
        flag2 <- flag2 + 1
      }
      message("shiny_url ", tuto_env$running_tuto$shiny_url)
      message("browser_url ", tuto_env$running_tuto$browser_url)
      message("running_tuto$job ", .rs.api.getJobState(tuto_env$running_tuto$job))
      # message("URL cible exist ", RCurl::url.exists(url_cible))
      pb$tick()
      message("on attend 2sec")
      Sys.sleep(2)
      message("on incremente flag")
      flag <- flag + 1
    }
    message("on sort de while")



    message("shiny_url ", tuto_env$running_tuto$shiny_url)
    message("browser_url ", tuto_env$running_tuto$browser_url)
    message("running_tuto$job ", .rs.api.getJobState(tuto_env$running_tuto$job))
    # message("URL cible exist ", RCurl::url.exists(url_cible))

    rstudioapi::executeCommand("layoutZoomTutorial")

    dezoom <- function() {
      if (.rs.api.getJobState(tuto_env$running_tuto$job) != "running") {
        rstudioapi::executeCommand("layoutEndZoom")
        rstudioapi::executeCommand("activateConsole")

        later::later(
          function() {
            later::destroy_loop(tuto_env$loop_tuto)
          },
          delay = 1,
          loop = later::global_loop()
        )
      }
      later::later(
        dezoom,
        1,
        loop = tuto_env$loop_tuto
      )
    }
    later::later(
      dezoom,
      1,
      loop = tuto_env$loop_tuto
    )
  }
}

tuto_env <- new.env()

port_busy <- function(
  port,
  host = "127.0.0.1"
) {
  s <- NULL
  tryCatch(
    s <- startServer(
      host,
      port,
      list(),
      quiet = TRUE
    ),
    error = function(e) {
    }
  )
  is.null(s)
}
