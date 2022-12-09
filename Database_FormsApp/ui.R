source(here("Database_FormsApp", "global.R"))


# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("RIBBiTR Database Forms"),

    # Sidebar with a slider input for number of bins
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
                        multiple = T),
            pickerInput(inputId = "region",
                        label = "Select Regions:",
                        choices = unique(region$region),
                        multiple = T),
            pickerInput(inputId = "site",
                        label = "Select Sites:",
                        choices = unique(site$site),
                        multiple = T),
          prettyCheckboxGroup(inputId = "site_cols",
                           label = "Select Site Variables of Interest:",
                           choices = colnames(site),
                           inline = T),
          prettyCheckboxGroup(inputId = "visit_cols",
                         label = "Select Visit Variables of Interest:",
                         choices = colnames(visit),
                         inline = T),
          prettyCheckboxGroup(inputId = "survey_cols",
                              label = "Select Survey Variables of Interest:",
                              choices = colnames(survey),
                              inline = T)
        ),

        # Show a plot of the generated distribution
        mainPanel(
            withSpinner(DT::dataTableOutput("loc"))
        )
    )
  )
)
