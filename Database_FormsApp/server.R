source(here("Database_FormsApp", "global.R"))


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  

  #table output
  #output$loc <- renderDataTable(location_data())
  
  #reactive region table
  data <- reactive({

  location %>%
      left_join(region, by = c("location_id")) %>%
      left_join(site, by = c("region_id")) %>%
      left_join(visit, by = c("site_id")) %>%
      filter(year <= input$year[2] & year>= input$year[2],
             location %in% input$location,
             region %in% input$region,
             site %in% input$site) %>% 
      select(location, region, input$site_cols, input$visit_cols)

  })

  output$loc <- renderDataTable(data(), options = list(scrollX = TRUE))
  
  

})
