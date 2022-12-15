source(here("Database_FormsApp", "global.R"))


shinyServer(function(input, output, session) {
  
  
  #r eactive capture data
  cap_data <- reactive({

  cap %>% 
      filter(year <= input$year[2] & year>= input$year[1],
             location %in% input$location,
             region %in% input$region,
             site %in% input$site) %>% 
      select(location, region, site, input$site_cols, input$visit_cols, input$survey_cols, input$capture_cols)

  })
  
  
  # update location options based on year selection
  observe(
    {input$year
      
      updatePickerInput(session, inputId = "location",
                        choices = unique(cap$location[cap$year <= input$year[2] 
                                                          & cap$year>=input$year[1]]))
      })
  
  # update region options based on location selection
  observe(
    {input$location
      
      updatePickerInput(session, inputId = "region",
                        choices = unique(cap$region[cap$year <= input$year[2] 
                                                        & cap$year>=input$year[1]
                                                        & cap$location %in% input$location]))
      })
  
  # update site options based on region selection
  observe(
    {input$region
      
      updatePickerInput(session, inputId = "site",
                        choices = unique(cap$site[cap$year <= input$year[2] 
                                                        & cap$year>=input$year[1]
                                                        & cap$location %in% input$location
                                                        & cap$region %in% input$region]))
      
      })
  
  
  # render data selection
  output$cap_table <- renderDataTable(cap_data(), extensions= 'Buttons', options = list(scrollX = T, TRUEom = 'Bfrtip',
                                                                                        buttons = c('copy', 'csv', 'excel', 
                                                                                                    'pdf', 'print')))
  # option for data download
  output$download <- downloadHandler(
    filename = function(){"insert_name.csv"}, 
    content = function(fname){
      write.csv(cap_data(), fname)
    
      })

  

})
