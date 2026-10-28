test_that("the installed app is bundled with the package", {
  expect_true(file.exists(system.file("shiny", "app.R", package = "dataExplorer")))
})

test_that("filters update country data and use the exported summary", {
  app <- new.env(parent = globalenv())
  sys.source(system.file("shiny", "app.R", package = "dataExplorer"), envir = app)
  shiny::testServer(app$server, {
    session$setInputs(year = "2007", continents = "Asia")
    expect_equal(nrow(snapshot()), 33L)
    expect_true(all(snapshot()$year == 2007))
    expect_equal(development_summary(), summarise_development(2007, "Asia"))

    session$setInputs(year = "1952", continents = c("Europe", "Oceania"))
    expect_equal(nrow(snapshot()), 32L)
    expect_true(all(snapshot()$year == 1952))
    expect_setequal(development_summary()$continent, c("Europe", "Oceania"))
    expect_match(output$coverage, "Australia and New Zealand")

    session$setInputs(continents = character(0))
    expect_error(snapshot(), "Select at least one continent")
    expect_error(development_summary(), "Select at least one continent")

    session$setInputs(continents = "Asia", year = "2008")
    expect_error(snapshot(), "Choose an available year")

    session$setInputs(year = "2007")
    expect_equal(nrow(snapshot()), 33L)
  })
})
