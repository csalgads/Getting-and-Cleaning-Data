# Week 3 Quiz

## Question 1--------------------------------------------------------------------------------------------
## The American Community Survey distributes downloadable data about United 
## States communities. Download the 2006 microdata survey about housing for 
## the state of Idaho using download.file() from here:
## https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv
## and load the data into R. The code book, describing the variable names is here:
## https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf
## Create a logical vector that identifies the households on greater than 10 
## acres who sold more than $10,000 worth of agriculture products. Assign that 
## logical vector to the variable agricultureLogical. Apply the which() function 
## like this to identify the rows of the data frame where the logical vector is TRUE.
## which(agricultureLogical)
## What are the first 3 values that result?

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"

download.file(fileUrl, destfile = "W3_Q1.csv")

americanComunity <- read.csv("W3_Q1.csv")

americanComunity$agricultureLogical <- (americanComunity$ACR == 3 & americanComunity$AGS == 6)

americanComunity[which(americanComunity$agricultureLogical),]

##-----------------------------------------------------------------------------------------------------

## Question 2------------------------------------------------------------------------------------------

## Using the jpeg package read in the following picture of your instructor into R
## https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg
## Use the parameter native=TRUE. What are the 30th and 80th quantiles of the 
## resulting data? (some Linux systems may produce an answer 638 different for the 30th quantile)

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg"

download.file(fileUrl, destfile = "W3_Q2.jpg", mode = "wb")

img <- readJPEG("W3_Q2.jpg", native = TRUE)

quantile(img,probs = c(0.3,0.8),na.rm = TRUE)

##-----------------------------------------------------------------------------------------------------

## Question 3------------------------------------------------------------------------------------------

## Load the Gross Domestic Product data for the 190 ranked countries in this data set:
## https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv
## Load the educational data from this data set:
## https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv
## Match the data based on the country shortcode. How many of the IDs match? Sort 
## the data frame in descending order by GDP rank (so United States is last). What 
## is the 13th country in the resulting data frame?
## Original data sources:
## http://data.worldbank.org/data-catalog/GDP-ranking-table
## http://data.worldbank.org/data-catalog/ed-stats
library(dplyr)
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
download.file(fileUrl, destfile = "W3_Q3.csv")
Gross_Dom_Prod <- read.csv("W3_Q3.csv",skip = 5,header = FALSE, nrows = 231)
names(Gross_Dom_Prod) <- c("Key_Country","Ranking","V3","Country_Short_Desc","MUSD","V6","V7","V8","V9","V10")
Gross_Dom_Prod_F <- select(Gross_Dom_Prod,"Key_Country","Ranking","Country_Short_Desc","MUSD")


fileUrlb <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"
download.file(fileUrlb, destfile = "W3_Q3b.csv")
educational_data <- read.csv("W3_Q3b.csv")

megeddata<- merge(educational_data,Gross_Dom_Prod_F,by.x = "CountryCode",by.y = "Key_Country", all = TRUE)

dataorder <- arrange(megeddata,desc(Ranking))

##-----------------------------------------------------------------------------------------------------

## Question 4------------------------------------------------------------------------------------------

## What is the average GDP ranking for the "High income: OECD" and "High income: 
## nonOECD" group?

dataorder%>%group_by(Income.Group)%>%summarize(IncomeMeam = mean(Ranking,na.rm = TRUE))

##-----------------------------------------------------------------------------------------------------

## Question 5------------------------------------------------------------------------------------------

## Cut the GDP ranking into 5 separate quantile groups. Make a table versus Income.Group. 
## How many countries are Lower middle income but among the 38 nations with highest GDP?

library(Hmisc)

megeddata$rankgroups <- cut2(megeddata$Ranking, g=5)

table(mergedata$rankgroups,mergedata$Income.Group)



