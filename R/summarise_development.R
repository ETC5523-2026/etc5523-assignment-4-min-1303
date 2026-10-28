#' Summarise Gapminder Development Indicators
#'
#' Calculates development statistics for a selected year and continent using
#' the packaged Gapminder data. Medians give every country equal weight and
#' are not population-weighted averages.
#'
#' @param year Observation year to analyse, from 1952 to 2007 in five-year
#'   intervals. Default is 2007.
#' @param continent Continent to analyse ("Africa", "Americas", "Asia",
#'   "Europe", or "Oceania"), or "All" for all countries.
#'
#' @return A one-row data frame with columns `year`, `continent`, `countries`
#'   (number of distinct countries), `median_life_exp` (years), and
#'   `median_gdp_per_capita` (in the source data's purchasing-power-adjusted
#'   units). Throws an error when the selection contains no observations.
#'
#' @export
#' @examples
#' summarise_development(2007, "Asia")
#' summarise_development(2007, "All")
summarise_development <- function(year = 2007, continent = "All") {
  data <- dataExplorer::gapminder_data
  data <- data[data$year == year, , drop = FALSE]

  if (continent != "All") {
    data <- data[
      as.character(data$continent) == continent, ,
      drop = FALSE
    ]
  }

  if (nrow(data) == 0) {
    stop("No data available for this selection.")
  }

  data.frame(
    year = year,
    continent = continent,
    countries = length(unique(data$country)),
    median_life_exp = stats::median(data$lifeExp),
    median_gdp_per_capita = stats::median(data$gdpPercap)
  )
}
