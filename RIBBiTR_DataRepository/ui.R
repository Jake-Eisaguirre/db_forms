source("global.R", local = T)
source("creds.R", local = T)
source("db_creds_goog.R", local = T)



ui <- secure_app(head_auth = tags$script(inactivity), 
        
        fluidPage(tags$style('body {
                    background-color: #c7c7c7;
     }'
        ),
     tags$style(HTML(".well {
        border: 1px solid #000000;
      }")), 
     tags$style(HTML(".col-sm-8 {
        border: 1px solid #000000;
      }")),
     
     
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
                             
                             column(11, p("The data found within this repository is intended for internal use within", 
                                          tags$a(href = "https://ribbitr.com/", "RIBBiTR"), "and under no circumstances shall user login credentials be shared to outside participants. All users must adhear to data acuisition and data sharing protocols as stated in the", 
                                                   tags$a(href = "https://docs.google.com/document/d/1m1EEuUH3ioVVXtFkDaWFHITddPcmputEhZxfW_omtrI
                                                /edit", "RIBBiTR Pre-collaboration Agreement"), "and", 
                                                tags$a(href = "https://drive.google.com/drive/folders/1KBkHAjwyaCufJpM1qbcyN6F-pd_uJpxU", 
                                                       "RIBBiTR Schema"), ". As reminder, if you are downloading processed swab data, you must get approval from the data owners that collected the capture level data and the data owners who processed the swab data."))),
                                    
                                    fluidRow(
                                      h1(strong("Acknowledgements"), style = "font-size:20px;"),
                                      
                                      column(11, p("This web-based application was created by ",tags$a(href = "https://jake-eisaguirre.github.io/", "Jake Eisaguirre"), ", Data Manager for the ",tags$a(href ="https://ribbitr.com/", "Resilience Institue Bridging Biological Training and Research"),"(RIBBiTR). Financial support was provided by the", tags$a(href = "https://www.nsf.gov/", "National Science Foundation.")))),
                   
                   # fluidRow(
                   #   align = "center", div(style = "display: inline", img(src = "ribbitr.png", height = "75", width = "95")),
                   #   img(src = "nsf_logo.png", align = "center", height = "75", width = "75")),
                   
                   fluidRow(div(style = "height:22.5px")),
                   
                   fluidRow(column(12, actionButton(inputId = "refresh",
                                                    label = "Refresh Database",
                                                    icon = icon("refresh")))),
                   
                   fluidRow(div(style = "height:62.5px")),
                   
                   fluidRow(hr(style = "border-top: 1px solid #000000;")),
                   
                   fluidRow(
                     column(11, align = "center",  
                            div(#style = "display: inline;",
                              img(src = "foot.png",
                                  height = 300,
                                  width = 1000)))))),
        ######## CAPTURE TAB ##############
        navbarMenu(title = "Capture", icon = icon("frog"),
                   
                   tabPanel(title = "Data",
                            
                            sidebarLayout(
                              
                              sidebarPanel(
                                fluidRow(
                                  column(12, sliderInput(inputId = "year",
                                                         label = "Select Annual Range:",
                                                         min = min(visit$year), max(visit$year),
                                                         sep = "",
                                                         value = c(max(visit$year) - 5, max(visit$year)))),
                                  column(5, pickerInput(inputId = "location",
                                                        label = "Select Locations:",
                                                        choices = unique(location$location),
                                                        options = list(
                                                          `actions-box` = TRUE, 
                                                          size = 10,
                                                          `selected-text-format` = "count > 3"
                                                        ), 
                                                        multiple = TRUE,
                                                        width = "180px")),
                                  column(5, pickerInput(inputId = "region",
                                                        label = "Select Regions:",
                                                        choices = unique(region$region),
                                                        options = list(
                                                          `actions-box` = TRUE, 
                                                          size = 10,
                                                          `selected-text-format` = "count > 3"
                                                        ),
                                                        multiple = T,
                                                        width = "180px"), offset = 1),
                                  column(12, pickerInput(inputId = "site",
                                                         label = "Select Sites:",
                                                         choices = unique(site$site),
                                                         options = list(
                                                           `actions-box` = TRUE, 
                                                           size = 10,
                                                           `selected-text-format` = "count > 3"
                                                         ), 
                                                         multiple = TRUE)),
                                  column(12, hr(style = "border-top: 1px solid #000000;")),
                                  column(12, pickerInput(inputId = "site_cols",
                                                         label = "Select Site Variables of Interest:",
                                                         choices = colnames(site),
                                                         options = list(
                                                           `actions-box` = TRUE, 
                                                           size = 10,
                                                           `selected-text-format` = "count > 3"
                                                         ), 
                                                         multiple = TRUE)),
                                  column(12, pickerInput(inputId = "visit_cols",
                                                         label = "Select Visit Variables of Interest:",
                                                         choices = colnames(visit),
                                                         options = list(
                                                           `actions-box` = TRUE, 
                                                           size = 10,
                                                           `selected-text-format` = "count > 3"
                                                         ), 
                                                         multiple = TRUE)),
                                  column(12, pickerInput(inputId = "survey_cols",
                                                         label = "Select Survey Variables of Interest:",
                                                         choices = colnames(survey),
                                                         options = list(
                                                           `actions-box` = TRUE, 
                                                           size = 10,
                                                           `selected-text-format` = "count > 3"
                                                         ), 
                                                         multiple = TRUE)),
                                  column(12,pickerInput(inputId = "capture_cols",
                                                        label = "Select Capture Variables of Interest:",
                                                        choices = colnames(capture),
                                                        options = list(
                                                          `actions-box` = TRUE, 
                                                          size = 10,
                                                          `selected-text-format` = "count > 3"
                                                        ),
                                                        multiple = TRUE)),
                                  column(12, hr(style = "border-top: 1px solid #000000;")),
                                  column(12, pickerInput(inputId = "comb_bd_cols",
                                                         label = "Select Bd Load Variables of Interest",
                                                         choices = colnames(comb_bd),
                                                         options = list(
                                                           `actions-box` = TRUE, 
                                                           size = 10,
                                                           `selected-text-format` = "count > 3"
                                                         ), 
                                                         multiple = TRUE)),
                                  column(12, pickerInput(inputId = 'amp_cols',
                                                         label = "Select AMP Variables of Interest",
                                                         choices = colnames(serdp_amp),
                                                         options = list(
                                                           `actions-box` = TRUE, 
                                                           size = 10,
                                                           `selected-text-format` = "count > 3"
                                                         ), 
                                                         multiple = TRUE)),
                                  column(12, pickerInput(inputId = 'muc_mic_cols',
                                                         label = "Select Mucosome/Microbiome Variables of Interest",
                                                         choices = colnames(serdp_muc_mic),
                                                         options = list(
                                                           `actions-box` = TRUE, 
                                                           size = 10,
                                                           `selected-text-format` = "count > 3"
                                                         ), 
                                                         multiple = TRUE)),
                                  column(12, pickerInput(inputId = "genom_cols",
                                                         label = "Select Bd Genomic Variables of Interest",
                                                         choices = colnames(serdp_bd_genom),
                                                         options = list(
                                                           `actions-box` = TRUE, 
                                                           size = 10,
                                                           `selected-text-format` = "count > 3"
                                                         ), 
                                                         multiple = TRUE)))),
                              
                              
                              # Show a plot of the generated distribution
                              mainPanel(
                                withSpinner(DT::dataTableOutput("cap_table")),
                                headerPanel(""),
                                actionButton('cap_download',"Download the data",
                                             icon("download"), 
                                             style="color: #fff; background-color: #337ab7; border-color: #2e6da4"),
                                actionButton('cap_clear', "Clear Selection",
                                             icon("trash"),
                                             style="color: #fff; background-color: red; border-color: black"))),
                            hr(style = "border-top: 1px solid #000000;")),
                   
                   tabPanel(title = "Metadata",
                            
                            tabsetPanel(
                              tabPanel(title = "Pennsylvania",
                                       img(src = "yoda.jpeg", height = "400", width = "500")),
                              tabPanel(title = "Sierra Nevadas",
                                       img(src = "homer.jpeg", height = "400", width = "500")),
                              tabPanel(title = "Panama",
                                       img(src = "yoda.jpeg", height = "400", width = "500")),
                              tabPanel(title = "Brazil",
                                       img(src = "homer.jpeg", height = "400", width = "500")),
                              tabPanel(title = "SERDP",
                                       img(src = "yoda.jpeg", height = "400", width = "500"))),
                            hr(style = "border-top: 1px solid #000000;"))),
        
        ######## END CAPTURE ##############
        
        ######## VES TAB ################
        
        navbarMenu(title = "VES", icon = icon("eye"),
                   
                   tabPanel(title = "Data",
                            
                            sidebarLayout(
                              
                              sidebarPanel(
                                fluidRow(
                                  column(12, sliderInput(inputId = "year_ves",
                                                         label = "Select Annual Range:",
                                                         min = min(visit$year), max(visit$year),
                                                         sep = "",
                                                         value = c(max(visit$year) - 5, max(visit$year)))),
                                  column(5, pickerInput(inputId = "location_ves",
                                                        label = "Select Locations:",
                                                        choices = unique(location$location),
                                                        options = list(
                                                          `actions-box` = TRUE, 
                                                          size = 10,
                                                          `selected-text-format` = "count > 3"
                                                        ), 
                                                        multiple = TRUE,
                                                        width = "180px")),
                                  column(5, pickerInput(inputId = "region_ves",
                                                        label = "Select Regions:",
                                                        choices = unique(region$region),
                                                        options = list(
                                                          `actions-box` = TRUE, 
                                                          size = 10,
                                                          `selected-text-format` = "count > 3"
                                                        ),
                                                        multiple = T,
                                                        width = "180px"), offset = 1),
                                  column(12, pickerInput(inputId = "site_ves",
                                                         label = "Select Sites:",
                                                         choices = unique(site$site),
                                                         options = list(
                                                           `actions-box` = TRUE, 
                                                           size = 10,
                                                           `selected-text-format` = "count > 3"
                                                         ), 
                                                         multiple = TRUE)),
                                  column(12, hr(style = "border-top: 1px solid #000000;")),
                                  column(12, pickerInput(inputId = "site_cols_ves",
                                                         label = "Select Site Variables of Interest:",
                                                         choices = colnames(site),
                                                         options = list(
                                                           `actions-box` = TRUE, 
                                                           size = 10,
                                                           `selected-text-format` = "count > 3"
                                                         ), 
                                                         multiple = TRUE)),
                                  column(12, pickerInput(inputId = "visit_cols_ves",
                                                         label = "Select Visit Variables of Interest:",
                                                         choices = colnames(visit),
                                                         options = list(
                                                           `actions-box` = TRUE, 
                                                           size = 10,
                                                           `selected-text-format` = "count > 3"
                                                         ), 
                                                         multiple = TRUE)),
                                  column(12, pickerInput(inputId = "survey_cols_ves",
                                                         label = "Select Survey Variables of Interest:",
                                                         choices = colnames(survey),
                                                         options = list(
                                                           `actions-box` = TRUE, 
                                                           size = 10,
                                                           `selected-text-format` = "count > 3"
                                                         ), 
                                                         multiple = TRUE)),
                                  column(12, pickerInput(inputId = "ves_cols",
                                                         label = "Select VES Variables of Interest:",
                                                         choices = colnames(ves_cols),
                                                         options = list(
                                                           `actions-box` = TRUE, 
                                                           size = 10,
                                                           `selected-text-format` = "count > 3"
                                                         ),
                                                         multiple = TRUE)))),
                              
                              mainPanel(
                                withSpinner(DT::dataTableOutput("ves_table")),
                                headerPanel(""),
                                actionButton('ves_download',"Download the data",
                                             icon("download"), 
                                             style="color: #fff; background-color: #337ab7; border-color: #2e6da4"),
                                actionButton('ves_clear', "Clear Selection",
                                             icon("trash"),
                                             style="color: #fff; background-color: red; border-color: black"))),
                            hr(style = "border-top: 1px solid #000000;")),
                   
                   tabPanel(title = "Metadata",
                            
                            tabsetPanel(
                              tabsetPanel(
                                tabPanel(title = "Pennsylvania",
                                         img(src = "yoda.jpeg", height = "400", width = "500")),
                                tabPanel(title = "Sierra Nevadas",
                                         img(src = "homer.jpeg", height = "400", width = "500")),
                                tabPanel(title = "Panama",
                                         img(src = "yoda.jpeg", height = "400", width = "500"))),
                              hr(style = "border-top: 1px solid #000000;")))),
        
        ####### END VES ##########
        
        ####### Aural Tab ##########
        
        navbarMenu(title = "Aural", icon = icon("music"),
                   
                   tabPanel(title = "Data",
                            
                            sidebarLayout(
                              
                              sidebarPanel(
                                fluidRow(    
                                  column(12, sliderInput(inputId = "year_a",
                                                         label = "Select Annual Range:",
                                                         min = min(visit$year), max(visit$year),
                                                         sep = "",
                                                         value = c(max(visit$year) - 5, max(visit$year)))),
                                  column(5, pickerInput(inputId = "location_a",
                                                        label = "Select Locations:",
                                                        choices = unique(location$location),
                                                        options = list(
                                                          `actions-box` = TRUE, 
                                                          size = 10,
                                                          `selected-text-format` = "count > 3"
                                                        ), 
                                                        multiple = TRUE,
                                                        width = "180px")),
                                  column(5, pickerInput(inputId = "region_a",
                                                        label = "Select Regions:",
                                                        choices = unique(region$region),
                                                        options = list(
                                                          `actions-box` = TRUE, 
                                                          size = 10,
                                                          `selected-text-format` = "count > 3"
                                                        ),
                                                        multiple = T,
                                                        width = "180px"), offset = 1),
                                  column(12, pickerInput(inputId = "site_a",
                                                         label = "Select Sites:",
                                                         choices = unique(site$site),
                                                         options = list(
                                                           `actions-box` = TRUE, 
                                                           size = 10,
                                                           `selected-text-format` = "count > 3"
                                                         ), 
                                                         multiple = TRUE)),
                                  column(12, hr(style = "border-top: 1px solid #000000;")),
                                  column(12, pickerInput(inputId = "site_cols_a",
                                                         label = "Select Site Variables of Interest:",
                                                         choices = colnames(site),
                                                         options = list(
                                                           `actions-box` = TRUE, 
                                                           size = 10,
                                                           `selected-text-format` = "count > 3"
                                                         ), 
                                                         multiple = TRUE)),
                                  column(12, pickerInput(inputId = "visit_cols_a",
                                                         label = "Select Visit Variables of Interest:",
                                                         choices = colnames(visit),
                                                         options = list(
                                                           `actions-box` = TRUE, 
                                                           size = 10,
                                                           `selected-text-format` = "count > 3"
                                                         ), 
                                                         multiple = TRUE)),
                                  column(12, pickerInput(inputId = "survey_cols_a",
                                                         label = "Select Survey Variables of Interest:",
                                                         choices = colnames(survey),
                                                         options = list(
                                                           `actions-box` = TRUE, 
                                                           size = 10,
                                                           `selected-text-format` = "count > 3"
                                                         ), 
                                                         multiple = TRUE)),
                                  column(12, pickerInput(inputId = "aural_cols",
                                                         label = "Select Aural Variables of Interest:",
                                                         choices = colnames(aural_cols),
                                                         options = list(
                                                           `actions-box` = TRUE, 
                                                           size = 10,
                                                           `selected-text-format` = "count > 3"
                                                         ),
                                                         multiple = TRUE)))),
                              
                              mainPanel(withSpinner(DT::dataTableOutput("aural_table")),
                                        headerPanel(""),
                                        actionButton('aural_download',"Download the data",
                                                     icon("download"), 
                                                     style="color: #fff; background-color: #337ab7; border-color: #2e6da4"),
                                        actionButton('aural_clear', "Clear Selection",
                                                     icon("trash"),
                                                     style="color: #fff; background-color: red; border-color: black"))),
                            hr(style = "border-top: 1px solid #000000;")),
                   
                   tabPanel(title = "Metadata",
                            
                            tabsetPanel(
                              tabsetPanel(
                                tabPanel(title = "Pennsylvania",
                                         img(src = "yoda.jpeg", height = "400", width = "500")),
                                tabPanel(title = "Panama",
                                         img(src = "homer.jpeg", height = "400", width = "500"))),
                              hr(style = "border-top: 1px solid #000000;")))),
        
        ########## END Aural Tab ##########
        
        ########## HOBO TAB ##########
        
        navbarMenu(title = "Hobo Sensor", icon = icon("thermometer"),
                   
                   tabPanel(title = "Data",
                            
                            sidebarLayout(
                              
                              sidebarPanel(
                                fluidRow(   
                                  column(12, sliderInput(inputId = "date_hobo",
                                                         label = "Select Annual Range:",
                                                         min = min(hobo_cols$year), max(hobo_cols$year),
                                                         sep = "",
                                                         value = c(max(hobo_cols$year) - 3, max(hobo_cols$year)))),
                                  column(5, pickerInput(inputId = "location_hobo",
                                                        label = "Select Locations:",
                                                        choices = unique(hobo_location$location),
                                                        options = list(
                                                          `actions-box` = TRUE, 
                                                          size = 10,
                                                          `selected-text-format` = "count > 3"
                                                        ), 
                                                        multiple = TRUE,
                                                        width = "180px")),
                                  column(5, pickerInput(inputId = "region_hobo",
                                                        label = "Select Regions:",
                                                        choices = unique(hobo_region$region),
                                                        options = list(
                                                          `actions-box` = TRUE, 
                                                          size = 10,
                                                          `selected-text-format` = "count > 3"
                                                        ),
                                                        multiple = T,
                                                        width = "180px"), offset = 1),
                                  column(12, pickerInput(inputId = "site_hobo",
                                                         label = "Select Sites:",
                                                         choices = unique(hobo_site$site),
                                                         options = list(
                                                           `actions-box` = TRUE, 
                                                           size = 10,
                                                           `selected-text-format` = "count > 3"
                                                         ), 
                                                         multiple = TRUE)),
                                  column(12, hr(style = "border-top: 1px solid #000000;")),
                                  column(12, pickerInput(inputId = "hobo_cols",
                                                         label = "Select Hobo Sensors Variables of Interest:",
                                                         choices = colnames(hobo_cols),
                                                         options = list(
                                                           `actions-box` = TRUE, 
                                                           size = 10,
                                                           `selected-text-format` = "count > 3"
                                                         ), 
                                                         multiple = TRUE)))),
                              
                              mainPanel(withSpinner(DT::dataTableOutput("hobo_t")),
                                        headerPanel(""),
                                        actionButton('hobo_download',"Download the data",
                                                     icon("download"), 
                                                     style="color: #fff; background-color: #337ab7; border-color: #2e6da4"),
                                        actionButton('hobo_clear', "Clear Selection",
                                                     icon("trash"),
                                                     style="color: #fff; background-color: red; border-color: black"))),
                            hr(style = "border-top: 1px solid #000000;")),
                   
                   tabPanel(title = "Metadata",
                            
                            tabsetPanel(
                              tabPanel(title = "Pennsylvania"),
                              tabPanel(title = "Sierra Nevadas"),
                              tabPanel(title = "Panama"),
                              tabPanel(title = "Brazil"),
                              tabPanel(title = "SERDP")
                              
                            )
                   )),
        
        
        ######## END HOBO Tab ##########
        
        ######## eDNA TAB ############
        
        tabPanel(title = "eDNA", icon = icon("dna"),
                 
                 sidebarLayout(
                   
                   sidebarPanel(
                     
                   ),
                   mainPanel(img(src = "homer.jpeg", height = "600", width = "700")
                   )
                   
                 ))
        
        ######### END eDNA Tab #########    
                         
  )
 )
)
