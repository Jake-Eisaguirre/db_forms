source(("global.R"), local = T)
source(("creds.R"), local = T)
# source("db_creds_goog.R", local = T)



ui <- secure_app(head_auth = tags$script(inactivity), 
        
        fluidPage(
          
          # Styling 
          tags$style('body {
                    background-color: #c7c7c7;}'),
          tags$style(HTML(".well {
                    border: 1px solid #000000;}")), 
          tags$style(HTML(".tabbable > .nav > li > a {
                    background-color: #222; color: #9d9d9d;}")),
          tags$style(HTML(".tabbable > .nav > li[class=active] > a {
                      background-color: #080808 ; color: #FFF;}")),
          tags$style(HTML(".dropdown-menu > .active > a {
                          background-color: #080808 ; color: #FFF;}")),
          # tags$style(HTML('.alert .confirm {background-color: #2874A6;}')),
          # tags$style(HTML('.alert .cancel {background-color: #2874A6 !important;}')),
          # tags$style(HTML('.alert .test {background-color: #2874A6 !important;}')),
     
     
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
                                                       "RIBBiTR Schema"), ". As reminder, if you are downloading processed swab data, you must get approval from the data owners that collected the capture level data and the data owners who processed the swab data. Please include the", tags$a(href = "eisaguirre@ucsb.edu", "Data Manager"), "in all data inquiries with the respected data owners and please clear all data selections following data download to maintain app performance."))),
                           
                           fluidRow(
                             h1(strong("Data Owners"), style = "font-size:20px;"),
                             
                             column(11, tags$ul(p(tags$ul("- Panama Survey Data:", tags$a(href = "jvoyles@unr.edu", "Jamie Voyles")),
                                                  tags$ul("- SERDP Survey Data:", tags$a(href = "cori.zawacki@pitt.edu", "Cori Richards-Zawacki")),
                                                  tags$ul("- Pennsylvania Survey Data:", tags$a(href = "cori.zawacki@pitt.edu", "Cori Richards-Zawacki")),
                                                  tags$ul("- Sierra Nevada Survey Data:", tags$a(href = "roland.knapp@ucsb.edu", "Roland Knapp")), 
                                                  tags$ul("- Brazil Survey Data:", tags$a(href = "guibecker@psu.edu", "Gui Becker")),
                                                  tags$ul("- AMP:", tags$a(href = "louise.rollins-smith@vanderbilt.edu", "Louise Rollins-Smith")),
                                                  tags$ul("- Microbiome:", tags$a(href = "dwoodhams@gmail.com", "Doug Woodhams")),
                                                  tags$ul("- Genetic:", tags$a(href = "rosenblum@berkeley.edu", "Bree Rosenblum")),
                                                  tags$ul("- Antibody:", tags$a(href = "louise.rollins-smith@vanderbilt.edu", "Louise Rollins-Smith")),
                                                  tags$ul("- Bacterial:", tags$a(href = "dwoodhams@gmail.com", "Doug Woodhams")),
                                                  tags$ul("- Mucosome:", tags$a(href = "dwoodhams@gmail.com", "Doug Woodhams")),
                                                  tags$ul("- HOBO:", tags$a(href = "mohmer@olemiss.edu", "Michel Ohmer")),
                                                  tags$ul("Contact", tags$a(href = "eisaguirre@ucsb.edu", "Jake Eisaguirre"), ", Data Manager, to help develop query for variables of interest"))))),
                                    
                                    fluidRow(
                                      h1(strong("Acknowledgements"), style = "font-size:20px;"),
                                      
                                      column(11, p("This web-based application was created by ",tags$a(href = "https://jake-eisaguirre.github.io/", "Jake Eisaguirre"), ", Data Manager for the ",tags$a(href ="https://ribbitr.com/", "Resilience Institue Bridging Biological Training and Research"),"(RIBBiTR). Financial support was provided by the", tags$a(href = "https://www.nsf.gov/", "National Science Foundation.")))),
                   
                   # fluidRow(
                   #   align = "center", div(style = "display: inline", img(src = "ribbitr.png", height = "75", width = "95")),
                   #   img(src = "nsf_logo.png", align = "center", height = "75", width = "75")),
                   
                   
                   #fluidRow(div(style = "height:62.5px")),
                   
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
                                                         min = min(years$year), max(years$year),
                                                         sep = "",
                                                         value = c(max(years$year) - 5, max(years$year)),
                                                         step = 1)),
                                  column(5, pickerInput(inputId = "location",
                                                        label = "Select Locations:",
                                                        choices = "",
                                                        options = list(
                                                          `actions-box` = TRUE, 
                                                          size = 10,
                                                          `selected-text-format` = "count > 3"
                                                        ), 
                                                        multiple = TRUE,
                                                        width = "180px")),
                                  column(5, pickerInput(inputId = "region",
                                                        label = "Select Regions:",
                                                        choices = "",
                                                        options = list(
                                                          `actions-box` = TRUE, 
                                                          size = 10,
                                                          `selected-text-format` = "count > 3"
                                                        ),
                                                        multiple = T,
                                                        width = "180px"), offset = 1),
                                  column(12, pickerInput(inputId = "site",
                                                         label = "Select Sites:",
                                                         choices = "",
                                                         options = list(
                                                           `actions-box` = TRUE, 
                                                           size = 10,
                                                           `selected-text-format` = "count > 3"
                                                         ), 
                                                         multiple = TRUE)),
                                  column(12, hr(style = "border-top: 1px solid #000000;")),
                                  column(12, pickerInput(inputId = "site_cols",
                                                         label = "Select Variables of Interest:",
                                                         choices = "",
                                                         options = list(
                                                           `actions-box` = TRUE, 
                                                           size = 10,
                                                           `selected-text-format` = "count > 3"
                                                         ), 
                                                         multiple = TRUE)),
                                  column(12, hr(style = "border-top: 1px solid #000000;")),
                                  column(12, pickerInput(inputId = 'amp_cols',
                                                         label = "Select AMP Variables of Interest",
                                                         choices = serdp_amp,
                                                         options = list(
                                                           `actions-box` = TRUE, 
                                                           size = 10,
                                                           `selected-text-format` = "count > 3"
                                                         ), 
                                                         multiple = TRUE)),
                                  column(12, pickerInput(inputId = "bd_temp",
                                                         label = "Select Bd Load Variables of Interest",
                                                         choices = comb_bd,
                                                         options = list(
                                                           `actions-box` = TRUE, 
                                                           size = 10,
                                                           `selected-text-format` = "count > 3"
                                                         ), 
                                                         multiple = TRUE)),
                                  column(12, pickerInput(inputId = 'muc_mic_cols',
                                                         label = "Select Mucosome/Microbiome Variables of Interest",
                                                         choices = serdp_muc_mic,
                                                         options = list(
                                                           `actions-box` = TRUE, 
                                                           size = 10,
                                                           `selected-text-format` = "count > 3"
                                                         ), 
                                                         multiple = TRUE)),
                                  column(12, pickerInput(inputId = "genom_cols",
                                                         label = "Select Bd Genomic Variables of Interest",
                                                         choices = serdp_bd_genom,
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
                                             style="color: #fff; background-color: #337ab7; border-color: black"),
                                actionButton('cap_clear', "Clear Selection",
                                             icon("trash"),
                                             style="color: #fff; background-color: red; border-color: black"))),
                            hr(style = "border-top: 1px solid #000000;")),
                   
                   tabPanel(title = "Metadata",
                            
                            tabsetPanel(
                              tabPanel(title = "Schema",
                                       tags$iframe(style="height:800px; 
                                             width:100%; 
                                             scrolling=yes;
                                             zoom=yes", 
                                             src= "schema.pdf")),
                              tabPanel(title = "Metadata",
                                       tags$iframe(style="height:800px; 
                                             width:100%; 
                                             scrolling=yes;
                                             zoom=yes", 
                                             src= "cap_meta.pdf")),
                              tabPanel(title = "Legacy Schema",
                                       tags$iframe(style="height:800px; 
                                             width:100%; 
                                             scrolling=yes;
                                             zoom=yes", 
                                             src= "legacy_survey_data.pdf"))),
                            hr(style = "border-top: 1px solid #000000;"))),
        
        ######## END CAPTURE ##############
        
        ######## VES TAB ################

        # navbarMenu(title = "VES", icon = icon("eye"),
        # 
        #            tabPanel(title = "Data",
        # 
        #                     sidebarLayout(
        # 
        #                       sidebarPanel(
        #                         fluidRow(
        #                           column(12, sliderInput(inputId = "year_ves",
        #                                                  label = "Select Annual Range:",
        #                                                  min = min(years$year), max(years$year),
        #                                                  sep = "",
        #                                                  value = c(max(years$year) - 5, max(years$year)),
        #                                                  step = 1)),
        #                           column(5, pickerInput(inputId = "location_ves",
        #                                                 label = "Select Locations:",
        #                                                 choices = unique(location$location),
        #                                                 options = list(
        #                                                   `actions-box` = TRUE, 
        #                                                   size = 10,
        #                                                   `selected-text-format` = "count > 3"
        #                                                 ), 
        #                                                 multiple = TRUE,
        #                                                 width = "180px")),
        #                           column(5, pickerInput(inputId = "region_ves",
        #                                                 label = "Select Regions:",
        #                                                 choices = unique(region$region),
        #                                                 options = list(
        #                                                   `actions-box` = TRUE, 
        #                                                   size = 10,
        #                                                   `selected-text-format` = "count > 3"
        #                                                 ),
        #                                                 multiple = T,
        #                                                 width = "180px"), offset = 1),
        #                           column(12, pickerInput(inputId = "site_ves",
        #                                                  label = "Select Sites:",
        #                                                  choices = unique(site_list$site),
        #                                                  options = list(
        #                                                    `actions-box` = TRUE, 
        #                                                    size = 10,
        #                                                    `selected-text-format` = "count > 3"
        #                                                  ), 
        #                                                  multiple = TRUE)),
        #                           column(12, hr(style = "border-top: 1px solid #000000;")),
        #                           column(12, pickerInput(inputId = "site_cols_ves",
        #                                                  label = "Select Site Variables of Interest:",
        #                                                  choices = site,
        #                                                  options = list(
        #                                                    `actions-box` = TRUE,
        #                                                    size = 10,
        #                                                    `selected-text-format` = "count > 3"
        #                                                  ),
        #                                                  multiple = TRUE)),
        #                           column(12, pickerInput(inputId = "visit_cols_ves",
        #                                                  label = "Select Visit Variables of Interest:",
        #                                                  choices = visit,
        #                                                  options = list(
        #                                                    `actions-box` = TRUE,
        #                                                    size = 10,
        #                                                    `selected-text-format` = "count > 3"
        #                                                  ),
        #                                                  multiple = TRUE)),
        #                           column(12, pickerInput(inputId = "survey_cols_ves",
        #                                                  label = "Select Survey Variables of Interest:",
        #                                                  choices = survey,
        #                                                  options = list(
        #                                                    `actions-box` = TRUE,
        #                                                    size = 10,
        #                                                    `selected-text-format` = "count > 3"
        #                                                  ),
        #                                                  multiple = TRUE)),
        #                           column(12, pickerInput(inputId = "ves_cols",
        #                                                  label = "Select VES Variables of Interest:",
        #                                                  choices = ves,
        #                                                  options = list(
        #                                                    `actions-box` = TRUE,
        #                                                    size = 10,
        #                                                    `selected-text-format` = "count > 3"
        #                                                  ),
        #                                                  multiple = TRUE)))),
        # 
        #                       mainPanel(
        #                         withSpinner(DT::dataTableOutput("ves_table")),
        #                         headerPanel(""),
        #                         actionButton('ves_download',"Download the data",
        #                                      icon("download"),
        #                                      style="color: #fff; background-color: #337ab7; border-color: black"),
        #                         actionButton('ves_clear', "Clear Selection",
        #                                      icon("trash"),
        #                                      style="color: #fff; background-color: red; border-color: black"))),
        #                     hr(style = "border-top: 1px solid #000000;")),
        # 
        #            tabPanel(title = "Metadata",
        # 
        #                     tabsetPanel(
        #                       tabPanel(title = "Schema",
        #                                tags$iframe(style="height:800px;
        #                                      width:100%;
        #                                      scrolling=yes;
        #                                      zoom=yes",
        #                                      src= "schema.pdf")),
        #                       tabPanel(title = "Legacy Schema",
        #                                tags$iframe(style="height:800px;
        #                                      width:100%;
        #                                      scrolling=yes;
        #                                      zoom=yes",
        #                                      src= "legacy_survey_data.pdf")),
        #                         tabPanel(title = "Metadata",
        #                                  img(src = "yoda.jpeg", height = "400", width = "500"))),
        #                       hr(style = "border-top: 1px solid #000000;"))),

        ####### END VES ##########
        # 
        # ####### Aural Tab ##########
        # 
        # navbarMenu(title = "Aural", icon = icon("music"),
        #            
        #            tabPanel(title = "Data",
        #                     
        #                     sidebarLayout(
        #                       
        #                       sidebarPanel(
        #                         fluidRow(    
        #                           column(12, sliderInput(inputId = "year_a",
        #                                                  label = "Select Annual Range:",
        #                                                  min = min(visit$year), max(visit$year),
        #                                                  sep = "",
        #                                                  value = c(max(visit$year) - 5, max(visit$year)),
        #                                                  step = 1)),
        #                           column(5, pickerInput(inputId = "location_a",
        #                                                 label = "Select Locations:",
        #                                                 choices = unique(location$location),
        #                                                 options = list(
        #                                                   `actions-box` = TRUE, 
        #                                                   size = 10,
        #                                                   `selected-text-format` = "count > 3"
        #                                                 ), 
        #                                                 multiple = TRUE,
        #                                                 width = "180px")),
        #                           column(5, pickerInput(inputId = "region_a",
        #                                                 label = "Select Regions:",
        #                                                 choices = unique(region$region),
        #                                                 options = list(
        #                                                   `actions-box` = TRUE, 
        #                                                   size = 10,
        #                                                   `selected-text-format` = "count > 3"
        #                                                 ),
        #                                                 multiple = T,
        #                                                 width = "180px"), offset = 1),
        #                           column(12, pickerInput(inputId = "site_a",
        #                                                  label = "Select Sites:",
        #                                                  choices = unique(site$site),
        #                                                  options = list(
        #                                                    `actions-box` = TRUE, 
        #                                                    size = 10,
        #                                                    `selected-text-format` = "count > 3"
        #                                                  ), 
        #                                                  multiple = TRUE)),
        #                           column(12, hr(style = "border-top: 1px solid #000000;")),
        #                           column(12, pickerInput(inputId = "site_cols_a",
        #                                                  label = "Select Site Variables of Interest:",
        #                                                  choices = colnames(site),
        #                                                  options = list(
        #                                                    `actions-box` = TRUE, 
        #                                                    size = 10,
        #                                                    `selected-text-format` = "count > 3"
        #                                                  ), 
        #                                                  multiple = TRUE)),
        #                           column(12, pickerInput(inputId = "visit_cols_a",
        #                                                  label = "Select Visit Variables of Interest:",
        #                                                  choices = colnames(visit),
        #                                                  options = list(
        #                                                    `actions-box` = TRUE, 
        #                                                    size = 10,
        #                                                    `selected-text-format` = "count > 3"
        #                                                  ), 
        #                                                  multiple = TRUE)),
        #                           column(12, pickerInput(inputId = "survey_cols_a",
        #                                                  label = "Select Survey Variables of Interest:",
        #                                                  choices = survey,
        #                                                  options = list(
        #                                                    `actions-box` = TRUE, 
        #                                                    size = 10,
        #                                                    `selected-text-format` = "count > 3"
        #                                                  ), 
        #                                                  multiple = TRUE)),
        #                           column(12, pickerInput(inputId = "aural_cols",
        #                                                  label = "Select Aural Variables of Interest:",
        #                                                  choices = aural_cols,
        #                                                  options = list(
        #                                                    `actions-box` = TRUE, 
        #                                                    size = 10,
        #                                                    `selected-text-format` = "count > 3"
        #                                                  ),
        #                                                  multiple = TRUE)))),
        #                       
        #                       mainPanel(withSpinner(DT::dataTableOutput("aural_table")),
        #                                 headerPanel(""),
        #                                 actionButton('aural_download',"Download the data",
        #                                              icon("download"), 
        #                                              style="color: #fff; background-color: #337ab7; border-color: black"),
        #                                 actionButton('aural_clear', "Clear Selection",
        #                                              icon("trash"),
        #                                              style="color: #fff; background-color: red; border-color: black"))),
        #                     hr(style = "border-top: 1px solid #000000;")),
        #            
        #            tabPanel(title = "Metadata",
        #                     
        #                     tabsetPanel(
        #                       tabPanel(title = "Schema",
        #                                tags$iframe(style="height:800px; 
        #                                      width:100%; 
        #                                      scrolling=yes;
        #                                      zoom=yes", 
        #                                      src= "schema.pdf")),
        #                       tabPanel(title = "Legacy Schema",
        #                                tags$iframe(style="height:800px; 
        #                                      width:100%; 
        #                                      scrolling=yes;
        #                                      zoom=yes", 
        #                                      src= "legacy_survey_data.pdf")),
        #                         tabPanel(title = "Metadata",
        #                                  img(src = "yoda.jpeg", height = "400", width = "500"))),
        #                       hr(style = "border-top: 1px solid #000000;"))),
        # 
        # ########## END Aural Tab ##########
        # 
        # ########## HOBO TAB ##########
        # 
        # navbarMenu(title = "Hobo Sensor", icon = icon("thermometer"),
        #            
        #            tabPanel(title = "Data",
        #                     
        #                     sidebarLayout(
        #                       
        #                       sidebarPanel(
        #                         fluidRow(   
        #                           column(12, sliderInput(inputId = "date_hobo",
        #                                                  label = "Select Annual Range:",
        #                                                  min = min(hobo$year), max(hobo$year),
        #                                                  sep = "",
        #                                                  value = c(max(hobo_cols$year) - 3, max(hobo_cols$year)),
        #                                                  step = 1)),
        #                           column(5, pickerInput(inputId = "location_hobo",
        #                                                 label = "Select Locations:",
        #                                                 choices = unique(hobo_location$location),
        #                                                 options = list(
        #                                                   `actions-box` = TRUE, 
        #                                                   size = 10,
        #                                                   `selected-text-format` = "count > 3"
        #                                                 ), 
        #                                                 multiple = TRUE,
        #                                                 width = "180px")),
        #                           column(5, pickerInput(inputId = "region_hobo",
        #                                                 label = "Select Regions:",
        #                                                 choices = unique(hobo_region$region),
        #                                                 options = list(
        #                                                   `actions-box` = TRUE, 
        #                                                   size = 10,
        #                                                   `selected-text-format` = "count > 3"
        #                                                 ),
        #                                                 multiple = T,
        #                                                 width = "180px"), offset = 1),
        #                           column(12, pickerInput(inputId = "site_hobo",
        #                                                  label = "Select Sites:",
        #                                                  choices = unique(hobo_site$site),
        #                                                  options = list(
        #                                                    `actions-box` = TRUE, 
        #                                                    size = 10,
        #                                                    `selected-text-format` = "count > 3"
        #                                                  ), 
        #                                                  multiple = TRUE)),
        #                           column(12, hr(style = "border-top: 1px solid #000000;")),
        #                           column(12, pickerInput(inputId = "hobo_cols",
        #                                                  label = "Select Hobo Sensors Variables of Interest:",
        #                                                  choices = hobo_cols,
        #                                                  options = list(
        #                                                    `actions-box` = TRUE, 
        #                                                    size = 10,
        #                                                    `selected-text-format` = "count > 3"
        #                                                  ), 
        #                                                  multiple = TRUE)),
        #                           column(12, hr(style = "border-top: 1px solid #000000;")),
        #                           column(12,  strong(h5("Please be patient with data rendering and download as 
        #                                         response time can be delayed with this data set."))))),
        #                       
        #                       mainPanel(withSpinner(DT::dataTableOutput("hobo_t")),
        #                                 headerPanel(""),
        #                                 actionButton('hobo_download',"Download the data",
        #                                              icon("download"), 
        #                                              style="color: #fff; background-color: #337ab7; border-color: black"),
        #                                 actionButton('hobo_clear', "Clear Selection",
        #                                              icon("trash"),
        #                                              style="color: #fff; background-color: red; border-color: black"))),
        #                     hr(style = "border-top: 1px solid #000000;")),
        #            
        #            tabPanel(title = "Metadata",
        #                     
        #                     tabsetPanel(
        #                       tabPanel(title = "Schema",
        #                                tags$iframe(style="height:800px; 
        #                                      width:100%; 
        #                                      scrolling=yes;
        #                                      zoom=yes", 
        #                                      src= "hobo.pdf")),
        #                       tabPanel(title = "Metadata"))
        #            )),
        # 
        # 
        # ######## END HOBO Tab ##########
        # 
        # ######## eDNA TAB ############
        # 
        # tabPanel(title = "eDNA", icon = icon("dna"),
        #          
        #          sidebarLayout(
        #            
        #            sidebarPanel(
        #              
        #            ),
        #            mainPanel(img(src = "homer.jpeg", height = "600", width = "700")
        #            )
        #            
        #          )),
        # 
        # ######### END eDNA Tab #########    
        # 
        # ######### Audio tab ############3
        # navbarMenu(title = "Audio", icon = icon("microphone"),
        #            
        #            tabPanel(title = "Data",
        #                     
        #                     sidebarLayout(
        #                       
        #                       sidebarPanel(
        #                         fluidRow(   
        #                           # column(12, sliderInput(inputId = "date_audio",
        #                           #                        label = "Select Annual Range:",
        #                           #                        min = min(as.Date(audio_visit$date_of_deployment, "%Y-%m-%d")), 
        #                           #                        max = max(as.Date(audio_visit$date_of_deployment, "%Y-%m-%d")),
        #                           #                        sep = "",
        #                           #                        value = c(max(as.Date(audio_visit$date_of_deployment, "%Y-%m-%d")) - 
        #                           #                                    15, max(as.Date(audio_visit$date_of_deployment, "%Y-%m-%d"))),
        #                           #                        
        #                           #                        timeFormat = "%Y-%m-%d")),
        #                           column(5, pickerInput(inputId = "location_audio",
        #                                                 label = "Select Locations:",
        #                                                 choices = unique(audio_location$location),
        #                                                 options = list(
        #                                                   `actions-box` = TRUE, 
        #                                                   size = 10,
        #                                                   `selected-text-format` = "count > 3"
        #                                                 ), 
        #                                                 multiple = TRUE,
        #                                                 width = "180px")),
        #                           column(5, pickerInput(inputId = "region_audio",
        #                                                 label = "Select Regions:",
        #                                                 choices = unique(audio_region$region),
        #                                                 options = list(
        #                                                   `actions-box` = TRUE, 
        #                                                   size = 10,
        #                                                   `selected-text-format` = "count > 3"
        #                                                 ),
        #                                                 multiple = T,
        #                                                 width = "180px"), offset = 1),
        #                           column(12, pickerInput(inputId = "site_audio",
        #                                                  label = "Select Sites:",
        #                                                  choices = unique(audio_site$site),
        #                                                  options = list(
        #                                                    `actions-box` = TRUE, 
        #                                                    size = 10,
        #                                                    `selected-text-format` = "count > 3"
        #                                                  ), 
        #                                                  multiple = TRUE)),
        #                           column(12, hr(style = "border-top: 1px solid #000000;")),
        #                           column(12, pickerInput(inputId = "audio_cols",
        #                                                  label = "Select Hobo Sensors Variables of Interest:",
        #                                                  choices = audio_cols,
        #                                                  options = list(
        #                                                    `actions-box` = TRUE, 
        #                                                    size = 10,
        #                                                    `selected-text-format` = "count > 3"
        #                                                  ), 
        #                                                  multiple = TRUE)))),
        #                       
        #                       mainPanel(withSpinner(DT::dataTableOutput("audio_t")),
        #                                 headerPanel(""),
        #                                 actionButton('audio_download',"Download the data",
        #                                              icon("download"), 
        #                                              style="color: #fff; background-color: #337ab7; border-color: black"),
        #                                 actionButton('audio_clear', "Clear Selection",
        #                                              icon("trash"),
        #                                              style="color: #fff; background-color: red; border-color: black"))),
        #                     hr(style = "border-top: 1px solid #000000;")),
        #            
        #            tabPanel(title = "Metadata",
        #                     
        #                     tabsetPanel(
        #                       tabPanel(title = "Schema",
        #                                tags$iframe(style="height:800px; 
        #                                      width:100%; 
        #                                      scrolling=yes;
        #                                      zoom=yes", 
        #                                      src= "audio.pdf")),
        #                       tabPanel(title = "Metadata"))
        #            ))
        # 
        ########### END Audio #########
                         
  )
 )
)
