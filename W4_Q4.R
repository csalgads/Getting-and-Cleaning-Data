# Week 4 Quiz

## Question 1--------------------------------------------------------------------------------------------
## The American Community Survey distributes downloadable data about United States communities. 
## Download the 2006 microdata survey about housing for the state of Idaho using download.file() from here:
## https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv
## and load the data into R. The code book, describing the variable names is here:
## https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf
## Apply strsplit() to split all the names of the data frame on the characters "wgtp". What is 
## the value of the 123 element of the resulting list?

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"

download.file(fileUrl,destfile = "microdatasurvey.csv")

microdatasurvey <- read.csv("microdatasurvey.csv")

namesmicro <- names(microdatasurvey)

splitnames <- strsplit(namesmicro)

splitnames[[123]]

##-------------------------------------------------------------------------------------------------------

## Question 2--------------------------------------------------------------------------------------------
## Load the Gross Domestic Product data for the 190 ranked countries in this data set:
## https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv
## Remove the commas from the GDP numbers in millions of dollars and average them. What is the average?
## Original data sources:
## http://data.worldbank.org/data-catalog/GDP-ranking-table

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"

download.file(fileUrl,destfile = "GDP.csv")

initial <- read.csv("GDP.csv",skip = 5,header = FALSE,nrows = 100,stringsAsFactors = FALSE)
classes <- sapply(initial, class)
Gross_Dom_Prod <- read.csv("GDP.csv",skip = 5,header = FALSE, nrows = 215,colClasses = classes)
names(Gross_Dom_Prod) <- c("Key_Country","Ranking","V3","Country_Short_Desc","MUSD","V6","V7","V8","V9","V10")
Gross_Dom_Prod <- select(Gross_Dom_Prod,"Key_Country","Ranking","Country_Short_Desc","MUSD")
GDPMUSD <- as.numeric(gsub(",","",Gross_Dom_Prod$MUSD))
aveMUSD <- mean(GDPMUSD,na.rm = TRUE)
print(aveMUSD)

##-------------------------------------------------------------------------------------------------------

## Question 3--------------------------------------------------------------------------------------------
## In the data set from Question 2 what is a regular expression that would allow you to count the number 
## of countries whose name begins with "United"? Assume that the variable with the country names in it 
## is named countryNames. How many countries begin with United?

grep("^United",Gross_Dom_Prod$Country_Short_Desc)

table(grepl("^United",Gross_Dom_Prod$Country_Short_Desc))

grep("^United",Gross_Dom_Prod$Country_Short_Desc, value = TRUE)

length(grep("^United",Gross_Dom_Prod$Country_Short_Desc, value = TRUE))

##-------------------------------------------------------------------------------------------------------

## Question 4--------------------------------------------------------------------------------------------
## Load the Gross Domestic Product data for the 190 ranked countries in this data set:
## https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv
## Load the educational data from this data set:
## https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv
## Match the data based on the country shortcode. Of the countries for which the end of 
## the fiscal year is available, how many end in June?
## Original data sources:
## http://data.worldbank.org/data-catalog/GDP-ranking-table
## http://data.worldbank.org/data-catalog/ed-stats

library(dplyr)
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
download.file(fileUrl, destfile = "W4_Q4.csv")
Gross_Dom_Prod <- read.csv("W4_Q4.csv",skip = 5,header = FALSE, nrows = 231)
names(Gross_Dom_Prod) <- c("Key_Country","Ranking","V3","Country_Short_Desc","MUSD","V6","V7","V8","V9","V10")
Gross_Dom_Prod_F <- select(Gross_Dom_Prod,"Key_Country","Ranking","Country_Short_Desc","MUSD")


fileUrlb <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"
download.file(fileUrlb, destfile = "W4_Q4b.csv")
educational_data <- read.csv("W4_Q4b.csv")

megeddata<- merge(educational_data,Gross_Dom_Prod_F,by.x = "CountryCode",by.y = "Key_Country", all = TRUE)

dataorder <- arrange(megeddata,desc(Ranking))

grep("^Fiscal year end: June",dataorder$Special.Notes)

table(grepl("^Fiscal year end: June",dataorder$Special.Notes))

grep("^Fiscal year end: June",dataorder$Special.Notes,value = TRUE)

length(grep("^Fiscal year end: June",dataorder$Special.Notes,value = TRUE))
##-------------------------------------------------------------------------------------------------------

## Question 5--------------------------------------------------------------------------------------------
## You can use the quantmod (http://www.quantmod.com/) package to get historical stock prices 
## for publicly traded companies on the NASDAQ and NYSE. Use the following code to download data 
## on Amazon's stock price and get the times the data was sampled.
## library(quantmod)
## amzn = getSymbols("AMZN",auto.assign=FALSE)
## sampleTimes = index(amzn)
## How many values were collected in 2012? How many values were collected on Mondays in 2012?

library(quantmod)
amzn <- getSymbols("AMZN",auto.assign=FALSE)
sampleTimes <- index(amzn)

grep("^2012",sampleTimes)

table(grepl("^2012",sampleTimes))

grep("^2012",sampleTimes,value = TRUE)

length(grep("^2012",sampleTimes,value = TRUE))

days <- as.Date(grep("^2012",sampleTimes,value = TRUE))

wdays <- weekdays(days)

table(grepl("^Monday",wdays))


##-------------------------------------------------------------------------------------------------------