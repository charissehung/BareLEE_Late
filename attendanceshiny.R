library(shiny)
library(shinythemes)
library(tidyverse)
source("./attendance.R")

# Define UI
ui <- fluidPage(theme = shinytheme("cerulean"),
                navbarPage(
                  "Automated Attendance",
                  tabPanel("Attendance",
                           sidebarPanel(
                             tags$h3("User Input:"),
                             tags$h4("Input the late cutoff time"),
                             textInput("txt1", "Any student who joined the Zoom after this time will be marked late. (military time, e.g. 14:00, 09:00)"),
                             tags$h4("Input the minimum duration in minutes for a student to be present"),
                             textInput("txt2", "Any student who was in the Zoom for less than this amount of time will be marked absent. (in minutes)")
                           ),
                           sidebarPanel(
                             tags$h3("Attendance File"),
                             tags$h4("Select the list of all students"),
                             fileInput("file1", "Choose CSV File", accept = ".csv"),
                             checkboxInput("header1", "Header", TRUE)
                           ), # sidebarPanel
                           sidebarPanel(
                             tags$h3("Zoom File"),
                             tags$h4("Select the Zoom Usage Report file"),
                             fileInput("file2", "Choose CSV File", accept = ".csv"),
                             checkboxInput("header2", "Header", TRUE)
                           )
                  )
                ) 
) # fluidPage
# Define server function  
server <- function(input, output) {
  output$contents <- renderTable({
    file1 <- input$file1
    ext1 <- tools::file_ext(file1$datapath)
    file2 <- input$file2
    ext2 <- tools::file_ext(file2$datapath)
    req(file1)
    validate(need(ext1 == "csv", "Please upload a csv file"))
    req(file2)
    validate(need(ext2 == "csv", "Please upload a csv file"))
    late_time <- input$txt1
    absent_time <- as.integer(input$txt2)
    att_table <- read_csv(file1$datapath, col_names = input$header1)
    zoom_table <- read_csv(file2$datapath, col_names = input$header2)
    attendance(att_table, zoom_table, late_time, absent_time)
  })
}
# Create Shiny object
shinyApp(ui = ui, server = server)
