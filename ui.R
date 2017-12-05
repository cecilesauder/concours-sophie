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
        valueBoxOutput("numLexie",  width = 12)
      ),
      box(
        status = "info",
        width = 4,
        ggiraphOutput("plot")
        
      ),
      box(
        width = 3,
        tags$img(src = "téléchargement.gif"),
        tags$img(src = "sophiehexa.png")
      )
    ),
    fluidRow(
      tags$iframe(src = "http://www3.jeuconcours.fr/leplusbeaubebesophielagirafe/photos.php?photo=5a253562179c7357561081&v=2",
                  height = 800, width = 1400)
    )


    #uiOutput("Site")
  )
)

