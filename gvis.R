
#########------------------------------Plots using googleVis package ----------------------------######
# removing all other environment varibales if required
# rm(list = ls())

#installing and loading required packages
install.packages("googleVis")
library(googleVis)


# Loading the data
GdpPop <- read.csv('E:/Study/uconn/Fall2016/R/Projects/project 1/Gdp-population.csv')
LifeExp <- read.csv('E:/Study/uconn/Fall2016/R/Projects/project 1/life-expectancy.csv')

# converting all the factor data to lower case to make sure there wont be any issue during the join
GdpPop <- data.frame(
  lapply(GdpPop, function(v) {
  if (is.factor(v)) return(tolower(v))
  else return(v)
}))

# converting all the factor data to lower case to make sure there wont be any issue during the join
LifeExp <- data.frame(
  lapply(LifeExp, function(v) {
  if (is.factor(v)) return(tolower(v))
  else return(v)
}))

# inner joinging data base Country and year, to combine Life Expectancy data, Population and Gdp data
merge_data <- merge(GdpPop,LifeExp, by = c('Country','Year'))

# Renaming the GDP varibale
merge_data$Gdp = merge_data$Gdp.Ppp
merge_data$Gdp.Ppp <- NULL

# subsetting for data we need [rows, columns]
col_names_required <- c('Country','Year','Region','Gdp','Population','Life_Exp')
merge_data <- merge_data[merge_data$Year <2010 & merge_data$Year >=1950,col_names_required]

# to have a look at the data
# View(merge_data)

# to look at the structure of the data
# str(merge_data)

#-------------------------------- First plot ---------------------------------------------

# Here we will plot two different plots using two different graphs using gvisComboChart

# Forming a function to fetch the combination plot(for both population and Life Expectancy for a particular year) 
# by just passing the year 

combination_plot <- function(year){
  # filtering the data to fetch the data of the year requested for 
  filter_data <- merge_data[merge_data$Year == year,]
  
  # Aggregating the population and life expectancy base on Region, i.e Continenet
  aggr_data <- aggregate(filter_data[, c('Population','Life_Exp')], 
                         list(filter_data$Region), mean)
  
  # combingin the year with the title information using paste command
  title_formation <- paste(c('Mean Pop vs Mean Life_Exp|',year),collapse = " ")
  
  # plotting the combination chart of population mean and life expectancy mean using gvisComboChart()
  # here we specify a list things to title for title of you plot, type of graphs we want for both the plots
  # Width and height to specify the dimensions of our plot, and vaxes and haxes to specify the specifications of vertical axis and horizontal axis
    plt <- gvisComboChart(aggr_data, xvar="Group.1", yvar=c("Population", "Life_Exp"),
                          options=list(title=title_formation,
                                       titleTextStyle="{color:'black',fontName:'Courier',fontSize:18}",
                                       pointSize=3,
                                       seriesType="bars",
                                       series="[{type:'line',targetAxisIndex:0,color:'blue'},{type:'bars',targetAxisIndex:1,color:'Black'}]",
                                       hAxes="[{title:'Region'}]",
                                       vAxes = "[{title : 'Average Population'},{title: 'Avg Life Expectancy in Years'}]",
                                       width=600, height=500
                          )
  )
    
  # To return the plot we formed, (this will be in the form html code)
  return(plt)
}


# Please pass a year 1950 to 2009 to the function to plot
plot(combination_plot(2009))
plot(combination_plot(1950))


#------------------------------------------Second plot----------------------------------------

# Drawing a heat map based on life expectancy or population for a given year
geo_plot<- function(var,year){
  # filtering the data based on the year passed to the function
  filter_data <- merge_data[merge_data$Year == year,]
  
  # PLotting the (heat map) geoplot with the variable passed as the colorvar 
  map <- plot(gvisGeoChart(filter_data,locationvar = 'Country',colorvar = var))
  
  # returning the map which is stored in the form of html
  return(map)
}

# please input a value of 'Population' or 'Life_Exp' and year inbetween 1950 to 2000 
geo_plot('Life_Exp',1985)


#------------------------------------------Third plot-----------------------------------------------------------

# bubble plot of all the years combined with,
# bubble size = population
# bubble color = Continent
# x - axis = GDP
# y - axis = Life Expectansy

# creating the html page for the plot
bubble <- gvisBubbleChart(merge_data, idvar="Country",xvar="Gdp", yvar="Life_Exp",
                colorvar="Region", sizevar="Population",options=list(title = 'GDP vs Life Expectansy',
                  height = "800", width = "900",
                  hAxis="{title:'GDP'}",
                  vAxis="{format:'short',title:'Life Expectancy'}"
                )
)

# plotting it using plot method
plot(bubble)

# function to draw bubble plot for single year
bubble_plot <- function(year){
  # filtering the data based on the year passed to the function
  filter_data <- merge_data[merge_data$Year == year,]
  
  # forming the title commbining the title with year passed to the function
  title_formed <- paste(c('GDP vs Life Exp for ',year),collapse = " ")
  
  # creating the html page for the plot
  bubble <- gvisBubbleChart(filter_data, idvar="Country",xvar="Gdp", yvar="Life_Exp",
                            colorvar="Region", sizevar="Population",
                            options=list(title = title_formed,
                            height = "800", width = "800",
                            hAxis="{title:'GDP'}",
                            vAxis="{format:'short',title:'Life Expectancy'}"
                            )
  )
return(bubble)
}


plot(bubble_plot(1990))


#-----------------------------------------Fourth Plot-----------------------------------------------

# what if we want to see all the years bubble plot in a motion from 1950 to 200,
# Hans Roslings Income vs Life Expectancy plot

# The answer for that question is our next plot, i.e gvisMotionChart 
# which gives a combination of motion bubble, line, and bar graph plots
# lets see how it can be done

# creating a income varibale from gdp
merge_data$income <- merge_data$Gdp/merge_data$Population


# A bubble plot similar to hans roslings to Life Expectancy vs GDP using gvisMotionChart()
motion <- gvisMotionChart(data = merge_data,idvar = "Country", xvar = "income", yvar = "Life_Exp",
                          timevar = "Year",colorvar = 'Region',sizevar = 'Population',options = list())

# After plotting the motion bubble graph, select varibale on x axis to Life_Exp and variable in y axis to Gdp
# and start the motion
plot(motion)
# Make sure to change the x axis scale to log to make in the stand alone google page 