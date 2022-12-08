source(here("Database_FormsApp", "global.R"))


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  #reactive location query
  location_data <- reactive({
    
    loc_q <- glue::glue_sql(
      
      "SELECT * FROM location
       WHERE location IN ({loc_name*});",
      loc_name = input$location,
      .con = connection)
    
    
    loc_out <- as.data.frame(dbGetQuery(connection, loc_q))
    
  })
  
  #table output
  #output$loc <- renderDataTable(location_data())
  
  #reactive region table
  location_region <- reactive({
    
    loc_r <- glue::glue_data_sql(
      
      "SELECT * FROM region
       WHERE region IN ({reg_name*})",
      reg_name = input$region,
      .con = connection)
    
    reg_out <- as.data.frame(dbGetQuery(connection, loc_r))
    
  loc_reg <- loc_out %>% 
    left_join(reg_out, by = c("location_id"))
  
  })
  
  output$loc <- renderDataTable(location_region())
  
  

})
