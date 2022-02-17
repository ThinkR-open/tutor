# expect_running <- function(
#   sleep,
#   R_path = NULL
# ) {
#   check_is_installed("testthat")
#   testthat::skip_if_not_installed("pkgload")
#   testthat::skip_if_not_installed("processx")
#   # testthat::skip_on_cran()
#
#   # Ok for now we'll get back to this
#   testthat::skip_if_not(interactive())
#
#
#   # Oh boy using testthat and processx is a mess
#   #
#   # We want to launch the app in a background process,
#   # but we don't have access to the same stuff depending on
#   # where we call the tests
#   #
#   # + We can launch with pkgload::load_all(), but __only__ if the
#   #   current wd is the same as the golem wd
#   # + We can launch with library(lib = ) but __only__ if we are in the
#   #   non interactive testthat environment, __where the current package
#   #   has been installed in a temporary library__
#   #
#   # There are six ways to call tests:
#   #
#   # - (1) Running the test interactively (i.e cmd A + cmd Enter):
#   #   + We're in interactive mode
#   #   + We're not in testthat so no Sys.getenv("TESTTHAT_PKG")
#   #   + The libPath is the default one
#   #   + the wd is the golem path
#   #   + We can use pkgload::load_all()
#   #
#   # - (2) Running the test inside the console, with devtools::test()
#   #   + We're in interactive mode
#   #   + We're in testthat so there is a Sys.getenv("TESTTHAT_PKG" )
#   #   + The libPath is the default one
#   #   + the wd is the golem path
#   #   + We can use pkgload::load_all()
#   #
#   # - (3) Running the test inside the console, with devtools::check()
#   #   + We're not interactive mode
#   #   + We're in testthat so there is a Sys.getenv("TESTTHAT_PKG" )
#   #   + the wd is a temp dir
#   #   + The libPath is a temp one
#   #   + We can't use pkgload
#   #   + We can library()
#   #
#   # - (4) Clicking on the "Run Tests" button on test file File
#   #   + We're not in interactive mode
#   #   + We're not in testthat so there is a Sys.getenv("TESTTHAT_PKG" )
#   #   + the wd is the golem path
#   #   + We can use pkgload
#   #
#   # - (5) Clicking on the "Test" button in RStudio Build Pane
#   #   + We're not in interactive mode
#   #   + We're not in testthat so no Sys.getenv("TESTTHAT_PKG" )
#   #   + the wd is the golem path
#   #   + We can use pkgload
#   #   This one is actually the tricky one: we need to detect that we
#   #   are in testthat but non interactively, and inside the golem wd.
#   #
#   # - (6) Clicking on the "Check" button in RStudio Build Pane
#   #   + We're not interactive mode
#   #   + We're in testthat so there is a Sys.getenv("TESTTHAT_PKG" )
#   #   + the wd is a temp dir
#   #   + The libPath is a temp one
#   #   + We can't use pkgload
#   #   + We can library()
#   #
#   #   So two sum up, two times where we can do library(): is when
#   #   we're not in an child process launched
#
#   if (Sys.getenv("CALLR_CHILD_R_LIBS_USER") == "") {
#     pkg_name <- pkgload::pkg_name()
#     # We are not in RCMDCHECK
#     go_for_pkgload <- TRUE
#   } else {
#     pkg_name <- Sys.getenv("TESTTHAT_PKG")
#     go_for_pkgload <- FALSE
#   }
#
#   if (is.null(R_path)) {
#     if (tolower(.Platform$OS.type) == "windows") {
#       r_ <- normalizePath(file.path(Sys.getenv("R_HOME"), "bin", "R.exe"))
#     } else {
#       r_ <- normalizePath(file.path(Sys.getenv("R_HOME"), "bin", "R"))
#     }
#   } else {
#     r_ <- R_path
#   }
#
#   if (go_for_pkgload) {
#     # Using pkgload because we can
#     rmdproc <- processx::process$new(
#       command = r_,
#       c(
#         "-e",
#         "pkgload::load_all(here::here());rmd_run()"
#       )
#     )
#   } else {
#     # Using the temps libPaths because we can
#     rmdproc <- processx::process$new(
#       echo_cmd = TRUE,
#       command = r_,
#       c(
#         "-e",
#         sprintf("library(%s, lib = '%s');rmd_run()", pkg_name, .libPaths())
#       ),
#       stdout = "|",
#       stderr = "|"
#     )
#   }
#
#   Sys.sleep(sleep)
#   testthat::expect_true(rmdproc$is_alive())
#   rmdproc$kill()
# }
# check_is_installed <- function(
#   pak,
#   ...
# ) {
#   if (
#     !requireNamespace(pak, ..., quietly = TRUE)
#   ) {
#     stop(
#       sprintf(
#         "The {%s} package is required to run this function.\nYou can install it with `install.packages('%s')`.",
#         pak,
#         pak
#       ),
#       call. = FALSE
#     )
#   }
# }
