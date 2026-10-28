test_that("known historical summaries remain reproducible", {
  asia <- summarise_development(2007, "Asia")
  expect_equal(asia$countries, 33L)
  expect_equal(asia$median_life_exp, 72.396, tolerance = 1e-6)
  expect_equal(asia$median_gdp_per_capita, 4471.061906, tolerance = 1e-6)
  expect_equal(summarise_development(1952, "Asia")$median_life_exp,
               44.869, tolerance = 1e-6)
  expect_equal(summarise_development(2007, "All")$countries, 142L)
  expect_error(summarise_development(2008, "Asia"), "No data available")
})

test_that("packaged data have one record per country and year", {
  expect_equal(dim(gapminder_data), c(1704L, 6L))
  expect_named(gapminder_data,
               c("country", "continent", "year", "lifeExp", "pop", "gdpPercap"))
  expect_equal(anyDuplicated(gapminder_data[c("country", "year")]), 0L)
  expect_false(anyNA(gapminder_data))
  expect_equal(sort(unique(gapminder_data$year)), seq(1952L, 2007L, by = 5L))
})
