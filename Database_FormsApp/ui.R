source(here("Database_FormsApp", "global.R"))



ui <- fluidPage(

    # Application title
    titlePanel(""),
      
      fluidPage(
        
        fluidRow(column(8, h1(strong("RIBBiTR Database Forms"), style = "font-size:60px;")),
                 column(4, img(src = "ribbitr.png", align = "right", height = "120", width = "150")))),
    
    navbarPage("", inverse = T,
               
               tabPanel("Home", icon = icon("info-circle"),
                        
                        fluidPage(
                          
                          fluidRow(
                            h1(strong("Intended Use"),style = "font-size:20px;"),
                            
                            column(12, p("add text", tags$a(href = "https://mountainlakesresearch.com", "Mountain Lakes Research Group")))),
                          
                          fluidRow(
                            h1(strong("Acknowledgements"), style = "font-size:20px;"),
                            
                            column(12, p("add text ",tags$a(href = "https://jake-eisaguirre.github.io/", "Jake Eisaguirre")))),
                          
                          # fluidRow(
                          #   align = "center", div(style = "display: inline", img(src = "ribbitr.png", height = "75", width = "95")),
                          #   img(src = "nsf_logo.png", align = "center", height = "75", width = "75")),
                          
                          fluidRow(
                            h1(strong("Data Collection"),style = "font-size:20px;"),
                            
                            column(12, p("add text", tags$a(href ="https://mountainlakesresearch.com/resources/", "HERE.")))),
      
    )),
    
    tabPanel(title = "Capture Data", icon = icon("frog"),

     sidebarLayout(
      
        sidebarPanel(
          
          sliderInput(inputId = "year",
                      label = "Select Annual Range:",
                      min = min(visit$year), max(visit$year),
                      sep = "",
                      value = c(max(visit$year) - 5, max(visit$year))),
            pickerInput(inputId = "location",
                        label = "Select Locations:",
                        choices = unique(location$location),
                        options = list(
                          `actions-box` = TRUE, 
                          size = 10,
                          `selected-text-format` = "count > 3"
                        ), 
                        multiple = TRUE),
            pickerInput(inputId = "region",
                        label = "Select Regions:",
                        choices = unique(region$region),
                        options = list(
                          `actions-box` = TRUE, 
                          size = 10,
                          `selected-text-format` = "count > 3"
                        ),
                        multiple = T),
            pickerInput(inputId = "site",
                        label = "Select Sites:",
                        choices = unique(site$site),
                        options = list(
                          `actions-box` = TRUE, 
                          size = 10,
                          `selected-text-format` = "count > 3"
                        ), 
                        multiple = TRUE),
          prettyCheckboxGroup(inputId = "site_cols",
                           label = "Select Site Variables of Interest:",
                           choices = colnames(site),
                           inline = T,
                           outline = T),
          prettyCheckboxGroup(inputId = "visit_cols",
                         label = "Select Visit Variables of Interest:",
                         choices = colnames(visit),
                         inline = T),
          prettyCheckboxGroup(inputId = "survey_cols",
                              label = "Select Survey Variables of Interest:",
                              choices = colnames(survey),
                              inline = T),
          prettyCheckboxGroup(inputId = "capture_cols",
                              label = "Select Capture Variables of Interest:",
                              choices = colnames(capture),
                              inline = T)
        ),

        # Show a plot of the generated distribution
        mainPanel(
            withSpinner(DT::dataTableOutput("cap_table"))))),
    
    tabPanel(title = "VES", icon = icon("eye"),
             
     sidebarLayout(
       
       sidebarPanel(
         
         ),
       mainPanel(
         )
       
     ))
    
    
  )
)
