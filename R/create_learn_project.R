create_learn_project <- function(
  name,
  path = ".",
  lang = "fr"
) {
  dir.create(
    path = file.path(path, name),
    recursive = TRUE,
    showWarnings = FALSE
  )

  rprofile <- glue::glue("
 message('learnr start');
 message('please wait (3s)')

 setHook('rstudio.sessionInit', function(newSession) {
   for ( i in 1:10){rstudioapi::documentClose()}
    rstudioapi::navigateToFile(file = 'explications.R')
    later::later(
       function(){rstudioapi::sendToConsole('tutor::*name*()', execute = TRUE)}
    ,3)

    # message('please wait (3s)')
  }, action = 'append')

                         ", .open = "*", .close = "*")

  cat(rprofile, file = file.path(path, name, ".Rprofile"))

  topo <- "# Veuillez patienter le temps que l'exercice se charge.(Une commande automatique va \u00EAtre envoy\u00E9e dans la console)
# Vous devriez voir un pourcentage d'avancement progresser dans votre console,
# Certain lancement peuvent etre long (jusque 30 secondes)
# Si a la fin de la generation un popup s'ouvre, cliquez sur 'try again' pour
# faire apparaitre l'exercice
# N'h\u00E9sitez pas a agrandir le panneau viewer pour etre a l'aise"


  if (lang == "en") {
    topo <- "# Please wait for the exercise to load (an automatic command will be sent to the console)
# You should see a percentage of progress in your console,
# Some launches can be long (up to 30 seconds)
# If at the end of the generation a popup opens, click on 'try again' to
# make the exercise appear
# Don't hesitate to enlarge the viewer panel to be more comfortable"
  }


  cat(topo, file = file.path(path, name, "explications.R"))

  the_yaml <- list(
    Version = 1,
    RestoreWorkspace = FALSE,
    SaveWorkspace = FALSE,
    AlwaysSaveHistory = TRUE,
    EnableCodeIndexing = TRUE,
    UseSpacesForTab = TRUE,
    NumSpacesForTab = 2L,
    Encoding = "UTF-8",
    RnwWeave = "Sweave",
    LaTeX = "pdfLaTeX"
  )
  yaml::write_yaml(
    the_yaml,
    file =
      file.path(
        path,
        name,
        paste0(name, ".Rproj")
      )
  )
}


create_learn_project_all <- function(
  names = tutor:::nice_name(
    tutor:::tous_les_programmes(lang = lang),
    lang = lang
  ),
  path = ".",
  lang = "fr"
) {
  for (n in names) {
    create_learn_project(
      name = n,
      path = path,
      lang = lang
    )
  }
}
