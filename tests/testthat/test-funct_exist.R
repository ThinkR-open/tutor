test_that("all func exists", {

  need_to_exist <- c("bar_charts_en", "bar_charts_fr", "boxplots_en", "boxplots_fr",
             "customize_en", "customize_fr", "deriving_en", "deriving_fr",
             "exploratory_data_analysis_en", "exploratory_data_analysis_fr",
             "histograms_en", "histograms_fr", "isolating_en", "isolating_fr",
             "join_datasets_en", "join_datasets_fr", "launch_learn", "line_graphs_en",
             "line_graphs_fr", "overplotting_en", "overplotting_fr", "programming_basics_en",
             "programming_basics_fr", "reshape_data_en", "reshape_data_fr",
             "scatterplots_en", "scatterplots_fr", "separate_columns_en",
             "separate_columns_fr", "tibbles_en", "tibbles_fr", "vis_basics_en",
             "vis_basics_fr")

  exist <-ls("package:tutor")


  expect_true(all(need_to_exist %in% exist))

  })
