library(shiny)
library(tidyverse)
library(rvest)
library(ggiraph)


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  df <- reactive({
    concours <-
      read_html( "http://www3.jeuconcours.fr/leplusbeaubebesophielagirafe/photos.php" )
    
    vote_for_lexie_html <-"http://www3.jeuconcours.fr/leplusbeaubebesophielagirafe/photos.php?photo=5a253562179c7357561081&v=2"
    
    lexie <- read_html(vote_for_lexie_html)
    
    votes_lexie <- 
      html_nodes(lexie, ".bottom-box-vote span.votes") %>%
      str_extract( "[[:digit:]]+" ) %>%
      as.numeric()
    
    votes <- 
      html_nodes(concours, ".enfants span.votes") %>%
      str_extract( "[[:digit:]]+" ) %>%
      as.numeric()
    
    nb_enfants <- length(votes)
    
    df <- 
      data.frame(votes = votes) %>% 
      mutate(numKid = paste0("Kid", 1:nb_enfants),
             col = rep("black", nb_enfants))
    df <- df %>%
      mutate(classement = as.numeric(row.names(df)))
    
    
    df$numKid[votes == votes_lexie] <- "Lexie"
    df$col[votes == votes_lexie] <- "red"
    df$col <- as.factor(df$col)
    
    df
  })
  
  output$numVotes <- renderValueBox({
    df <- df()
    votes_lexie <- 
      df %>%
      filter(numKid == "Lexie") %>%
      select(votes)
    valueBox(votes_lexie, "Votes", color = "maroon", icon = icon("check", lib = "glyphicon"), width = 12)
  })
  
  output$numLexie <- renderValueBox({
    df <- df()
    classement_lexie <-
      df %>%
        filter(numKid == "Lexie") %>%
        select(classement)
    valueBox(paste0(classement_lexie, "/", max(df$classement)) , "Classement", color = "maroon",
             icon = icon("stats", lib = "glyphicon"), width = 12)
      
  })
   
  output$plot <- renderggiraph({
    df <- df()
    
    myPalette <- c('#999999','#FF00FF')
    names(myPalette) <- levels(df$col)
    
    gg <- df %>%
      ggplot(aes(x= reorder(numKid, -votes), y=votes , fill = col)) + 
      theme(axis.text.x = element_text(face="bold", size = 12, color = myPalette[df$col])) +
      scale_fill_manual(values=c('#999999','#FF00FF')) +
      xlab("Kids") +
      geom_bar_interactive(aes(tooltip = votes, data_id = numKid),stat="identity") +
      guides(fill = FALSE) 

    ggiraph(code = print(gg), hover_css = "fill-opacity:.6;cursor:pointer;",
            width = 0.8, width_svg = 6,
            height_svg = 5, selection_type = "none")

  })
  
  
})
