#' Launch the Gapminder Explorer
#'
#' Opens the bundled Shiny app for exploring income and life expectancy
#' across countries, continents, and years. The app uses the packaged data
#' and does not download data when it runs.
#'
#' @param ... Additional arguments passed to [shiny::runApp()], such as
#'   `launch.browser = TRUE` or `port = 3838`.
#' @return Runs the Shiny application. Normally does not return until the
#'   application is stopped.
#' @export
#' @examples
#' if (interactive()) {
#'   launch_app()
#' }
launch_app <- function(...) {
  app_dir <- system.file("shiny", package = "dataExplorer")
  if (!nzchar(app_dir)) {
    stop("The bundled app could not be found. Reinstall dataExplorer.",
         call. = FALSE)
  }
  shiny::runApp(appDir = app_dir, ...)
}
