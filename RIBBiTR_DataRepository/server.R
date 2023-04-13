source(("global.R"), local = T)
source(("creds.R"), local = T)


shinyServer(function(input, output, session) {
  
  result_auth <- secure_server(check_credentials = check_credentials(credentials))
  
  output$res_auth <- renderPrint({
    reactiveValuesToList(result_auth)
  })

  
  ###### Capture Data #########
  #r eactive capture data
    
  
  cap_data <- reactive({
    
    full_cap_data  %>%
      filter(year <= !!input$year[2] & year >= !!input$year[1],
             location %in% !!input$location,
             region %in% !!input$region,
             site %in% !!input$site) %>%
      select(location, region, site, !!input$site_cols, !!input$bd_temp,
             !!input$amp_cols, !!input$muc_mic_cols, !!input$genom_cols) %>% 
      collect()
      
    
  }) %>%
    bindCache(input$year, input$location, input$region, input$site, input$site_cols, 
              input$bd_temp, input$amp_cols, input$muc_mic_cols,
              input$genom_cols)
      
      
    


  
  # render data selection
  output$cap_table <- DT::renderDataTable(cap_data(), extensions= 'Buttons', rownames = FALSE, 
                                          options = list(scrollX = T, TRUEom = 'Bfrtip',
                                                         buttons = c('copy', 'csv', 'excel', 'pdf', 'print'))) 
  
  
  
  
  # update location options based on year selection
  observeEvent(input$year,
    {
      
      update_cap_locations <- full_cap_data %>% 
        filter(year <= !!input$year[2] & year >= !!input$year[1]) %>% 
        select(location) %>% 
        distinct(location) %>% 
        collect()

      updatePickerInput(session, inputId = "location",
                        choices = unique(update_cap_locations))
    })

  # update region options based on location selection
  observeEvent(input$location,
    {
      
      update_cap_regions <- full_cap_data %>% 
        filter(year <= !!input$year[2] & year >= !!input$year[1],
               location %in% !!input$location) %>% 
        select(region) %>% 
        distinct(region) %>% 
        collect()
      
        

      updatePickerInput(session, inputId = "region",
                        choices = unique(update_cap_regions))
    })

  # update site options based on region selection
  observeEvent(input$region,
    {
      
      update_cap_sites <- full_cap_data %>% 
        filter(year <= !!input$year[2] & year >= !!input$year[1],
               location %in% !!input$location,
               region %in% !!input$region) %>% 
        select(site) %>%
        distinct(site) %>% 
        collect()
      

      updatePickerInput(session, inputId = "site",
                        choices = unique(update_cap_sites))

    })
   
  #update site variables of interest
  observeEvent(input$site,
    {
      
      site_cap_cols_update <- no_pros_cap_data %>% 
        filter(year <= !!input$year[2] & year >= !!input$year[1],
               location %in% !!input$location,
               region %in% !!input$region,
               site %in% !!input$site) %>% 
        collect() %>% 
        janitor::remove_empty(which = "cols") %>% 
        colnames() %>% 
        as.data.frame() %>% 
        rename("Variables" = ".") %>% 
        filter(!Variables == "location" &
                 !Variables == "region" &
                 !Variables == "site" &
                 !Variables == "year")  

      updatePickerInput(session, inputId = "site_cols",
                        choices = site_cap_cols_update)
      })

  
  # clear button
  observeEvent(input$cap_clear,
               {
                 updatePickerInput(session, inputId = "year", selected = c(max(years$year) - 5, max(years$year)))
                 updatePickerInput(session, inputId = "location", selected = "")
                 updatePickerInput(session, inputId = "region", selected = "")
                 updatePickerInput(session, inputId = "site", selected = "")
                 updatePickerInput(session, inputId = "site_cols", selected = "")
                 updatePickerInput(session, inputId = "bd_temp", selected = "")
                 updatePickerInput(session, inputId = "amp_cols", selected = "")
                 updatePickerInput(session, inputId = "muc_mic_cols", selected = "")
                 updatePickerInput(session, inputId = "genom_cols", selected = "")

               }
  )


  # Data download
  observeEvent(input$cap_download, {

    shinyalert(title = "Pump the breaks!",
               text = "Did you get approval for data use from the data owners?",
               type = "input", closeOnClickOutside = T, showCancelButton = T, inputId = "cap_download_btn",
               showConfirmButton = T, confirmButtonText = "Confirm", cancelButtonText = "Cancel",
               animation = "slide-from-top", inputPlaceholder = "enter_username", confirmButtonCol = "#337ab7")

  })

  observeEvent(input$cap_download_btn,{
    if(input$cap_download_btn %in% credentials$user)
      showModal(modalDialog(downloadButton("cap_dwnld", "Download"), footer = NULL, easyClose = T, size = "s"))

    if(!input$cap_download_btn %in% credentials$user)
      shinyalert(title = "Access Denied", type = "warning", confirmButtonCol = "#337ab7")

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

  # Comb bd warning
  observeEvent(input$bd_temp, {
    
    shinyalert(title = "Warning",
               text = "This data contains temporary combined Bd Loads. Contact data owners to confirm qPCR protocols are equivalent before use.",
               type = "warning", closeOnClickOutside = T, showCancelButton = T,
               showConfirmButton = T, confirmButtonText = "Ok", cancelButtonText = "Cancel",
               animation = "slide-from-top")
  })

  ####### End Capture Data ########

  ###### VES DATA ########

  ves_data <- reactive({
    
    full_ves_data %>%
      filter(year <= !!input$year_ves[2] & year >= !!input$year_ves[1],
             location %in% c(!!input$location_ves),
             region %in% c(!!input$region_ves),
             site %in% c(!!input$site_ves)) %>%
      select(location, region, site, !!input$ves_cols) %>%
      collect()
    
    }) %>% bindCache(input$year_ves, input$location_ves, input$region_ves, input$site_ves, input$ves_cols)
  
  
  # update location options based on year selection
  observeEvent(input$year_ves,
    {
      
      update_ves_locations <- full_ves_data %>% 
        filter(year <= !!input$year_ves[2] & year >= !!input$year_ves[1]) %>% 
        select(location) %>% 
        distinct(location) %>% 
        collect()
  
      updatePickerInput(session, inputId = "location_ves",
                        choices = update_ves_locations)
    })
  
  # update region options based on location selection
  observeEvent(input$location_ves,
    {
      
      update_ves_regions <- full_ves_data %>% 
        filter(year <= !!input$year_ves[2] & year >= !!input$year_ves[1],
               location %in% !!input$location_ves) %>% 
        select(region) %>% 
        distinct(region) %>% 
        collect()
      
  
      updatePickerInput(session, inputId = "region_ves",
                        choices = update_ves_regions)
    })
  
  # update site options based on region selection
  observeEvent(input$region_ves,
    {
      
      update_ves_sites <- full_ves_data %>% 
        filter(year <= !!input$year_ves[2] & year >= !!input$year_ves[1],
               location %in% !!input$location_ves,
               region %in% !!input$region_ves) %>% 
        select(site) %>%
        distinct(site) %>% 
        collect()
  
      updatePickerInput(session, inputId = "site_ves",
                        choices = update_ves_sites)
  
    })
  
  observeEvent(input$site_ves,
               {
                 
                 site_ves_cols_update <- full_ves_data %>% 
                   filter(year <= !!input$year_ves[2] & year >= !!input$year_ves[1],
                          location %in% !!input$location_ves,
                          region %in% !!input$region_ves,
                          site %in% !!input$site_ves) %>% 
                   collect() %>% 
                   janitor::remove_empty(which = "cols") %>% 
                   colnames() %>% 
                   as.data.frame() %>% 
                   rename("Variables" = ".") %>% 
                   filter(!Variables == "location" &
                            !Variables == "region" &
                            !Variables == "site" &
                            !Variables == "year")  
                 
                 updatePickerInput(session, inputId = "ves_cols",
                                   choices = site_ves_cols_update)
               })
  
  # clear button
  observeEvent(input$ves_clear,
               {
                 updatePickerInput(session, inputId = "year_ves", selected = c(max(years$year) - 5, max(years$year)))
                 updatePickerInput(session, inputId = "location_ves", selected = "")
                 updatePickerInput(session, inputId = "region_ves", selected = "")
                 updatePickerInput(session, inputId = "site_ves", selected = "")
                 updatePickerInput(session, inputId = "ves_cols", selected = "")
  
               })
  
  
  # render data selection
  output$ves_table <- DT::renderDataTable(ves_data(), extensions= 'Buttons', rownames = FALSE,
                                          options = list(scrollX = T, TRUEom = 'Bfrtip',
                                                         buttons = c('copy', 'csv', 'excel', 'pdf', 'print')))
  # Data download
  observeEvent(input$ves_download, {
  
    shinyalert(title = "Pump the breaks!",
               text = "Did you get approval for data use from the data owners?",
               type = "input", closeOnClickOutside = T, showCancelButton = T, inputId = "ves_download_btn",
               showConfirmButton = T, confirmButtonText = "Confirm", cancelButtonText = "Cancel",
               animation = "slide-from-top", inputPlaceholder = "enter_username")
  })
  
  observeEvent(input$ves_download_btn,{
    if(input$ves_download_btn %in% credentials$user)
      showModal(modalDialog(downloadButton("ves_dwnld", "download"), footer = NULL, easyClose = T, size = "s"))
  
    if(!input$ves_download_btn %in% credentials$user)
      shinyalert(title = "Access Denied", type = "warning", confirmButtonCol = "#337ab7")
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

    full_aural_data %>%
      filter(year <= !!input$year_a[2] & year >= !!input$year_ves[1],
             location %in% c(!!input$location_a),
             region %in% c(!!input$region_a),
             site %in% c(!!input$site_a)) %>%
      select(location, region, site, !!input$aural_cols) %>%
      collect()
    
  }) %>% bindCache(input$year_a, input$location_a, input$region_a, input$site_a, input$aural_cols)

  # update location options based on year selection
  observeEvent(input$year_a,
    {
      
      update_aural_locations <- full_aural_data %>% 
        filter(year <= !!input$year_a[2] & year >= !!input$year_a[1]) %>% 
        select(location) %>% 
        distinct(location) %>% 
        collect()

      updatePickerInput(session, inputId = "location_a",
                        choices = update_aural_locations)
    })

  # update region options based on location selection
  observeEvent(input$location_a,
    {
      
      update_aural_regions <- full_aural_data %>% 
        filter(year <= !!input$year_a[2] & year >= !!input$year_a[1],
               location %in% !!input$location_a) %>% 
        select(region) %>% 
        distinct(region) %>% 
        collect()

      updatePickerInput(session, inputId = "region_a",
                        choices = update_aural_regions)
    })

  # update site options based on region selection
  observeEvent(input$region_a,
    {
      
      update_aural_sites <- full_aural_data %>% 
        filter(year <= !!input$year_a[2] & year >= !!input$year_a[1],
               location %in% !!input$location_a,
               region %in% !!input$region_a) %>% 
        select(site) %>% 
        distinct(site) %>% 
        collect()

      updatePickerInput(session, inputId = "site_a",
                        choices = update_aural_sites)

    })
  
  # update aural col options
  observeEvent(input$site_a,
               {
                 
                 site_aural_cols_update <- full_aural_data %>% 
                   filter(year <= !!input$year_a[2] & year >= !!input$year_a[1],
                          location %in% !!input$location_a,
                          region %in% !!input$region_a,
                          site %in% !!input$site_a) %>% 
                   collect() %>% 
                   janitor::remove_empty(which = "cols") %>% 
                   colnames() %>% 
                   as.data.frame() %>% 
                   rename("Variables" = ".") %>% 
                   filter(!Variables == "location" &
                            !Variables == "region" &
                            !Variables == "site" &
                            !Variables == "year")  
                 
                 updatePickerInput(session, inputId = "aural_cols",
                                   choices = site_aural_cols_update)
               })

  # clear button
  observeEvent(input$aural_clear,
               {
                 updatePickerInput(session, inputId = "year_a", selected = c(max(years$year) - 5, max(years$year)))
                 updatePickerInput(session, inputId = "location_a", selected = "")
                 updatePickerInput(session, inputId = "region_a", selected = "")
                 updatePickerInput(session, inputId = "site_a", selected = "")
                 updatePickerInput(session, inputId = "aural_cols", selected = "")

               }
  )


  # render data selection
  output$aural_table <- DT::renderDataTable(aural_data(), extensions= 'Buttons', rownames = FALSE,
                                            options = list(scrollX = T, TRUEom = 'Bfrtip',
                                                           buttons = c('copy', 'csv', 'excel', 'pdf', 'print')))
  # Data download
  observeEvent(input$aural_download, {

    shinyalert(title = "Pump the breaks!",
               text = "Did you get approval for data use from the data owners?",
               type = "input", closeOnClickOutside = T, showCancelButton = T, inputId = "aural_download_btn",
               showConfirmButton = T, confirmButtonText = "Confirm", cancelButtonText = "Cancel",
               animation = "slide-from-top", inputPlaceholder = "enter_username")
  })

  observeEvent(input$aural_download_btn,{
    if(input$aural_download_btn %in% credentials$user)
      showModal(modalDialog(downloadButton("aural_dwnld", "download"), footer = NULL, easyClose = T, size = "s"))

    if(!input$aural_download_btn %in% credentials$user)
      shinyalert(title = "Access Denied", type = "warning", confirmButtonCol = "#337ab7")
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

    full_hobo_data %>%
      filter(year <= !!input$date_hobo[2] & year>= !!input$date_hobo[1],
             location %in% (!!input$location_hobo),
             region %in% (!!input$region_hobo),
             site %in% c(!!input$site_hobo)) %>%
      select(location, region, site, !!input$hobo_cols) %>% 
      collect()

  })%>% bindCache(input$date_hobo, input$location_hobo, input$region_hobo, input$site_hobo, input$hobo_cols)


  # update location options based on year selection
  observeEvent(input$date_hobo,
    {
      updated_hobo_locations <- full_hobo_data %>% 
        filter(year <= !!input$date_hobo[2] & year>= !!input$date_hobo[1]) %>% 
        select(location) %>% 
        distinct(location) %>% 
        collect()

      updatePickerInput(session, inputId = "location_hobo",
                        choices = updated_hobo_locations$location)
    })

  # update region options based on location selection
  observeEvent(input$location_hobo,
    {
      
      updated_hobo_region <- full_hobo_data %>% 
        filter(year <= !!input$date_hobo[2] & year>= !!input$date_hobo[1],
               location %in% !!c(input$location_hobo)) %>% 
        select(region) %>% 
        distinct(region) %>% 
        collect()

      updatePickerInput(session, inputId = "region_hobo",
                        choices = updated_hobo_region)
    })

  # update site options based on region selection
  observeEvent(input$region_hobo,
    {
      
      updated_hobo_sites <-  full_hobo_data %>% 
        filter(year <= !!input$date_hobo[2] & year>= !!input$date_hobo[1],
               location %in% !!c(input$location_hobo),
               region %in% !!c(input$region_hobo)) %>% 
        select(site) %>% 
        distinct(site) %>% 
        collect()

      updatePickerInput(session, inputId = "site_hobo",
                        choices = updated_hobo_sites)

    })
  
  # update aural col options
  observeEvent(input$site_hobo,
               {
                 
                 site_hobo_cols_update <- full_hobo_data %>% 
                   collect() %>% 
                   colnames() %>% 
                   as.data.frame() %>% 
                   rename("Variables" = ".") %>% 
                   filter(!Variables == "location" &
                            !Variables == "region" &
                            !Variables == "site" &
                            !Variables == "year")  
                 
                 updatePickerInput(session, inputId = "hobo_cols",
                                   choices = site_hobo_cols_update)
               })

  # clear button
  observeEvent(input$hobo_clear,
               {
                 updatePickerInput(session, inputId = "year_hobo", selected = c(max(hobo_years$year) - 3, max(hobo_years$year)))
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

    shinyalert(title = "Pump the breaks!",
               text = "Did you get approval for data use from the data owners?",
               type = "input", closeOnClickOutside = T, showCancelButton = T, inputId = "hobo_download_btn",
               showConfirmButton = T, confirmButtonText = "Confirm", cancelButtonText = "Cancel",
               animation = "slide-from-top", inputPlaceholder = "enter_username")
  })

  observeEvent(input$hobo_download_btn,{
    if(input$hobo_download_btn %in% credentials$user)
      showModal(modalDialog(downloadButton("hobo_dwnld", "download"), footer = NULL, easyClose = T, size = "s"))

    if(!input$hobo_download_btn %in% credentials$user)
      shinyalert(title = "Access Denied", type = "warning", confirmButtonCol = "#337ab7")
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


  ######## END HOBO ##########

  ######## Audio #############

  audio_data <- reactive({

    full_audio_data %>%
      filter(year %in% c(!!input$year_audio),
             location %in% (!!input$location_audio),
             region %in% (!!input$region_audio),
             site %in% c(!!input$site_audio)) %>%
      select(location, region, site, !!input$audio_cols) %>% 
      collect()
  

  }) %>% bindCache(input$location_audio, input$region_audio, input$site_audio, input$audio_cols)


  # render data selection
  output$audio_t <- DT::renderDataTable(audio_data(), extensions= 'Buttons', rownames = FALSE,
                                        options = list(scrollX = T, TRUEom = 'Bfrtip',
                                                       buttons = c('copy', 'csv', 'excel', 'pdf', 'print')))

  # Data download
  observeEvent(input$audio_download, {

    shinyalert(title = "Pump the breaks!",
               text = "Did you get approval for data use from the data owners?",
               type = "input", closeOnClickOutside = T, showCancelButton = T, inputId = "audio_download_btn",
               showConfirmButton = T, confirmButtonText = "Confirm", cancelButtonText = "Cancel",
               animation = "slide-from-top", inputPlaceholder = "enter_username")
  })

  observeEvent(input$audio_download_btn,{
    if(input$audio_download_btn %in% credentials$user)
      showModal(modalDialog(downloadButton("audio_dwnld", "Download"), footer = NULL, easyClose = T, size = "s"))

    if(!input$audio_download_btn %in% credentials$user)
      shinyalert(title = "Access Denied", type = "warning", confirmButtonCol = "#337ab7")
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
  
  # update location options based on location selection
  observeEvent(input$year_audio,
               {
                 
                 audio_location_update <- full_audio_data %>%
                   filter(year %in% c(!!input$year_audio)) %>%
                   select(location) %>% 
                   distinct(location) %>% 
                   collect()
                 
                 
                 updatePickerInput(session, inputId = "location_audio",
                                   choices = audio_location_update)
               })

  # update region options based on location selection
  observeEvent(input$location_audio,
    {
      
      audio_region_update <- full_audio_data %>%
        filter(year %in% c(!!input$year_audio),
               location %in% (!!input$location_audio)) %>%
        select(region) %>% 
        distinct(region) %>% 
        collect()
        

      updatePickerInput(session, inputId = "region_audio",
                        choices = audio_region_update)
    })

  # update site options based on region selection
  observeEvent(input$region_audio,
    {
      
      audio_site_update <- full_audio_data %>%
        filter(year %in% c(!!input$year_audio),
               location %in% c(!!input$location_audio),
               region %in% c(!!input$region_audio)) %>%
        select(site) %>% 
        distinct(site) %>% 
        collect()

      updatePickerInput(session, inputId = "site_audio",
                        choices = audio_site_update)

    })
  
  observeEvent(input$site_audio,
               {
                 
                 audio_cols_update <- full_audio_data %>%
                   collect() %>% 
                   colnames() %>% 
                   as.data.frame() %>% 
                   rename("Variables" = ".") %>% 
                   filter(!Variables == "location" &
                          !Variables == "region" &
                          !Variables == "site" &
                          !Variables == "year") 
                 
                 updatePickerInput(session, inputId = "audio_cols",
                                   choices = audio_cols_update)
                 
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
  
  ######## eDNA ##########
  
  edna_data <- reactive({
    
    full_edna_data %>%
      filter(year %in% input$year_edna,
             location %in% input$location_edna,
             region %in% input$region_edna,
             site %in% input$site_edna) %>%
      select(location, region, site, !!input$edna_cols)
    
  })%>% bindCache(input$date_edna, input$location_edna, input$region_edna, input$site_edna, input$edna_cols)
  
  
  # update location options based on year selection
  observeEvent(input$year_edna,
               {
                 updated_edna_locations <- full_edna_data %>% 
                   filter(year %in% input$year_edna) %>% 
                   select(location) %>% 
                   distinct(location) 
                 
                 updatePickerInput(session, inputId = "location_edna",
                                   choices = updated_edna_locations$location)
               })
  
  # update region options based on location selection
  observeEvent(input$location_edna,
               {
                 
                 updated_edna_region <- full_edna_data %>% 
                   filter(year %in% input$year_edna,
                          location %in% input$location_edna) %>% 
                   select(region) %>% 
                   distinct(region) 
                 
                 updatePickerInput(session, inputId = "region_edna",
                                   choices = updated_edna_region$region)
               })
  
  # update site options based on region selection
  observeEvent(input$region_edna,
               {
                 
                 updated_edna_sites <-  full_edna_data %>% 
                   filter(year %in% input$year_edna,
                          location %in% input$location_edna,
                          region %in% input$region_edna) %>% 
                   select(site) %>% 
                   distinct(site) 
                 
                 updatePickerInput(session, inputId = "site_edna",
                                   choices = updated_edna_sites$site)
                 
               })
  
  # update aural col options
  observeEvent(input$site_edna,
               {
                 
                 site_edna_cols_update <- full_edna_data %>% 
                   colnames() %>% 
                   as.data.frame() %>% 
                   rename("Variables" = ".") %>% 
                   filter(!Variables == "location" &
                            !Variables == "region" &
                            !Variables == "site")  
                 
                 updatePickerInput(session, inputId = "edna_cols",
                                   choices = site_edna_cols_update)
               })
  
  # clear button
  observeEvent(input$edna_clear,
               {
                 updatePickerInput(session, inputId = "year_edna", selected = (max(edna_years$year)))
                 updatePickerInput(session, inputId = "location_edna", selected = "")
                 updatePickerInput(session, inputId = "region_edna", selected = "")
                 updatePickerInput(session, inputId = "site_edna", selected = "")
                 updatePickerInput(session, inputId = "edna_cols", selected = "")
                 
               }
  )
  
  
  
  # render data selection
  output$edna_t <- DT::renderDataTable(edna_data(), extensions= 'Buttons', rownames = FALSE,
                                       options = list(scrollX = T, TRUEom = 'Bfrtip',
                                                      buttons = c('copy', 'csv', 'excel', 'pdf', 'print')))
  
  # Data download
  observeEvent(input$edna_download, {
    
    shinyalert(title = "Pump the breaks!",
               text = "Did you get approval for data use from the data owners?",
               type = "input", closeOnClickOutside = T, showCancelButton = T, inputId = "edna_download_btn",
               showConfirmButton = T, confirmButtonText = "Confirm", cancelButtonText = "Cancel",
               animation = "slide-from-top", inputPlaceholder = "enter_username")
  })
  
  observeEvent(input$edna_download_btn,{
    if(input$edna_download_btn %in% credentials$user)
      showModal(modalDialog(downloadButton("edna_dwnld", "download"), footer = NULL, easyClose = T, size = "s"))
    
    if(!input$edna_download_btn %in% credentials$user)
      shinyalert(title = "Access Denied", type = "warning", confirmButtonCol = "#337ab7")
  })
  
  output$edna_dwnld <- downloadHandler(
    filename = function(){"insert_name.csv"},
    
    content = function(file) {
      shiny::withProgress(
        message = paste0("Downloading eDNA Data"),
        value = 0,
        {
          shiny::incProgress(1/10)
          Sys.sleep(1)
          shiny::incProgress(3/10)
          Sys.sleep(2)
          shiny::incProgress(9/10)
          write.csv(edna_data(), file, row.names = FALSE)
        }
      )
    }
  )
  
  
  ######## END HOBO ##########
  
  ######## Cap_Spec data ##############
  
  cap_map <- reactive({

    spat_data <- no_pros_cap_data %>%
      filter(year <= !!input$year_map[2] & year >= !!input$year_map[1],
             location %in% !!input$location_map, region %in% !!input$region_map) %>%
      select(location, region, site, year, utme, utmn, utm_zone) %>%
      group_by(site) %>%
      distinct() %>%
      collect()


    spat <- utm2lonlat(spat_data$utme, spat_data$utmn, zone = spat_data$utm_zone) %>%
      as.data.frame()

    spat_data$lat <- spat$latitude

    spat_data$lon <- spat$longitude

    fin_spat <- select(spat_data, !c(utme, utmn, utm_zone))
  }) 
  
  # observeEvent(input$location_map, {
  # 
  #   cap_map() %>%
  #     filter(location %in% !!input$location_map)
  # 
  # }, ignoreNULL = T)
  
  # # update location options based on year selection
  # observeEvent(input$year_map,
  #              {
  #                updated_map_locations <- no_pros_cap_data %>%
  #                  filter(year <= !!input$year_map[2] & year >= !!input$year_map[1]) %>%
  #                  select(location) %>%
  #                  distinct(location) %>%
  #                  collect()
  # 
  #                updatePickerInput(session, inputId = "location_map",
  #                                  choices = updated_map_locations$location)
  #              })
  # 
  # 
  # 
  # # update region options based on location selection
  # observeEvent(input$location_map,
  #              {
  #                updated_map_regions <- no_pros_cap_data %>%
  #                  filter(year <= !!input$year_map[2] & year >= !!input$year_map[1],
  #                         location %in% !!input$location_map) %>%
  #                  select(region) %>%
  #                  distinct(region) %>%
  #                  collect()
  # 
  #                updatePickerInput(session, inputId = "region_map",
  #                                  choices = updated_map_regions$region)
  #              })


# table_map <- reactive({
# 
# 
#   full_cap_data %>%
#     filter(year <= !!input$year_map[2] & year >= !!input$year_map[1]) %>%
#     select(year, site, species_capture, bd_swab_id, genetic_id, microbiome_swab_id, amp_id, mucosome_id,
#            bacterial_swab_id, antibody_id, crispr_id) %>%
#     group_by(site, year) %>%
#     summarise(species_count = count(species_capture),
#               bd_swab_tally = count(bd_swab_id),
#               genetic_tally = count(genetic_id),
#               microbiome_tally = count(microbiome_swab_id),
#               amp_tally = count(amp_id),
#               mucosome_tally = count(mucosome_id),
#               bacterial_tally = count(bacterial_swab_id),
#               anti_tally = count(antibody_id),
#               crispr_tally = count(crispr_id)) %>%
#     collect()
# 
# })
  
  output$site_map <- renderLeaflet({
    
    leaflet() %>% 
      addProviderTiles("Esri.WorldImagery") %>% 
      addMouseCoordinates() %>% 
      addMeasure(
        position = "bottomleft",
        primaryLengthUnit = "feet",
        primaryAreaUnit = "sqfeet",
        activeColor = "#3D535D",
        completedColor = "#7D4479") %>% 
      addCircleMarkers(lng = cap_map()$lon, lat = cap_map()$lat, data = cap_map(),
                       label = cap_map()$site,
                       clusterOptions = markerClusterOptions(zoomToBoundsOnClick = T,
                                                             spiderfyOnMaxZoom = T,
                                                             freezeAtZoom = F,
                                                             spiderfyDistanceMultiplier=5),
                       color = "#35b779", radius = 3, opacity = 1, fillOpacity = 1, weight = 5,
                       layerId = ~site)
     
    
  })
  

 
  # observeEvent(input$location_map, {
  # 
  #   leafletProxy("site_map") %>%
  #     clearMarkers() %>%
  #     addCircleMarkers(lng = ~lon, lat = ~lat, data = cap_map(),
  #                      label = ~site,
  #                      clusterOptions = markerClusterOptions(zoomToBoundsOnClick = T,
  #                                                            spiderfyOnMaxZoom = T,
  #                                                            freezeAtZoom = F,
  #                                                            spiderfyDistanceMultiplier=5),
  #                      color = "#35b779", radius = 3, opacity = 1, fillOpacity = 1, weight = 5,
  #                      layerId = ~site)
  # 
  # }, ignoreNULL = T)
  
  
 # observe({
 # 
 #   leafletProxy("site_map")
 # 
 #   site_click <- input$site_map_marker_click
 # 
 #   click_data <- full_cap_data %>%
 #     filter(year <= !!input$year_map[2] & year >= !!input$year_map[1],
 #            site %in% site_click$site) %>%
 #     select(year, site, species_capture, bd_swab_id, genetic_id, microbiome_swab_id, amp_id, mucosome_id,
 #            bacterial_swab_id, antibody_id, crispr_id) %>%
 #     group_by(site, year) %>%
 #     summarise(species_count = count(species_capture),
 #               bd_swab_tally = count(bd_swab_id),
 #               genetic_tally = count(genetic_id),
 #               microbiome_tally = count(microbiome_swab_id),
 #               amp_tally = count(amp_id),
 #               mucosome_tally = count(mucosome_id),
 #               bacterial_tally = count(bacterial_swab_id),
 #               anti_tally = count(antibody_id),
 #               crispr_tally = count(crispr_id)) %>%
 #     collect()
 # 
 # })
  

 

  
 
#track_usage(storage_mode = store_rds(path = "/home/ubuntu/RIBBiTR_DataRepository/logs"))

})

