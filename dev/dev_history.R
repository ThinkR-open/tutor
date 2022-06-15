
### Daily Dev ------------------------------------------------------------------

# DO NOT USE this will mess up custom remotes
# attachment::att_amend_desc(
#   # Set vignette dir to tutorials dir to grab packages used there
#   dir.v = "inst/tutorials/",
#   # Use in dev/clean_learnr_folder.R
#   extra.suggests = c("fs")
#   )

# Insted use
devtools::document()

devtools::check()
rcmdcheck::rcmdcheck()

### Setup ----------------------------------------------------------------------

# _CI
usethis::use_github_action_check_standard(
  save_as = "check-standard.yaml"
)


### Documentation --------------------------------------------------------------

# _News
# usethis::use_news_md()

# _Contributing
# usethis::use_tidy_contributing()
# usethis::use_build_ignore("CONTRIBUTING.md")

# _Code of conduct
# usethis::use_code_of_conduct(contact = "antoine@thinkr.fr")
