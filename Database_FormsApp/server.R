source(here("Database_FormsApp", "global.R"))


# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
  

  #table output
  #output$loc <- renderDataTable(location_data())
  
  #reactive region table
  cap_data <- reactive({

  capture %>% 
      filter(year <= input$year[2] & year>= input$year[1],
             location %in% input$location,
             region %in% input$region,
             site %in% input$site) %>% 
      select(location, region, site, input$site_cols, input$visit_cols, input$survey_cols)

  })
  
  
  observe(
    {input$year
      
      updatePickerInput(session, inputId = "location",
                        choices = unique(capture$location[capture$year <= input$year[2] 
                                                          & capture$year>=input$year[1]]))
      })
  
  
  observe(
    {input$location
      
      updatePickerInput(session, inputId = "region",
                        choices = unique(capture$region[capture$year <= input$year[2] 
                                                        & capture$year>=input$year[1]
                                                        & capture$location %in% input$location]))
      })
  
  
  observe(
    {input$region
      
      updatePickerInput(session, inputId = "site",
                        choices = unique(capture$site[capture$year <= input$year[2] 
                                                        & capture$year>=input$year[1]
                                                        & capture$location %in% input$location
                                                        & capture$region %in% input$region]))
      
      })

  output$cap <- renderDataTable(cap_data(), options = list(scrollX = TRUE))

  

})
