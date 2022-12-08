source(here("Database_FormsApp", "global.R"))


# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("RIBBiTR Database Forms"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            pickerInput(inputId = "location",
                        label = "Select Locations:",
                        choices = unique(location$location),
                        multiple = T),
            pickerInput(inputId = "region",
                        label = "Select Region:",
                        choices = unique_regions,
                        multiple = T)
        ),

        # Show a plot of the generated distribution
        mainPanel(
            withSpinner(DT::dataTableOutput("loc"))
        )
    )
))
