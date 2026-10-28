# dataExplorer

**How does the relationship between income and life expectancy vary across
continents and years?**

dataExplorer is an R package and Shiny app for students exploring global
development. It combines country comparisons, continent summaries, and
historical trends so that users can investigate this question using Gapminder
data from 1952 to 2007.

## Install and launch

Run these commands in R to install the package from GitHub:

```r
install.packages("remotes") # Only needed if remotes is not installed
remotes::install_github("ETC5523-2026/etc5523-assignment-4-min-1303")

library(dataExplorer)
launch_app()
```

The app uses data included in the installed package; it does not download data
when it runs. To open it in your browser explicitly, use
`launch_app(launch.browser = TRUE)`. Stop the running app with the RStudio Stop
button or Escape in the R console.

If you are working in the cloned package project, use `devtools::load_all()`
followed by `launch_app()` to try local changes.

## Explore the question

1. Choose a year to see an income-versus-life-expectancy snapshot. Each point is
   a country; colour and shape identify its continent. The income axis uses a
   logarithmic scale, so equal distances represent equal ratios.
2. Select continents to focus the comparison. The table reports the number of
   countries and the median life expectancy and GDP per capita for each selected
   continent in that year.
3. Use the trend chart to compare changes in median country life expectancy
   across the full period. Its dashed line marks the chosen snapshot year.
4. Clear every continent to see the informative empty-selection message, then
   select a continent to restore the outputs.

For example, compare Asia in 1952 and 2007. Median country life expectancy rises
from about 44.9 to 72.4 years. Inspect the scatter plot to see how much variation
the median hides. This comparison describes an historical change; it does not
establish that income caused it.

The same summaries are available directly in R:

```r
summarise_development(1952, "Asia")
summarise_development(2007, "Asia")
```

## Data, preparation, and limitations

`gapminder_data` contains 1,704 observations: 142 countries observed every five
years from 1952 to 2007. Its six variables are `country`, `continent`, `year`,
`lifeExp` (life expectancy at birth, in years), `pop` (population), and
`gdpPercap` (GDP per capita, adjusted for purchasing power).

The source is Jennifer Bryan's
[gapminder R package](https://jennybc.github.io/gapminder/), version 1.0.1,
which distributes the data under CC0. The package provides an excerpt of
[Gapminder data](https://www.gapminder.org/data/).
dataExplorer's code is licensed under the [MIT licence](LICENSE.md).

The preparation script, `data-raw/gapminder_data.R`, converts
`gapminder::gapminder` to a base R data frame and saves it as packaged data.
To reproduce it, install `gapminder` and `usethis`, open this repository as your
R project, and run:

```r
source("data-raw/gapminder_data.R")
```

Interpret the outputs with these limitations in mind:

- The series ends in 2007 and cannot describe current conditions.
- Continent medians give every country equal weight; they are not population
  averages and do not describe the typical person.
- Country averages hide inequalities within countries, and continent medians
  hide differences between countries.
- Oceania includes only Australia and New Zealand in this dataset.
- An association between GDP per capita and life expectancy is not evidence of
  a causal effect.

## Documentation

The getting-started vignette in `vignettes/getting-started.Rmd` explains
installation, the controls, interpretation, and the reactive path from an input
to a displayed result. Reference help is available with `?launch_app`,
`?summarise_development`, and `?gapminder_data`.

The pkgdown site is prepared for local preview. Its public URL will be added
here after publication has been verified. To build and preview it locally:

```r
pkgdown::build_site()
```

## Development checks

Run from the package project:

```r
devtools::document()
devtools::test()
devtools::check()
```

Tests cover app filtering, use of the exported summary function, empty and
invalid selections, and recovery to a valid selection. Additional tests verify
known summary results and the packaged dataset's structure.

## Generative AI declaration

I used ChatGPT for drafting project planning, debugging errors, and documentation paraphrasing. And I revised all the codes again.
