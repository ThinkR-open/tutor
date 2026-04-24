test_that("launch_learn errors when file doesn't exist (#8)", {
  expect_error(
    tutor::launch_learn(file = "/no/such/file/tutorial.Rmd"),
    regexp = "does not exist"
  )
})
