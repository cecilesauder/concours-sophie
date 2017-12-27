library(shiny)
library(shinydashboard)
library(ggiraph)


dashboardPage(
  skin = "purple",
  
  dashboardHeader(title = "Vote for Lexie"),
  dashboardSidebar(disable = TRUE),
  dashboardBody(
    fluidRow(
      box(
        title = "Results : ",
        status = "info",
        solidHeader = TRUE,
        width = 4,
        valueBoxOutput("numVotes",  width = 12),
        valueBoxOutput("numLexie",  width = 12),
        tags$img(src = "téléchargement.gif"),
        tags$img(src = "sophiehexa.png")
      ),
      box(
        status = "info",
        width = 8,
        ggiraphOutput("plot")
        
      )
    ),
    fluidRow(
      uiOutput("frame")

    )


  )
)

