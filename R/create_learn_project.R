# tous <- tutor:::tous_les_programmes()
# tutor:::nice_name(tutor:::tous_les_programmes())

create_learn_project <- function(name,path="."){
dir.create(path = file.path(path,name),recursive = TRUE,showWarnings = FALSE)

 rprofile <-  glue::glue("
 message('Bonjour');

 setHook('rstudio.sessionInit', function(newSession) {
   for ( i in 1:10){rstudioapi::documentClose()}
    rstudioapi::navigateToFile(file = 'explications.R')
    rstudioapi::sendToConsole('tutor::*name*()', execute = TRUE)
    message('done')
  }, action = 'append')

                         ",.open="*",.close="*")

cat(rprofile,file = file.path(path,name,".Rprofile"))

topo <- "# Veuillez patienter le temps que l'exercice se charge.(Une commande automatique va être envoyée dans la console)
# Vous devriez voir un pourcentage d'avancement progresser dans votre console,
# Certain lancement peuvent etre long (jusque 30 secondes)
# Si a la fin de la generation un popup s'ouvre, cliquez sur 'try again' pour
# faire apparaitre l'exercice
# N'hésitez pas a agrandir le panneau viewer pour etre a l'aise"

cat(topo,file = file.path(path,name,"explications.R"))

the_yaml <- list(
  Version = 1,
  RestoreWorkspace = FALSE,
  SaveWorkspace = FALSE,
  AlwaysSaveHistory = TRUE,
  EnableCodeIndexing = TRUE,
  UseSpacesForTab = TRUE, NumSpacesForTab = 2L, Encoding = "UTF-8",
  RnwWeave = "Sweave", LaTeX = "pdfLaTeX"
)
yaml::write_yaml(the_yaml, file =
                   file.path(path,name,paste0(name, ".Rproj"))             )
 }


create_learn_project_all <- function(names = tutor:::nice_name(tutor:::tous_les_programmes()),path="."){
  for ( n in names){
  create_learn_project(name = n,path=path)
  }
}
