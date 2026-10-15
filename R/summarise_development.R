#' Summarise Gapminder Development Indicators
#'
#' Calculates development statistics for a selected
#' year and continent using the packaged Gapminder data.
#'
#' @param year Year to analyse. Default is 2007.
#' @param continent Continent to analyse, or "All".
#'
#' @return A data frame containing the number of
#'   countries, median life expectancy, and median
#'   GDP per capita.
#'
#' @export
#'
#' @examples
#' summarise_development(2007, "Asia")
#' summarise_development(2007, "All")

summarise_development <- function(year = 2007,
                                  continent = "All") {

  data <- gapminder_data[
    gapminder_data$year == year, ,
    drop = FALSE
  ]

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
    median_life_exp = median(data$lifeExp),
    median_gdp_per_capita = median(data$gdpPercap)
  )
}
