source(("global.R"), local = T)
source(("creds.R"), local = T)
# source("db_creds_goog.R", local = T)

# options(gargle_oob_default = TRUE)
# 
# options(
#   gargle_oauth_cache = ".secrets",
#   gargle_oauth_email = TRUE
# )




shinyServer(function(input, output, session) {
  
  result_auth <- secure_server(check_credentials = check_credentials(credentials))
  
  output$res_auth <- renderPrint({
    reactiveValuesToList(result_auth)
  })

  
  ###### Capture Data #########
  #r eactive capture data
  cap_data <- reactive({
    
    cap %>% 
      filter(year <= input$year[2] & year>= input$year[1],
             location %in% input$location,
             region %in% input$region,
             site %in% input$site) %>% 
      left_join(comb_bd, by = c("bd_swab_id")) %>%
      left_join(serdp_amp, by = c("amp_id")) %>% 
      left_join(serdp_muc_mic, by = c("mucosome_id", "microbiome_swab_id")) %>% 
      left_join(serdp_bd_genom, by = c("genetic_id")) %>% 
      select(location, region, site, input$site_cols, input$visit_cols, input$survey_cols, 
             input$capture_cols, input$comb_bd_cols, input$amp_cols, input$muc_mic_cols,
             input$genom_cols)
    
  }) %>% 
    bindCache(input$year, input$location, input$region, input$site, input$site_cols, input$visit_cols,
              input$survey_cols, input$capture_cols, input$comb_bd_cols, input$amp_cols, input$muc_mic_cols,
              input$genom_cols)
  
  # render data selection
  output$cap_table <- DT::renderDataTable(cap_data(), extensions= 'Buttons', rownames = FALSE, 
                                          options = list(scrollX = T, TRUEom = 'Bfrtip',
                                                         buttons = c('copy', 'csv', 'excel', 'pdf', 'print')))
  
  
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
  
  #update site variables of interest
  # observe(
  #   {input$site
  # 
  #     updatePickerInput(session, inputId = "site_cols",
  #                       choices = colnames(cap[cap$year <= input$year[2] 
  #                                              & cap$year>=input$year[1]
  #                                              & cap$location %in% input$location
  #                                              & cap$region %in% input$region]))
  #     })

  
  # clear button
  observeEvent(input$cap_clear,
               {
                 updatePickerInput(session, inputId = "year", selected = c(max(visit$year) - 5, max(visit$year)))
                 updatePickerInput(session, inputId = "location", selected = "")
                 updatePickerInput(session, inputId = "region", selected = "")
                 updatePickerInput(session, inputId = "site_cols", selected = "")
                 updatePickerInput(session, inputId = "visit_cols", selected = "")
                 updatePickerInput(session, inputId = "survey_cols", selected = "")
                 updatePickerInput(session, inputId = "capture_cols", selected = "")
                 updatePickerInput(session, inputId = "comb_bd_cols", selected = "")
                 updatePickerInput(session, inputId = "amp_cols", selected = "")
                 updatePickerInput(session, inputId = "muc_mic_cols", selected = "")
                 updatePickerInput(session, inputId = "genom_cols", selected = "")
                 
               }
  )
  
  
  # Data download
  observeEvent(input$cap_download, {
    
    shinyalert(title = "Pump the breaks!", 
               text = "Did you get approval for data use from the data owners?",
               type = "warning", closeOnClickOutside = T, showCancelButton = T, inputId = "cap_download_btn",
               showConfirmButton = T, confirmButtonText = "Yes", cancelButtonText = "No", 
               animation = "slide-from-top")
  })
  
  observeEvent(input$cap_download_btn,{
    if(input$cap_download_btn == T)
      showModal(modalDialog(downloadButton("cap_dwnld", "Download"), footer = NULL, easyClose = T, size = "s"))
  })
  
  output$cap_dwnld <- downloadHandler(
    filename = function(){"insert_name.csv"},
    
    content = function(file) {
      shiny::withProgress(
        message = paste0("Downloading Capture Data"),
        value = 0,
        {
          shiny::incProgress(3/10)
          Sys.sleep(1)
          shiny::incProgress(9/10)
          write.csv(cap_data(), file, row.names = FALSE)
        }
      )
    }
  )
  
  
  
  ####### End Capture Data ########
  
  ###### VES DATA ########
  
  ves_data <- reactive({
    
    ves %>% 
      filter(year <= input$year_ves[2] & year>= input$year_ves[1],
             location %in% input$location_ves,
             region %in% input$region_ves,
             site %in% input$site_ves) %>% 
      select(location, region, site, input$site_cols_ves, input$visit_cols_ves, input$survey_cols_ves, input$ves_cols)
    
  }) %>% bindCache(input$year_ves, input$location_ves, input$region_ves, input$site_ves, input$site_cols_ves, input$visit_cols_ves,
                   input$survey_cols_ves, input$ves_cols)
  
  
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
  
  # clear button
  observeEvent(input$ves_clear,
               {
                 updatePickerInput(session, inputId = "year_ves", selected = c(max(visit$year) - 5, max(visit$year)))
                 updatePickerInput(session, inputId = "location_ves", selected = "")
                 updatePickerInput(session, inputId = "region_ves", selected = "")
                 updatePickerInput(session, inputId = "site_cols_ves", selected = "")
                 updatePickerInput(session, inputId = "visit_cols_ves", selected = "")
                 updatePickerInput(session, inputId = "survey_cols_ves", selected = "")
                 updatePickerInput(session, inputId = "ves_cols", selected = "")
                 
               }
  )
  
  
  # render data selection
  output$ves_table <- DT::renderDataTable(ves_data(), extensions= 'Buttons', rownames = FALSE, 
                                          options = list(scrollX = T, TRUEom = 'Bfrtip', 
                                                         buttons = c('copy', 'csv', 'excel', 'pdf', 'print')))
  # Data download
  observeEvent(input$ves_download, {
    
    shinyalert(title = "Pump the breaks!", text = "Did you get approval for data use from the data owners?",
               type = "warning", closeOnClickOutside = T, showCancelButton = T, inputId = "ves_download_btn",
               showConfirmButton = T, confirmButtonText = "Yes", cancelButtonText = "No")
  })
  
  observeEvent(input$ves_download_btn,{
    if(input$ves_download_btn == T)
      showModal(modalDialog(downloadButton("ves_dwnld", "download"), footer = NULL, easyClose = T, size = "s"))
  })
  
  output$ves_dwnld <- downloadHandler(
    filename = function(){"insert_name.csv"},
    
    content = function(file) {
      shiny::withProgress(
        message = paste0("Downloading VES Data"),
        value = 0,
        {
          shiny::incProgress(10/10)
          write.csv(ves_data(), file, row.names = FALSE)
        }
      )
    }
  )
  
  
  ######## END VES Data ##########
  
  ######## Aural ################
  
  aural_data <- reactive({
    
    aural %>% 
      filter(year <= input$year_a[2] & year>= input$year_a[1],
             location %in% input$location_a,
             region %in% input$region_a,
             site %in% input$site_a) %>% 
      select(location, region, site, input$site_cols_a, input$visit_cols_a, input$survey_cols_a, input$aural_cols)
    
  }) %>% bindCache(input$year_a, input$location_a, input$region_a, input$site_a, input$site_cols_a, input$visit_cols_a,
                   input$survey_cols_a, input$aural_cols)
  
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
  
  # clear button
  observeEvent(input$aural_clear,
               {
                 updatePickerInput(session, inputId = "year_a", selected = c(max(visit$year) - 5, max(visit$year)))
                 updatePickerInput(session, inputId = "location_a", selected = "")
                 updatePickerInput(session, inputId = "region_a", selected = "")
                 updatePickerInput(session, inputId = "site_cols_a", selected = "")
                 updatePickerInput(session, inputId = "visit_cols_a", selected = "")
                 updatePickerInput(session, inputId = "survey_cols_a", selected = "")
                 updatePickerInput(session, inputId = "aural_cols", selected = "")
                 
               }
  )
  
  
  # render data selection
  output$aural_table <- DT::renderDataTable(aural_data(), extensions= 'Buttons', rownames = FALSE, 
                                            options = list(scrollX = T, TRUEom = 'Bfrtip', 
                                                           buttons = c('copy', 'csv', 'excel', 'pdf', 'print')))
  # Data download
  observeEvent(input$aural_download, {
    
    shinyalert(title = "Pump the breaks!", text = "Did you get approval for data use from the data owners?",
               type = "warning", closeOnClickOutside = T, showCancelButton = T, inputId = "aural_download_btn",
               showConfirmButton = T, confirmButtonText = "Yes", cancelButtonText = "No")
  })
  
  observeEvent(input$aural_download_btn,{
    if(input$aural_download_btn == T)
      showModal(modalDialog(downloadButton("aural_dwnld", "download"), footer = NULL, easyClose = T, size = "s"))
  })
  
  output$aural_dwnld <- downloadHandler(
    filename = function(){"insert_name.csv"},
    
    content = function(file) {
      shiny::withProgress(
        message = paste0("Downloading Aural Data"),
        value = 0,
        {
          shiny::incProgress(10/10)
          write.csv(aural_data(), file, row.names = FALSE)
        }
      )
    }
  )
  
  
  ######## END AURAL##########
  
  ######## HOBO ##########
  
  hobo_data <- reactive({
    
    hobo %>% 
      filter(year <= input$date_hobo[2] & year>= input$date_hobo[1],
             location %in% input$location_hobo,
             region %in% input$region_hobo,
             site %in% input$site_hobo) %>% 
      select(location, region, site, input$hobo_cols)
    
  })%>% bindCache(input$date_hobo, input$location_hobo, input$region_hobo, input$site_hobo, input$site_hobo, input$hobo_cols)
  
  
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
  
  # clear button
  observeEvent(input$hobo_clear,
               {
                 updatePickerInput(session, inputId = "year_hobo", selected = c(max(visit$year) - 3, max(visit$year)))
                 updatePickerInput(session, inputId = "location_hobo", selected = "")
                 updatePickerInput(session, inputId = "region_hobo", selected = "")
                 updatePickerInput(session, inputId = "site_hobo", selected = "")
                 updatePickerInput(session, inputId = "hobo_cols", selected = "")
                 
               }
  )
  
  
  
  # render data selection
  output$hobo_t <- DT::renderDataTable(hobo_data(), extensions= 'Buttons', rownames = FALSE, 
                                       options = list(scrollX = T, TRUEom = 'Bfrtip', 
                                                      buttons = c('copy', 'csv', 'excel', 'pdf', 'print')))
  
  # Data download
  observeEvent(input$hobo_download, {
    
    shinyalert(title = "Pump the breaks!", text = "Did you get approval for data use from the data owners?",
               type = "warning", closeOnClickOutside = T, showCancelButton = T, inputId = "hobo_download_btn",
               showConfirmButton = T, confirmButtonText = "Yes", cancelButtonText = "No")
  })
  
  observeEvent(input$hobo_download_btn,{
    if(input$hobo_download_btn == T)
      showModal(modalDialog(downloadButton("hobo_dwnld", "download"), footer = NULL, easyClose = T, size = "s"))
  })
  
  output$hobo_dwnld <- downloadHandler(
    filename = function(){"insert_name.csv"},
    
    content = function(file) {
      shiny::withProgress(
        message = paste0("Downloading Hobo Sensor Data"),
        value = 0,
        {
          shiny::incProgress(1/10)
          Sys.sleep(1)
          shiny::incProgress(3/10)
          Sys.sleep(2)
          shiny::incProgress(5/10)
          Sys.sleep(2)
          shiny::incProgress(7/10)
          Sys.sleep(2)
          shiny::incProgress(7/10)
          Sys.sleep(1)
          shiny::incProgress(9/10)
          write.csv(hobo_data(), file, row.names = FALSE)
        }
      )
    }
  )
  
  
  # content = function(fname){
  #   removeModal()
  #   write.csv(hobo_data(), fname)
  # }
  
  
  ######## END HOBO ##########
  
  ######## Audio #############
  
  audio_data <- reactive({
    
    audio %>% 
      filter(location %in% input$location_audio, region %in% input$region_audio, site %in% input$site_audio) %>% 
      select(location, region, site, date_of_deployment, input$audio_cols)
    
  }) %>% bindCache(input$location_audio, input$region_audio, input$site_audio, input$audio_cols)
  
  
  # render data selection
  output$audio_t <- DT::renderDataTable(audio_data(), extensions= 'Buttons', rownames = FALSE, 
                                        options = list(scrollX = T, TRUEom = 'Bfrtip', 
                                                       buttons = c('copy', 'csv', 'excel', 'pdf', 'print')))
  
  # Data download
  observeEvent(input$audio_download, {
    
    shinyalert(title = "Pump the breaks!", 
               text = "Did you get approval for data use from the data owners?",
               type = "warning", closeOnClickOutside = T, showCancelButton = T, inputId = "audio_download_btn",
               showConfirmButton = T, confirmButtonText = "Yes", cancelButtonText = "No", 
               animation = "slide-from-top")
  })
  
  observeEvent(input$audio_download_btn,{
    if(input$audio_download_btn == T)
      showModal(modalDialog(downloadButton("audio_dwnld", "Download"), footer = NULL, easyClose = T, size = "s"))
  })
  
  output$audio_dwnld <- downloadHandler(
    filename = function(){"insert_name.csv"},
    
    content = function(file) {
      shiny::withProgress(
        message = paste0("Downloading Audio Data"),
        value = 0,
        {
          shiny::incProgress(3/10)
          Sys.sleep(1)
          shiny::incProgress(9/10)
          write.csv(audio_data(), file, row.names = FALSE)
        }
      )
    }
  )
  
  
  
  # update region options based on location selection
  observe(
    {input$location_audio
      
      updatePickerInput(session, inputId = "region_audio",
                        choices = unique(audio$region[audio$location %in% input$location_audio]))
    })
  
  # update site options based on region selection
  observe(
    {input$region_audio
      
      updatePickerInput(session, inputId = "site_audio",
                        choices = unique(audio$site[audio$location %in% input$location_audio
                                                   & audio$region %in% input$region_audio]))
      
    })
  
  
  # clear button
  observeEvent(input$audio_clear,
               {
                 updatePickerInput(session, inputId = "location_audio", selected = "")
                 updatePickerInput(session, inputId = "region_audio", selected = "")
                 updatePickerInput(session, inputId = "site_audio", selected = "")
                 updatePickerInput(session, inputId = "audio_cols", selected = "")
                 
               })
  
  ############### END Audio ###################
  
track_usage(storage_mode = store_googledrive(path = "https://drive.google.com/drive/folders/1UeEAlxbToJCM3bb-6AW8R-L8m66oIz-M"))

})

