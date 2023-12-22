source(("global.R"), local = T)
source(("creds.R"), local = T)



ui <- secure_app(head_auth = tags$script(inactivity), 
        
        fluidPage(
          
          # Styling 
          tags$head(tags$style(HTML(".shiny-output-error-validation 
                                    {color: #ff0000;font-weight: bold;}"))),
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
                             
                             column(11, tags$ul(p(tags$ul(tags$li(mailtoR(email = "jamie.voyles@gmail.com",
                                                                text = "Panama Data: Jamie Voyles"))),
                                                  tags$ul(tags$li(mailtoR(email = "cori.zawacki@pitt.edu",
                                                                text = "SERDP Survey Data: Cori Richards-Zawacki"))),
                                                  tags$ul(tags$li(mailtoR(email = "cori.zawacki@pitt.edu",
                                                                 text = "Pennsylvania Survey Data: Cori Richards-Zawacki"))),
                                                  tags$ul(tags$li(mailtoR(email = "roland.knapp@ucsb.edu",
                                                                 text = "Sierra Nevada Survey Data: Roland Knapp"))), 
                                                  tags$ul(tags$li(mailtoR(email = "guibecker@psu.edu",
                                                                  text = "Brazil Survey Data: Gui Becker"))),
                                                  tags$ul(tags$li(mailtoR(email = "louise.rollins-smith@vanderbilt.edu",
                                                                  text = "AMP: Louise Rollins-Smith"))),
                                                  tags$ul(tags$li(mailtoR(email = "dwoodhams@gmail.com",
                                                                  text = "Microbiome: Doug Woodhams"))),
                                                  tags$ul(tags$li(mailtoR(email = "rosenblum@berkeley.edu",
                                                                  text = "Genetic: Bree Rosenblum"))),
                                                  tags$ul(tags$li(mailtoR(email = "louise.rollins-smith@vanderbilt.edu",
                                                                  text = "Antibody: Louise Rollins-Smith"))),
                                                  tags$ul(tags$li(mailtoR(email = "dwoodhams@gmail.com",
                                                                  text = "Bacterial: Doug Woodhams"))),
                                                  tags$ul(tags$li(mailtoR(email = "dwoodhams@gmail.com",
                                                                  text = "Mucosome: Doug Woodhams"))),
                                                  tags$ul(tags$li(mailtoR(email = "mohmer@olemiss.edu",
                                                                  text = "HOBO: Michel Ohmer"))),
                                                  tags$ul(tags$li("For assistance in developing queries, please contact:", mailtoR(email = "eisaguirre@ucsb.edu",
                                                                  text = "Data Manager: Jake Eisaguirre"))))))),
                                    
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
                                  # column(12, pickerInput(inputId = 'amp_cols',
                                  #                        label = "Select AMP Variables of Interest",
                                  #                        choices = serdp_amp,
                                  #                        options = list(
                                  #                          `actions-box` = TRUE, 
                                  #                          size = 10,
                                  #                          `selected-text-format` = "count > 3"
                                  #                        ), 
                                  #                        multiple = TRUE)),
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

        navbarMenu(title = "VES", icon = icon("eye"),

                   tabPanel(title = "Data",

                            sidebarLayout(

                              sidebarPanel(
                                fluidRow(
                                  column(12, sliderInput(inputId = "year_ves",
                                                         label = "Select Annual Range:",
                                                         min = min(years$year), max(years$year),
                                                         sep = "",
                                                         value = c(max(years$year) - 5, max(years$year)),
                                                         step = 1)),
                                  column(5, pickerInput(inputId = "location_ves",
                                                        label = "Select Locations:",
                                                        choices = "",
                                                        options = list(
                                                          `actions-box` = TRUE,
                                                          size = 10,
                                                          `selected-text-format` = "count > 3"
                                                        ),
                                                        multiple = TRUE,
                                                        width = "180px")),
                                  column(5, pickerInput(inputId = "region_ves",
                                                        label = "Select Regions:",
                                                        choices = "",
                                                        options = list(
                                                          `actions-box` = TRUE,
                                                          size = 10,
                                                          `selected-text-format` = "count > 3"
                                                        ),
                                                        multiple = T,
                                                        width = "180px"), offset = 1),
                                  column(12, pickerInput(inputId = "site_ves",
                                                         label = "Select Sites:",
                                                         choices = "",
                                                         options = list(
                                                           `actions-box` = TRUE,
                                                           size = 10,
                                                           `selected-text-format` = "count > 3"
                                                         ),
                                                         multiple = TRUE)),
                                  column(12, hr(style = "border-top: 1px solid #000000;")),
                                  column(12, pickerInput(inputId = "ves_cols",
                                                         label = "Select Variables of Interest:",
                                                         choices = "",
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
                                             style="color: #fff; background-color: #337ab7; border-color: black"),
                                actionButton('ves_clear', "Clear Selection",
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
                              tabPanel(title = "Legacy Schema",
                                       tags$iframe(style="height:800px;
                                             width:100%;
                                             scrolling=yes;
                                             zoom=yes",
                                             src= "legacy_survey_data.pdf")),
                                tabPanel(title = "Metadata",
                                         img(src = "yoda.jpeg", height = "400", width = "500"))),
                              hr(style = "border-top: 1px solid #000000;"))),

        ####### END VES ##########

        ####### Aural Tab ##########

        navbarMenu(title = "Aural", icon = icon("music"),

                   tabPanel(title = "Data",

                            sidebarLayout(

                              sidebarPanel(
                                fluidRow(
                                  column(12, sliderInput(inputId = "year_a",
                                                         label = "Select Annual Range:",
                                                         min = min(years$year), max(years$year),
                                                         sep = "",
                                                         value = c(max(years$year) - 5, max(years$year)),
                                                         step = 1)),
                                  column(5, pickerInput(inputId = "location_a",
                                                        label = "Select Locations:",
                                                        choices = "",
                                                        options = list(
                                                          `actions-box` = TRUE,
                                                          size = 10,
                                                          `selected-text-format` = "count > 3"
                                                        ),
                                                        multiple = TRUE,
                                                        width = "180px")),
                                  column(5, pickerInput(inputId = "region_a",
                                                        label = "Select Regions:",
                                                        choices = "",
                                                        options = list(
                                                          `actions-box` = TRUE,
                                                          size = 10,
                                                          `selected-text-format` = "count > 3"
                                                        ),
                                                        multiple = T,
                                                        width = "180px"), offset = 1),
                                  column(12, pickerInput(inputId = "site_a",
                                                         label = "Select Sites:",
                                                         choices = "",
                                                         options = list(
                                                           `actions-box` = TRUE,
                                                           size = 10,
                                                           `selected-text-format` = "count > 3"
                                                         ),
                                                         multiple = TRUE)),
                                  column(12, hr(style = "border-top: 1px solid #000000;")),
                                  column(12, pickerInput(inputId = "aural_cols",
                                                         label = "Select Aural Variables of Interest:",
                                                         choices = "",
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
                                                     style="color: #fff; background-color: #337ab7; border-color: black"),
                                        actionButton('aural_clear', "Clear Selection",
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
                              tabPanel(title = "Legacy Schema",
                                       tags$iframe(style="height:800px;
                                             width:100%;
                                             scrolling=yes;
                                             zoom=yes",
                                             src= "legacy_survey_data.pdf")),
                                tabPanel(title = "Metadata",
                                         img(src = "yoda.jpeg", height = "400", width = "500"))),
                              hr(style = "border-top: 1px solid #000000;"))),

        ########## END Aural Tab ##########

        ########## HOBO TAB ##########

        navbarMenu(title = "Hobo Sensor", icon = icon("thermometer"),

                   tabPanel(title = "Data",

                            sidebarLayout(

                              sidebarPanel(
                                fluidRow(
                                  column(12, sliderInput(inputId = "date_hobo",
                                                         label = "Select Annual Range:",
                                                         min = min(hobo_years$year), max(hobo_years$year),
                                                         sep = "",
                                                         value = c(max(hobo_years$year) - 3, max(hobo_years$year)),
                                                         step = 1)),
                                  column(5, pickerInput(inputId = "location_hobo",
                                                        label = "Select Locations:",
                                                        choices = "",
                                                        options = list(
                                                          `actions-box` = TRUE,
                                                          size = 10,
                                                          `selected-text-format` = "count > 3"
                                                        ),
                                                        multiple = TRUE,
                                                        width = "180px")),
                                  column(5, pickerInput(inputId = "region_hobo",
                                                        label = "Select Regions:",
                                                        choices = "",
                                                        options = list(
                                                          `actions-box` = TRUE,
                                                          size = 10,
                                                          `selected-text-format` = "count > 3"
                                                        ),
                                                        multiple = T,
                                                        width = "180px"), offset = 1),
                                  column(12, pickerInput(inputId = "site_hobo",
                                                         label = "Select Sites:",
                                                         choices = "",
                                                         options = list(
                                                           `actions-box` = TRUE,
                                                           size = 10,
                                                           `selected-text-format` = "count > 3"
                                                         ),
                                                         multiple = TRUE)),
                                  column(12, hr(style = "border-top: 1px solid #000000;")),
                                  column(12, pickerInput(inputId = "hobo_cols",
                                                         label = "Select Hobo Sensors Variables of Interest:",
                                                         choices = "",
                                                         options = list(
                                                           `actions-box` = TRUE,
                                                           size = 10,
                                                           `selected-text-format` = "count > 3"
                                                         ),
                                                         multiple = TRUE)),
                                  column(12, hr(style = "border-top: 1px solid #000000;")),
                                  column(12,  strong(h5("Please be patient with data rendering and download as
                                                response time can be delayed with this data set."))))),

                              mainPanel(withSpinner(DT::dataTableOutput("hobo_t")),
                                        headerPanel(""),
                                        actionButton('hobo_download',"Download the data",
                                                     icon("download"),
                                                     style="color: #fff; background-color: #337ab7; border-color: black"),
                                        actionButton('hobo_clear', "Clear Selection",
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
                                             src= "hobo.pdf")),
                              tabPanel(title = "Metadata"))
                   )),


        ######## END HOBO Tab ##########

        ######## eDNA TAB ############

        navbarMenu(title = "eDNA", icon = icon("dna"),
                   
                   tabPanel(title = "Data",
                            
                            sidebarLayout(
                              
                              sidebarPanel(
                                fluidRow(
                                  column(5, pickerInput(inputId = "year_edna",
                                                         label = "Select Annual Range:",
                                                         choices = edna_years$year,
                                                         options = list(
                                                           `actions-box` = TRUE,
                                                           size = 10,
                                                           `selected-text-format` = "count > 3"
                                                         ),
                                                         multiple = TRUE,
                                                         width = "180px")),
                                  column(5, pickerInput(inputId = "location_edna",
                                                        label = "Select Locations:",
                                                        choices = "",
                                                        options = list(
                                                          `actions-box` = TRUE,
                                                          size = 10,
                                                          `selected-text-format` = "count > 3"
                                                        ),
                                                        multiple = TRUE,
                                                        width = "180px")),
                                  column(4, pickerInput(inputId = "region_edna",
                                                        label = "Select Regions:",
                                                        choices = "",
                                                        options = list(
                                                          `actions-box` = TRUE,
                                                          size = 10,
                                                          `selected-text-format` = "count > 3"
                                                        ),
                                                        multiple = T,
                                                        width = "180px")),
                                  column(5, pickerInput(inputId = "site_edna",
                                                        label = "Select Sites:",
                                                        choices = "",
                                                        options = list(
                                                          `actions-box` = TRUE,
                                                          size = 10,
                                                          `selected-text-format` = "count > 3"
                                                        ),
                                                        multiple = TRUE), offset = 1),
                                  column(12, hr(style = "border-top: 1px solid #000000;")),
                                  column(12, pickerInput(inputId = "edna_cols",
                                                         label = "Select eDNA Variables of Interest:",
                                                         choices = "",
                                                         options = list(
                                                           `actions-box` = TRUE,
                                                           size = 10,
                                                           `selected-text-format` = "count > 3"
                                                         ),
                                                         multiple = TRUE)))),
                              
                              mainPanel(withSpinner(DT::dataTableOutput("edna_t")),
                                        headerPanel(""),
                                        actionButton('edna_download',"Download the data",
                                                     icon("download"),
                                                     style="color: #fff; background-color: #337ab7; border-color: black"),
                                        actionButton('edna_clear', "Clear Selection",
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
                                             src= "eDNA.pdf")),
                              tabPanel(title = "Metadata"))
                   )),

        ######### END eDNA Tab #########

        ######### Audio tab ############3
        navbarMenu(title = "Audio", icon = icon("microphone"),

                   tabPanel(title = "Data",

                            sidebarLayout(

                              sidebarPanel(
                                fluidRow(
                                  column(5, pickerInput(inputId = "year_audio",
                                                        label = "Select Years:",
                                                        choices = audio_years$year,
                                                        options = list(
                                                          `actions-box` = TRUE,
                                                          size = 10,
                                                          `selected-text-format` = "count > 3"
                                                        ),
                                                        multiple = TRUE,
                                                        width = "180px")),
                                  column(5, pickerInput(inputId = "location_audio",
                                                        label = "Select Locations:",
                                                        choices = "",
                                                        options = list(
                                                          `actions-box` = TRUE,
                                                          size = 10,
                                                          `selected-text-format` = "count > 3"
                                                        ),
                                                        multiple = TRUE,
                                                        width = "180px")),
                                  column(4, pickerInput(inputId = "region_audio",
                                                        label = "Select Regions:",
                                                        choices = "",
                                                        options = list(
                                                          `actions-box` = TRUE,
                                                          size = 10,
                                                          `selected-text-format` = "count > 3"
                                                        ),
                                                        multiple = T,
                                                        width = "180px")),
                                  column(5, pickerInput(inputId = "site_audio",
                                                         label = "Select Sites:",
                                                         choices = "",
                                                         options = list(
                                                           `actions-box` = TRUE,
                                                           size = 10,
                                                           `selected-text-format` = "count > 3"
                                                         ),
                                                         multiple = TRUE), offset = 1),
                                  column(12, hr(style = "border-top: 1px solid #000000;")),
                                  column(12, pickerInput(inputId = "audio_cols",
                                                         label = "Select Audio Variables of Interest:",
                                                         choices = "",
                                                         options = list(
                                                           `actions-box` = TRUE,
                                                           size = 10,
                                                           `selected-text-format` = "count > 3"
                                                         ),
                                                         multiple = TRUE)))),

                              mainPanel(withSpinner(DT::dataTableOutput("audio_t")),
                                        headerPanel(""),
                                        actionButton('audio_download',"Download the data",
                                                     icon("download"),
                                                     style="color: #fff; background-color: #337ab7; border-color: black"),
                                        actionButton('audio_clear', "Clear Selection",
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
                                             src= "audio.pdf")),
                              tabPanel(title = "Metadata"))
                   )),

        ########### END Audio #########
        
        ########## Data Exploration Tab ############
        
        navbarMenu(title = "Data Exploration", icon = icon("compass"),
                   
                   tabPanel(title = "Site Location Explorer",
                            
                            sidebarLayout(
                              
                              sidebarPanel(
                                fluidRow(
                                  column(12, sliderInput(inputId = "year_map",
                                                         label = "Select Annual Range:",
                                                         min = min(years$year), max(years$year),
                                                         sep = "",
                                                         value = c(max(years$year) - 10, max(years$year)),
                                                         step = 1)),
                                  column(5, pickerInput(inputId = "location_map",
                                                        label = "Select Locations:",
                                                        choices = '',
                                                        selected = '',
                                                        options = list(
                                                          `actions-box` = TRUE, 
                                                          size = 10,
                                                          `selected-text-format` = "count > 3"
                                                        ), 
                                                        multiple = TRUE,
                                                        width = "180px")),
                                  column(5, pickerInput(inputId = "region_map",
                                                        label = "Select Regions:",
                                                        choices = '',
                                                        selected = '',
                                                        options = list(
                                                          `actions-box` = TRUE, 
                                                          size = 10,
                                                          `selected-text-format` = "count > 3"
                                                        ),
                                                        multiple = T,
                                                        width = "180px"), offset = 1),
                                  column(12, pickerInput(inputId = "site_map",
                                                         label = "Select Sites:",
                                                         choices = '',
                                                         selected = '',
                                                         options = list(
                                                           `actions-box` = TRUE,
                                                           size = 10,
                                                           `selected-text-format` = "count > 3",
                                                           `live-search`=TRUE
                                                         ),
                                                         multiple = TRUE)),
                                  column(12, hr(style = "border-top: 1px solid #000000;")),
                                  column(8,  strong(h5("Please be patient as map rendering can be delayed. 
                                                       Click on site of interest to display data"))),
                                  actionButton('cap_map_clear', "Clear Selection",
                                               icon("trash"),
                                               style="color: #fff; background-color: red; border-color: black")),
                                hr(style = "border-top: 1px solid #000000;"),
                                headerPanel(""),
                                headerPanel(""),
                                column(12, plotOutput("swab_figure", width = 475, height = 700))),
                              
                              
                              # Show a plot of the generated distribution
                              mainPanel(
                                tableOutput("table"),
                                withSpinner(leafletOutput(outputId = "site_map", width = 1000, height = 500)),
                                headerPanel(""),
                                DT::dataTableOutput("swab_table"),
                                headerPanel(""),
                                DT::dataTableOutput("map_table"))),
                            hr(style = "border-top: 1px solid #000000;"))),
  
                                             
  )
 )
)
