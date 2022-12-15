source(here("Database_FormsApp", "global.R"))


# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
  

  #table output
  #output$loc <- renderDataTable(location_data())
  
  #reactive region table
  cap_data <- reactive({

  cap %>% 
      filter(year <= input$year[2] & year>= input$year[1],
             location %in% input$location,
             region %in% input$region,
             site %in% input$site) %>% 
      select(location, region, site, input$site_cols, input$visit_cols, input$survey_cols, input$capture_cols)

  })
  
  
  observe(
    {input$year
      
      updatePickerInput(session, inputId = "location",
                        choices = unique(cap$location[cap$year <= input$year[2] 
                                                          & cap$year>=input$year[1]]))
      })
  
  
  observe(
    {input$location
      
      updatePickerInput(session, inputId = "region",
                        choices = unique(cap$region[cap$year <= input$year[2] 
                                                        & cap$year>=input$year[1]
                                                        & cap$location %in% input$location]))
      })
  
  
  observe(
    {input$region
      
      updatePickerInput(session, inputId = "site",
                        choices = unique(cap$site[cap$year <= input$year[2] 
                                                        & cap$year>=input$year[1]
                                                        & cap$location %in% input$location
                                                        & cap$region %in% input$region]))
      
      })
  
  
  observe(
    {input$region
      
      updatePickerInput(session, inputId = "site_cols",
                        choices = unique(cap$site[cap$year <= input$year[2] 
                                                      & cap$year>=input$year[1]
                                                      & cap$location %in% input$location
                                                      & cap$region %in% input$region]))
      
    })

  output$cap_table <- renderDataTable(cap_data(), options = list(scrollX = TRUE))

  

})
