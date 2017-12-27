library(shiny)
library(shinydashboard)
library(ggiraph)


dashboardPage(
  skin = "purple",
  
  dashboardHeader(title = "Concours Sophie"),
  dashboardSidebar(disable = TRUE),
  dashboardBody(
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "style.css")
    ),
    fluidRow(
      box(
        title = "Resultats : ",
        status = "info",
        solidHeader = TRUE,
        width = 4,
        valueBoxOutput("numVotes",  width = 12),
        valueBoxOutput("numLexie",  width = 12),
      
      box(
        width = 12,
        tags$p(align="center",
               tags$a(href= "http://www3.jeuconcours.fr/leplusbeaubebesophielagirafe/photos.php?photo=5a253562179c7357561081&v=2",
                      target="_blank",
                      class= "button",
                      "JE VOTE !"))
        
      ),
      box(
        width = 12,
        tags$p(align="center",
               tags$img(src = "téléchargement.gif"),
               tags$img(src = "sophiehexa.png")
               )
      ))
      ,
      box(
        status = "info",
        width = 8,
        ggiraphOutput("plot")
        
      )
    )

  )
)

