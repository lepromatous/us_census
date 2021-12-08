library(shiny)
library(shinydashboard)
library(DT)
library(devtools)
library(lubridate)
library(shinyWidgets)

source("helpers.R")




#devtools::source_url("https://raw.githubusercontent.com/lepromatous/fluviewR/main/fluview_functions_2.R")


ui<-dashboardPage( skin = "purple",

                   dashboardHeader(title = "US Census Bureau Age-Specific Population Estimates ", titleWidth = '100%'),
                   
                   dashboardSidebar(width = 375,
                                    sidebarMenu(h4("Select a tab for analysis"),
                                                br(),
                                                menuItem("Estimates of Population Size by Age", tabName = "age"),
                                               
                                                br(),
                                                hr(),
                                                
                                                h4("Data Sources:"),
                                                tags$ol(
                                                  tags$li(
                                                    tags$a(href="https://www2.census.gov/programs-surveys/popproj/datasets/2017/2017-popproj/np2017_d1_mid.csv",
                                                           "US Census Bureau")),
                                                  ), # close ol
                                                
                                                hr(),
                                                
                                                h4("Notes:"),
                                                tags$ul(
                                                  tags$li("All estimates use main series estimates")
                                                ),
                                                hr(),
                                                
                                                h4("Created by:"), 
                                                tags$ul(
                                                  tags$li("Timothy Wiemken, PhD"), 
                                                  tags$li("Farid Khan, MPH"),
                                                  tags$li("John McLaughlin, PhD")
                                                )
                                                
                                    )), # close sidebar menu and dashsidebar
                   
                   dashboardBody(
                     tags$head(tags$style(HTML('
                                          .main-header .logo {
                                          font-family: "Georgia", Times, "Times New Roman", serif;
                                          font-weight: bold;
                                          font-size: 20px;
                                          }'
                     ))), ### close tags
                     
                     ##########################################################################################################################
                     
                     tabItems(
                       
                       ##########################################################################################################################
                       tabItem(tabName = "age",
                               
                               ############################################
                               ### SELECTORS
                               ############################################
                               
                               selectizeInput(inputId = "year_selector", 
                                              label = "Select Year",
                                              choices = unique(census$year), 
                                              selected = lubridate::year(Sys.Date()),
                                              multiple = T),
                               chooseSliderSkin("Modern"),
                               sliderInput(inputId = "age_selector",
                                           label = "Select Age(s)",
                                              min = 0,
                                              max = 100, 
                                              value=c(0,100),
                                              step=1),
                               
                       
                               ############################################
                               ### MAIN OUTPUTS
                               ############################################
                               uiOutput("age_table")
                               
                       )## close tab item age
                     ),# close tab items
                   ), # close dashboard body
                )# close dashboard page/ui

#------------------------------ End UI ------------------------------#











#------------------------------BEGIN SERVER --------------------------#

server <- function(input, output, session) {
  
  output$age_table <-renderUI(
    census_calc(agez=seq(as.numeric(input$age_selector)[1], as.numeric(input$age_selector)[2]), yearz=as.numeric(input$year_selector))
  )
  
  
}
# Run the application 
shinyApp(ui = ui, server = server)
