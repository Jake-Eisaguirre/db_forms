source(here("Database_FormsApp", "global.R"))



ui <- fluidPage(tags$style('.container-fluid {
                             background-color: #c7c7c7;
              }'
              ),

    # Application title
    titlePanel(""),
      
      fluidPage(
        
        # title and header image
        fluidRow(column(9, h1(span("RIBBiTR Data Repository"), style = "font-size:50px; color: black")),
                 column(2, img(src = "ribbitr.png", align = "right", height = "110", width = "150")),
                 column(1, img(src = "nsf_logo.png", align = "reight", height = "110", width = "120")))),
    
    navbarPage("", inverse = T,
               
               # home tab panel
               tabPanel("Home", icon = icon("info-circle"),
                        
                        fluidPage(
                          
                          fluidRow(
                            h1(strong("Intended Use"),style = "font-size:20px;"),
                            
                            column(12, p("The data found within this repository is intended for internal use within", 
                                         tags$a(href = "https://ribbitr.com/", "RIBBiTR"), "and under no circumstances shall user login credentials be shared to outside participants. All users must adhear to data acuisition and data sharing protocols as stated in the", 
                                         tags$a(href = "https://docs.google.com/document/d/1m1EEuUH3ioVVXtFkDaWFHITddPcmputEhZxfW_omtrI
                                                /edit", "RIBBiTR Pre-collaboration Agreement"), "and", 
                                         tags$a(href = "https://drive.google.com/drive/folders/1KBkHAjwyaCufJpM1qbcyN6F-pd_uJpxU", 
                                                "RIBBiTR Schema"), ". As reminder, if you are downloading processed swab data, you must get approval from the data owners that collected the capture level data and the data owners who processed the swab data."))),
                          
                          fluidRow(
                            h1(strong("Acknowledgements"), style = "font-size:20px;"),
                            
                            column(12, p("This web-based application was created by ",tags$a(href = "https://jake-eisaguirre.github.io/", "Jake Eisaguirre"), ", Data Manager for the ",tags$a(href ="https://ribbitr.com/", "Resilience Institue Bridging Biological Training and Research"),"(RIBBiTR). Financial support was provided by the", tags$a(href = "https://www.nsf.gov/", "National Science Foundation.")))),
                          
                          # fluidRow(
                          #   align = "center", div(style = "display: inline", img(src = "ribbitr.png", height = "75", width = "95")),
                          #   img(src = "nsf_logo.png", align = "center", height = "75", width = "75")),
                          
                          fluidRow(div(style = "height:92.5px")),
                          
                          fluidRow(hr(style = "border-top: 1px solid #000000;")),
                          
                          fluidRow(
                           column(12, align = "center",  
                            div(#style = "display: inline;",
                                img(src = "foot.png",
                                    height = 300,
                                    width = 1000)))))),
    
    tabPanel(title = "Capture", icon = icon("frog"),

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
              hr(style = "border-top: 1px solid #000000;"),
              pickerInput(inputId = "site_cols",
                          label = "Select Site Variables of Interest:",
                          choices = colnames(site),
                          options = list(
                            `actions-box` = TRUE, 
                            size = 10,
                            `selected-text-format` = "count > 3"
                          ), 
                          multiple = TRUE),
              pickerInput(inputId = "visit_cols",
                          label = "Select Visit Variables of Interest:",
                          choices = colnames(visit),
                          options = list(
                            `actions-box` = TRUE, 
                            size = 10,
                            `selected-text-format` = "count > 3"
                          ), 
                          multiple = TRUE),
              pickerInput(inputId = "survey_cols",
                          label = "Select Survey Variables of Interest:",
                          choices = colnames(survey),
                          options = list(
                            `actions-box` = TRUE, 
                            size = 10,
                            `selected-text-format` = "count > 3"
                          ), 
                          multiple = TRUE),
              pickerInput(inputId = "capture_cols",
                          label = "Select Capture Variables of Interest:",
                          choices = colnames(capture),
                          options = list(
                            `actions-box` = TRUE, 
                            size = 10,
                            `selected-text-format` = "count > 3"
                          ),
                          multiple = TRUE)),
           

            # Show a plot of the generated distribution
            mainPanel(
                withSpinner(DT::dataTableOutput("cap_table")),
                headerPanel(""),
                useShinyalert(),
                actionButton('cap_download',"Download the data"))),
         hr(style = "border-top: 1px solid #000000;")),
         
    tabPanel(title = "VES", icon = icon("eye"),
             
        sidebarLayout(
          
          sidebarPanel(
            sliderInput(inputId = "year_ves",
                        label = "Select Annual Range:",
                        min = min(visit$year), max(visit$year),
                        sep = "",
                        value = c(max(visit$year) - 5, max(visit$year))),
            pickerInput(inputId = "location_ves",
                        label = "Select Locations:",
                        choices = unique(location$location),
                        options = list(
                          `actions-box` = TRUE, 
                          size = 10,
                          `selected-text-format` = "count > 3"
                        ), 
                        multiple = TRUE),
            pickerInput(inputId = "region_ves",
                        label = "Select Regions:",
                        choices = unique(region$region),
                        options = list(
                          `actions-box` = TRUE, 
                          size = 10,
                          `selected-text-format` = "count > 3"
                        ),
                        multiple = T),
            pickerInput(inputId = "site_ves",
                        label = "Select Sites:",
                        choices = unique(site$site),
                        options = list(
                          `actions-box` = TRUE, 
                          size = 10,
                          `selected-text-format` = "count > 3"
                        ), 
                        multiple = TRUE),
            hr(style = "border-top: 1px solid #000000;"),
            pickerInput(inputId = "site_cols_ves",
                        label = "Select Site Variables of Interest:",
                        choices = colnames(site),
                        options = list(
                          `actions-box` = TRUE, 
                          size = 10,
                          `selected-text-format` = "count > 3"
                        ), 
                        multiple = TRUE),
            pickerInput(inputId = "visit_cols_ves",
                        label = "Select Visit Variables of Interest:",
                        choices = colnames(visit),
                        options = list(
                          `actions-box` = TRUE, 
                          size = 10,
                          `selected-text-format` = "count > 3"
                        ), 
                        multiple = TRUE),
            pickerInput(inputId = "survey_cols_ves",
                        label = "Select Survey Variables of Interest:",
                        choices = colnames(survey),
                        options = list(
                          `actions-box` = TRUE, 
                          size = 10,
                          `selected-text-format` = "count > 3"
                        ), 
                        multiple = TRUE),
            pickerInput(inputId = "ves_cols",
                        label = "Select VES Variables of Interest:",
                        choices = colnames(ves_cols),
                        options = list(
                          `actions-box` = TRUE, 
                          size = 10,
                          `selected-text-format` = "count > 3"
                        ),
                        multiple = TRUE)),
          
          mainPanel(
            withSpinner(DT::dataTableOutput("ves_table")),
            headerPanel(""),
            downloadButton('ves_download',"Download the data"))),
        hr(style = "border-top: 1px solid #000000;")),
    
    tabPanel(title = "Aural", icon = icon("music"),
             
             sidebarLayout(
               
               sidebarPanel(
                 sliderInput(inputId = "year_a",
                             label = "Select Annual Range:",
                             min = min(visit$year), max(visit$year),
                             sep = "",
                             value = c(max(visit$year) - 5, max(visit$year))),
                 pickerInput(inputId = "location_a",
                             label = "Select Locations:",
                             choices = unique(location$location),
                             options = list(
                               `actions-box` = TRUE, 
                               size = 10,
                               `selected-text-format` = "count > 3"
                             ), 
                             multiple = TRUE),
                 pickerInput(inputId = "region_a",
                             label = "Select Regions:",
                             choices = unique(region$region),
                             options = list(
                               `actions-box` = TRUE, 
                               size = 10,
                               `selected-text-format` = "count > 3"
                             ),
                             multiple = T),
                 pickerInput(inputId = "site_a",
                             label = "Select Sites:",
                             choices = unique(site$site),
                             options = list(
                               `actions-box` = TRUE, 
                               size = 10,
                               `selected-text-format` = "count > 3"
                             ), 
                             multiple = TRUE),
                 hr(style = "border-top: 1px solid #000000;"),
                 pickerInput(inputId = "site_cols_a",
                             label = "Select Site Variables of Interest:",
                             choices = colnames(site),
                             options = list(
                               `actions-box` = TRUE, 
                               size = 10,
                               `selected-text-format` = "count > 3"
                             ), 
                             multiple = TRUE),
                 pickerInput(inputId = "visit_cols_a",
                             label = "Select Visit Variables of Interest:",
                             choices = colnames(visit),
                             options = list(
                               `actions-box` = TRUE, 
                               size = 10,
                               `selected-text-format` = "count > 3"
                             ), 
                             multiple = TRUE),
                 pickerInput(inputId = "survey_cols_a",
                             label = "Select Survey Variables of Interest:",
                             choices = colnames(survey),
                             options = list(
                               `actions-box` = TRUE, 
                               size = 10,
                               `selected-text-format` = "count > 3"
                             ), 
                             multiple = TRUE),
                 pickerInput(inputId = "aural_cols",
                             label = "Select Aural Variables of Interest:",
                             choices = colnames(aural_cols),
                             options = list(
                               `actions-box` = TRUE, 
                               size = 10,
                               `selected-text-format` = "count > 3"
                             ),
                             multiple = TRUE)
                 
               ),
               mainPanel(withSpinner(DT::dataTableOutput("aural_table")),
                         headerPanel(""),
                         downloadButton('aural_download',"Download the data"))),
             hr(style = "border-top: 1px solid #000000;")),
    
    tabPanel(title = "Hobo Sensor", icon = icon("thermometer"),
             
             sidebarLayout(
               
               sidebarPanel(
                 
               ),
               mainPanel(img(src = "homer.jpeg", height = "700", width = "700")
               )
               
             )),
    
    tabPanel(title = "eDNA", icon = icon("dna"),
             
             sidebarLayout(
               
               sidebarPanel(
                 
               ),
               mainPanel(img(src = "homer.jpeg", height = "700", width = "700")
               )
               
             ))
    
    
  )
 )

