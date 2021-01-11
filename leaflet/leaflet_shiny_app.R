library(shiny)
library(leaflet)
library(tidyverse)
library(sf)

birds <- st_read("~/github/leaflet-tutorial/ds78.shp") %>% 
    filter(LONGITUDE != 0.0000) %>%  # removing a few data points that were missing lat/long
    filter(REGION == "Southwest")

ui <- fluidPage(
    
    # title
    titlePanel("Leaflet Map with Shiny"),
    
    sidebarLayout(
        sidebarPanel(
            selectInput("score", 
                        h3("Choose Score"), 
                        choices = list("1" = 1, "2" = 2,"3" = 3, "4" = 4, "5" = 5), 
                        selected = 1)
            ),
        mainPanel(
            leafletOutput("bird_map")
            )
        )
    )


server <- function(input, output) {
    
    data_subset <- reactive({
        birds %>% 
            dplyr::filter(birds$SCORE == input$score)
        })
    
    output$bird_map <- renderLeaflet({
        leaflet(data_subset()) %>% 
            addTiles() %>% 
            addMarkers(lat = data_subset()$LATITUDE, lng = data_subset()$LONGITUDE) %>% 
            addMiniMap()
    })
}


shinyApp(ui, server)