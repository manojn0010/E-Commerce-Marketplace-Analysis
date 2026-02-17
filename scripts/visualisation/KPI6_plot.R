install.packages(c("DBI", "RMySQL", "dplyr", "ggplot2", "zoo"))
install.packages("shiny")
library(shiny)
library(DBI)
library(RMySQL)
library(dplyr)
library(ggplot2)
library(zoo)

state_growth <- state_growth_by_mnt

state_growth <- state_growth %>%
  mutate(
    mnt = as.Date(as.yearmon(mnt))
  ) %>%
  filter(!is.na(growth_from_prev_mnt))

top5_states <- state_growth %>%
  group_by(state) %>%
  summarise(total_rev = sum(rev)) %>%
  arrange(desc(total_rev)) %>%
  slice(1:5) %>%
  pull(state)

ui <- fluidPage(
  
  titlePanel("KPI 6: Month-over-Month Revenue Growth"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput(
        inputId = "states",
        label = "Select State(s):",
        choices = sort(unique(state_growth$state)),
        selected = top5_states,
        multiple = TRUE
      )
    ),
    
    mainPanel(
      plotOutput("growth_plot")
    )
  )
)

server <- function(input, output) {
  
  filtered_data <- reactive({
    state_growth %>%
      filter(state %in% input$states)
  })
  
  output$growth_plot <- renderPlot({
    
    df <- filtered_data()
    
    ggplot(
      df,
      aes(
        x = mnt,
        y = growth_from_prev_mnt,
        color = state,
        group = state
      )
    ) +
      geom_line() +
      geom_point(size = 1) +
      scale_y_continuous(
        labels = scales::label_number(big.mark = ",")
      ) +
      scale_x_date(
        date_breaks = "3 months",
        date_labels = "%Y-%b"
      ) +
      labs(
        title = "Month-over-Month Revenue Growth",
        x = "Month",
        y = "Revenue Growth"
      ) +
      theme_minimal() +
      theme(axis.text.x = element_text(angle = 45, hjust = 1))
  })
}

shinyApp(ui = ui, server = server)
