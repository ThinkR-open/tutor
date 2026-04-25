test_that("launch_learn errors when path-like file doesn't exist (#8)", {
  # When `file` looks like a path (contains a separator or ends in .Rmd),
  # we want a readable error before falling through to RStudio internals.
  expect_error(
    tutor::launch_learn(file = "/no/such/file/tutorial.Rmd"),
    regexp = "does not exist"
  )
  expect_error(
    tutor::launch_learn(file = "tutorial.Rmd"),
    regexp = "does not exist"
  )
})

test_that("launch_learn errors with available list when name is unknown (#8)", {
  # When `file` is a bare name, it must be present in tous_les_programmes()
  # — it is passed to .rs.tutorial.runTutorial(name, package = 'tutor'),
  # so file.exists() on the cwd would be wrong.
  expect_error(
    tutor::launch_learn(file = "definitely_not_a_tutorial_name"),
    regexp = "not found"
  )
})
