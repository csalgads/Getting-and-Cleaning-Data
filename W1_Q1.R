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


