library(shiny)
library(tidyverse)
library(rvest)
library(ggiraph)
library(magrittr)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  df <- reactive({
    concours <-
      read_html( "http://www3.jeuconcours.fr/leplusbeaubebesophielagirafe/photos.php" )
    
    #recupère les identifiants des differentes photos du concours
    id <- html_nodes(concours, ".enfants100 li a") %>% 
      html_attr("href") %>%
      str_replace( ".*/(.*).jpg", "\\1")#remplace par ce que je capture entre les parenthèses qui est \\1
    
    id_lexie <- "5a253562179c7357561081"

    votes <- 
      html_nodes(concours, ".enfants span.votes") %>%
      str_extract( "[[:digit:]]+" ) %>%
      as.numeric()
    
    nb_enfants <- length(votes)
    
    df <- 
      data.frame(votes = votes, id = id) %>% 
      mutate(numKid = 1:nb_enfants,
             nameKid = 1:nb_enfants,
             col = rep("black", nb_enfants)) %>%
      rownames_to_column("classement") %>%
      mutate(classement = as.numeric(classement))
    
    
    df$nameKid[id == id_lexie] <- "Lexie"
    df$col[id == id_lexie] <- "red"
    df$col <- as.factor(df$col)
    
    invalidateLater(8000)
    
    df
  })
  
  
  output$numVotes <- renderValueBox({
    df <- df()
    votes_lexie <- 
      df %>%
      filter(nameKid == "Lexie") %>%
      pull(votes)
    valueBox(votes_lexie, "Votes", color = "maroon", icon = icon("check", lib = "glyphicon"), width = 12)
  })
  
  output$numLexie <- renderValueBox({
    df <- df()
    classement_lexie <-
      df %>%
        filter(nameKid == "Lexie") %>%
        pull(classement)
    
    valueBox(paste0(classement_lexie, "/", max(df$classement)) , "Classement", color = "maroon",
             icon = icon("stats", lib = "glyphicon"), width = 12)
      
  })
   
  output$plot <- renderggiraph({
    df <- df()
    
    myPalette <- c('#999999','#FF00FF')
    names(myPalette) <- levels(df$col)
    df_text <- data.frame ( 
      numKid = df %>% filter(nameKid == "Lexie") %>% pull(numKid),
      votes = df %>% filter(nameKid == "Lexie") %>% pull(votes) %>% add(100),
      col = "black" )
    
    gg <- df %>% 
      filter(classement < 21) %>%
      ggplot(aes(x = numKid, y = votes , fill = col)) + 
      theme_light() +
#      theme(axis.text.y = element_text(face="bold", size = 12, color = myPalette[df$col])) +
      scale_fill_manual(values=c('#999999','#FF00FF')) +
      xlab("bébés") +
      ggtitle("Les 10 premiers du concours sont pré-selectionnés") +
      geom_bar_interactive(aes(tooltip = votes, data_id = nameKid),stat="identity") +
      guides(fill = FALSE) +
      coord_flip() + 
      scale_x_reverse() +
      geom_vline(xintercept = 10.5, linetype = 2) +
      geom_text(data = df_text, mapping = aes(label = "Lexie"))
      

    ggiraph(code = print(gg), hover_css = "fill-opacity:.6;cursor:pointer;",
            width = 0.8, width_svg = 6,
            height_svg = 4, selection_type = "none")

  })
  
  
  
})
