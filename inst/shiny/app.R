library(shiny)

# All observations come from the installed package.
gapminder <- dataExplorer::gapminder_data
continents <- sort(unique(as.character(gapminder$continent)))
years <- sort(unique(gapminder$year))
continent_colours <- c(
  Africa = "#A64900", Americas = "#00779E", Asia = "#8A508F",
  Europe = "#28744A", Oceania = "#525D76"
)
continent_shapes <- c(Africa = 16, Americas = 17, Asia = 15,
                      Europe = 18, Oceania = 8)

ui <- fluidPage(
  tags$head(tags$style(HTML("
    body { background: #f3f6f8; color: #203244; font-size: 16px; }
    .container-fluid { max-width: 1280px; padding: 24px; }
    h1, h2, h3 { color: #123c52; font-weight: 600; }
    h1 { font-size: 32px; } h2 { font-size: 24px; }
    .well { background: #e8f0f4; border: 1px solid #c9d9e2; }
    .panel-content { background: white; padding: 20px; border-radius: 8px;
                     margin-bottom: 20px; border: 1px solid #d8e2e8; }
    .hint { color: #43586a; line-height: 1.6; }
    .shiny-output-error-validation { color: #8b3510; padding: 16px;
                                     font-weight: 600; }
    a { color: #00648a; } .checkbox { margin-bottom: 12px; }
  "))),
  titlePanel("Gapminder Explorer"),
  p("For students exploring global development."),
  h2("How does the relationship between income and life expectancy vary across continents and years?"),
  sidebarLayout(
    sidebarPanel(
      selectInput("year", "Choose a year", choices = years, selected = 2007),
      checkboxGroupInput("continents", "Compare continents",
                         choices = continents, selected = continents),
      p(class = "hint", "Change the year to compare historical snapshots. Select continents to focus the comparison. The trend chart keeps the full time period for context."),
      hr(),
      h3("Reading the fields"),
      p(class = "hint", "Life expectancy is expected years of life at birth. GDP per capita is economic output per person, adjusted for purchasing power; it is not a person's salary."),
      p(class = "hint", "The data cover 142 countries, every five years from 1952 to 2007. They do not describe current conditions."),
      a("Data source: Gapminder R package",
        href = "https://jennybc.github.io/gapminder/", target = "_blank")
    ),
    mainPanel(
      div(class = "panel-content",
        h2(textOutput("snapshot_title", inline = TRUE)),
        plotOutput("comparison", height = "360px"),
        plotOutput("comparison_legend", height = "70px"),
        p(class = "hint", "Each point is one country. Colour and shape identify its continent. Further right means higher GDP per capita; higher up means longer life expectancy. The income axis is logarithmic: equal distances represent equal ratios."),
        textOutput("coverage")
      ),
      div(class = "panel-content",
        h2("Typical country in each continent"),
        tableOutput("summary"),
        p(class = "hint", "Medians give every country equal weight, regardless of population. They describe the typical country, not the typical person, and can hide large differences within a continent.")
      ),
      div(class = "panel-content",
        h2("How life expectancy changed"),
        plotOutput("trend", height = "320px"),
        plotOutput("trend_legend", height = "70px"),
        p(class = "hint", "Lines show the median country life expectancy within each selected continent. The dashed vertical line marks your chosen year. Compare the trajectories, then use the snapshot to inspect variation between countries."),
        p(class = "hint", "An association between income and life expectancy does not show that income caused the difference. These historical country averages also hide inequalities within countries.")
      )
    )
  )
)

server <- function(input, output, session) {
  selected_continents <- reactive({
    validate(need(length(input$continents) > 0,
                  "Select at least one continent to explore the data."))
    validate(need(all(input$continents %in% continents),
                  "Choose a continent from the available options."))
    input$continents
  })

  selected_year <- reactive({
    value <- suppressWarnings(as.numeric(input$year))
    validate(need(length(value) == 1 && !is.na(value) && value %in% years,
                  "Choose an available year between 1952 and 2007."))
    value
  })

  # Input -> reactive filtered data -> plot and explanatory text.
  snapshot <- reactive({
    gapminder[gapminder$year == selected_year() &
                gapminder$continent %in% selected_continents(), , drop = FALSE]
  })

  # Use the package's meaningful exported function in the app.
  development_summary <- reactive({
    do.call(rbind, lapply(selected_continents(), function(continent) {
      dataExplorer::summarise_development(selected_year(), continent)
    }))
  })

  # Keep identical legends in their own rows, outside both data panels.
  continent_legend <- function() {
    renderPlot({
      req(length(input$continents) > 0)
      chosen <- selected_continents()
      par(mar = c(0, 0, 0, 0))
      plot.new()
      legend("center", legend = chosen, col = continent_colours[chosen],
             pch = continent_shapes[chosen], bty = "n",
             ncol = min(3, length(chosen)), cex = 0.9)
    }, res = 96)
  }
  output$comparison_legend <- continent_legend()
  output$trend_legend <- continent_legend()

  output$snapshot_title <- renderText(paste("Income and life expectancy in", selected_year()))
  output$comparison <- renderPlot({
    d <- snapshot()
    group <- as.character(d$continent)
    par(mar = c(4.5, 4.5, 1, 1))
    plot(d$gdpPercap, d$lifeExp, log = "x",
         xlim = range(gapminder$gdpPercap), ylim = c(20, 85),
         col = continent_colours[group], pch = continent_shapes[group],
         cex = 1.1, xlab = "GDP per capita (purchasing-power adjusted; log scale)",
         ylab = "Life expectancy at birth (years)")
  }, res = 96)

  output$coverage <- renderText({
    d <- snapshot()
    note <- if ("Oceania" %in% selected_continents()) {
      " Oceania contains only Australia and New Zealand in this dataset; do not generalise it to the whole region."
    } else ""
    paste0(nrow(d), " countries shown. Axes stay fixed across selections to support comparison.", note)
  })

  output$summary <- renderTable({
    d <- development_summary()
    data.frame(
      Continent = d$continent, Countries = d$countries,
      `Median life expectancy (years)` = round(d$median_life_exp, 1),
      `Median GDP per capita` = round(d$median_gdp_per_capita),
      check.names = FALSE
    )
  }, striped = TRUE, bordered = FALSE, spacing = "m", digits = 1)

  output$trend <- renderPlot({
    chosen <- selected_continents()
    year <- selected_year()
    par(mar = c(4.5, 4.5, 1, 1))
    plot(range(years), c(20, 85), type = "n", xlab = "Year",
         ylab = "Median country life expectancy (years)")
    abline(v = year, lty = 2, col = "#687988")
    for (continent in chosen) {
      medians <- vapply(years, function(y) {
        dataExplorer::summarise_development(y, continent)$median_life_exp
      }, numeric(1))
      lines(years, medians, type = "b", lwd = 2,
            col = continent_colours[continent], pch = continent_shapes[continent])
    }
  }, res = 96)
}

shinyApp(ui = ui, server = server)
