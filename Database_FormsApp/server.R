source(here("Database_FormsApp", "global.R"))


shinyServer(function(input, output, session) {
  
###### Capture Data #########
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
  
  

  # Data download
  observeEvent(input$cap_download, {
    
    shinyalert(title = "Pump the breaks!", text = "Did you get approval for data use from the data owners?",
               type = "warning", closeOnClickOutside = T, showCancelButton = T, inputId = "cap_download_btn",
               showConfirmButton = T, confirmButtonText = "Yes", cancelButtonText = "No")
  })
  
  observeEvent(input$cap_download_btn,{
    if(input$cap_download_btn == T)
      showModal(modalDialog(downloadButton("cap_dwnld", "download"), footer = NULL, easyClose = T, size = "s"))
  })
  
  output$cap_dwnld <- downloadHandler(
    filename = function(){"insert_name.csv"},
    content = function(fname){
      removeModal()
      write.csv(cap_data(), fname)
    })
  


####### End Capture Data ########
  
###### VES DATA ########
  
  ves_data <- reactive({
    
    ves %>% 
      filter(year <= input$year_ves[2] & year>= input$year_ves[1],
             location %in% input$location_ves,
             region %in% input$region_ves,
             site %in% input$site_ves) %>% 
      select(location, region, site, input$site_cols_ves, input$visit_cols_ves, input$survey_cols_ves, input$ves_cols)
    
  })
  
  
  # update location options based on year selection
  observe(
    {input$year_ves
      
      updatePickerInput(session, inputId = "location_ves",
                        choices = unique(ves$location[ves$year <= input$year_ves[2] 
                                                      & ves$year>=input$year_ves[1]]))
    })
  
  # update region options based on location selection
  observe(
    {input$location_ves
      
      updatePickerInput(session, inputId = "region_ves",
                        choices = unique(ves$region[ves$year <= input$year_ves[2] 
                                                    & ves$year>=input$year_ves[1]
                                                    & ves$location %in% input$location_ves]))
    })
  
  # update site options based on region selection
  observe(
    {input$region_ves
      
      updatePickerInput(session, inputId = "site_ves",
                        choices = unique(ves$site[ves$year <= input$year_ves[2] 
                                                  & ves$year >= input$year_ves[1]
                                                  & ves$location %in% input$location_ves
                                                  & ves$region %in% input$region_ves]))
      
    })
  
  
  # render data selection
  output$ves_table <- renderDataTable(ves_data(), extensions= 'Buttons', options = list(scrollX = T, TRUEom = 'Bfrtip',
                                                                                        buttons = c('copy', 'csv', 'excel', 
                                                                                                    'pdf', 'print')))
  # option for data download
  output$ves_download <- downloadHandler(
    filename = function(){"insert_name.csv"}, 
    content = function(fname){
      write.csv(ves_data(), fname)
      
    })
  
######## END VES Data ##########
  
######## Aural ################
  
  aural_data <- reactive({
    
    aural %>% 
      filter(year <= input$year_a[2] & year>= input$year_a[1],
             location %in% input$location_a,
             region %in% input$region_a,
             site %in% input$site_a) %>% 
      select(location, region, site, input$site_cols_a, input$visit_cols_a, input$survey_cols_a, input$aural_cols)
    
  })
  
  # update location options based on year selection
  observe(
    {input$year_a
      
      updatePickerInput(session, inputId = "location_a",
                        choices = unique(aural$location[aural$year <= input$year_a[2] 
                                                      & aural$year>=input$year_a[1]]))
    })
  
  # update region options based on location selection
  observe(
    {input$location_a
      
      updatePickerInput(session, inputId = "region_a",
                        choices = unique(aural$region[aural$year <= input$year_a[2] 
                                                    & aural$year>=input$year_a[1]
                                                    & aural$location %in% input$location_a]))
    })
  
  # update site options based on region selection
  observe(
    {input$region_a
      
      updatePickerInput(session, inputId = "site_a",
                        choices = unique(aural$site[aural$year <= input$year_a[2] 
                                                  & aural$year >= input$year_a[1]
                                                  & aural$location %in% input$location_a
                                                  & aural$region %in% input$region_a]))
      
    })
  
  
  # render data selection
  output$aural_table <- renderDataTable(aural_data(), extensions= 'Buttons', options = list(scrollX = T, TRUEom = 'Bfrtip',
                                                                                        buttons = c('copy', 'csv', 'excel', 
                                                                                                    'pdf', 'print')))
  # option for data download
  output$aural_download <- downloadHandler(
    filename = function(){"insert_name.csv"}, 
    content = function(fname){
      write.csv(aural_data(), fname)
      
    })
  



######## END AURAL##########

######## HOBO ##########

hobo_data <- reactive({
  
  hobo %>% 
    filter(year <= input$date_hobo[2] & year>= input$date_hobo[1],
           location %in% input$location_hobo,
           region %in% input$region_hobo,
           site %in% input$site_hobo) %>% 
    select(location, region, site, input$hobo_cols)
  
})
  
  
  # update location options based on year selection
  observe(
    {input$date_hobo
      
      updatePickerInput(session, inputId = "location_hobo",
                        choices = unique(hobo$location[hobo$year <= input$date_hobo[2] 
                                                        & hobo$year>=input$date_hobo[1]]))
    })
  
  # update region options based on location selection
  observe(
    {input$location_hobo
      
      updatePickerInput(session, inputId = "region_hobo",
                        choices = unique(hobo$region[hobo$year <= input$date_hobo[2] 
                                                      & hobo$year>=input$date_hobo[1]
                                                      & hobo$location %in% input$location_hobo]))
    })
  
  # update site options based on region selection
  observe(
    {input$region_hobo
      
      updatePickerInput(session, inputId = "site_hobo",
                        choices = unique(hobo$site[hobo$year <= input$date_hobo[2] 
                                                    & hobo$year >= input$date_hobo[1]
                                                    & hobo$location %in% input$location_hobo
                                                    & hobo$region %in% input$region_hobo]))
      
    })
  


# render data selection
  output$hobo_t <- renderDataTable(hobo_data(), extensions= 'Buttons', options = list(scrollX = T, TRUEom = 'Bfrtip',
                                                                                          buttons = c('copy', 'csv', 'excel',
                                                                                                      'pdf', 'print')))
# option for data download
  output$hobo_download <- downloadHandler(
    filename = function(){"insert_name.csv"},
    content = function(fname){
    write.csv(hobo_data(), fname)

  })
######## END HOBO ##########
    
})

