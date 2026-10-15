# Data source: gapminder R package
# https://cran.r-project.org/package=gapminder
#
# Prepare the Gapminder dataset for this package.

gapminder_data <- gapminder::gapminder |>
  as.data.frame()

# Save data inside our R package.
usethis::use_data(gapminder_data, overwrite = TRUE)
