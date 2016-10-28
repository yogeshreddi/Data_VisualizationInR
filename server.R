# Authors - codeRz
# Project 1 - Viz
# Shiny server  wherein computations and statistical analysis is performed here.

server<- function(input,output){
  output$pointplot <- renderPlot({
    qplot(Year, Per.capita.CO2.emissions,data = co2, colour = Region , shape = Region,geom = c("point"))
  })
  output$pathplot <- renderPlot({
    ggplot(data = co2, aes(x = Gdp.Ppp/Population, y = Region)) +
      geom_path(aes(color= Year, size = Population)) 
  })
    
}