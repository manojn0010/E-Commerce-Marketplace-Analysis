library(shiny)
library(DBI)
library(RMySQL)
library(dplyr)
library(ggplot2)

kpi4_data <- top_states_by_category
str(kpi4_data)

ui1 <- fluidPage(
  
  titlePanel("KPI 4: Top States by Product Category Rating"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput(
        inputId = "category",
        label = "Select Product Category:",
        choices = sort(unique(kpi4_data$p_category)),
        selected = sort(unique(kpi4_data$p_category))[1]
      )
    ),
    
    mainPanel(
      plotOutput("kpi4_plot")
    )
  )
)

server1 <- function(input, output) {
  
  filtered_data <- reactive({
    
    kpi4_data %>%
      filter(p_category == input$category) %>%
      arrange(desc(avg_rating))
    
  })
  
  output$kpi4_plot <- renderPlot({
    
    df <- filtered_data()
    
    ggplot(
      df,
      aes(
        x = reorder(s_state, avg_rating),
        y = avg_rating
      )
    ) +
      geom_col(fill = "black") +
      geom_text(
        aes(label = paste0("Items: ", item_count)),
        hjust = -0.1,
        size = 3
      ) +
      coord_flip() +
      labs(
        title = paste("Top 3 States by Rating —", input$category),
        x = "State",
        y = "Average Rating"
      ) +
      ylim(0, 5) +
      theme_minimal()
  })
}

shinyApp(ui = ui1, server = server1)
