# QUIZ_1 
## Question 1
## The American Community Survey distributes downloadable data about United States 
## communities. Download the 2006 microdata survey about housing for the state of 
## Idaho using download.file() from here:
     
   ## https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv

## and load the data into R. The code book, describing the variable names is here:
     
   ##  https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf

## How many properties are worth $1,000,000 or more?

## a) Download the file and save it in R
microdata <- read.csv("data.csv")
## b) Extract the column related with the property value 
properties <- microdata[,"VAL"]
## c) Remove missing values
properties_worth <- properties[!is.na(properties)]
## d) Filter by 24 that represent the range were 24 .$1000000+
properties_worth <- properties_worth[properties_worth == 24]
## e) Count of properties that are worth $1,000,000 or more
properties_worth_1000000 <- length(properties_worth) 

## Question 3

## Download the Excel spreadsheet on Natural Gas Aquisition Program here:
     ## https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx
## Read rows 18-23 and columns 7-15 into R and assign the result to a variable called:
   ##  dat
## What is the value of:
   ##  sum(dat$Zip*dat$Ext,na.rm=T)
## (original data source: http://catalog.data.gov/dataset/natural-gas-acquisition-program)

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx"
## a) Download the file 
download.file(fileUrl,destfile = "question3.xlsx",mode = 'wb')
## b) Load xlsx library
library(xlsx)
## c) Specific row and columns 
rowIndex_1 <- 18:23
colIndex_1 <- 7:15
## d) Read the data into the variable dat
dat <- read.xlsx("question3.xlsx",sheetIndex = 1,rowIndex = rowIndex_1,colIndex 
                 = colIndex_1)
## e) Execute the operation sum(dat$Zip*dat$Ext,na.rm=T) 
sum(dat$Zip*dat$Ext,na.rm=T)

## Question 4

## Read the XML data on Baltimore restaurants from here:
     
   ##  https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml

## How many restaurants have zipcode 21231?

## a) Load XML library
library(XML)
## b) Create file conection
fileUrl <- "http://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml"
## c) Read the file into R
doc <- xmlTreeParse(fileUrl,useInternal = TRUE)


     ## -----------------------------------------------------------------------------------
     ## In case this do not work, Try:
     ## a.1)  Load RCurl and XML packages
     library(RCurl)
     library(XML)
     ## b.1) Create file conection
     temp <- getURL("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml")
     ## c.1) Read the file into R
     doc <- xmlTreeParse(temp, useInternalNodes = TRUE)
     ## -----------------------------------------------------------------------------------


## d) Create the root node 
rootNode <- xmlRoot(doc)
## e) Create a vector with the zip codes values
zip <- xpathSApply(rootNode,"//zipcode",xmlValue)
## f) Filter the vector identifying the restaurants with zip code 21231
zip_21231 <- zip[zip =="21231"]
## g) Count the number of restaurants with zip code 21231
length(zip_21231)

## Question 5

## The American Community Survey distributes downloadable data about United States 
## communities. Download the 2006 microdata survey about housing for the state of 
## Idaho using download.file() from here:
     
   ##  https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv

## using the fread() command load the data into an R object
     ## DT
## The following are ways to calculate the average value of the variable
     ## pwgtp15
## broken down by sex. Using the data.table package, which will deliver the fastest 
## user time?

## a) Load data.table package
library(data.table)
## b) Create file conection
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv"
## c) Download the file
download.file(fileUrl,destfile = "question5.csv")
## d) Read the file into R using fread from data.table package
DT <- fread("question5.csv")
## e)  
DT[,mean(pwgtp15),by=SEX]



