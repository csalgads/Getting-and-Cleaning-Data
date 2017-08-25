# Week 2 Quiz

#------------------------------------------------------------------------------------
## Question 1 

## Register an application with the Github API here 
## https://github.com/settings/applications. Access the API to get information 
## on your instructors repositories (hint: this is the url you want 
## "https://api.github.com/users/jtleek/repos"). Use this data to find the time 
## that the datasharing repo was created. What time was it created?

## This tutorial may be useful 
## (https://github.com/hadley/httr/blob/master/demo/oauth2-github.r). 
## You may also need to run the code in the base R package and not R studio.

### Cargar la libreria httr y rjson
library(httr)
library(jsonlite)
# 1. Find OAuth settings for github:
#    http://developer.github.com/v3/oauth/
oauth_endpoints("github")

### Acces to github app 
myapp <- oauth_app("github",key = "f8322a65cbf451ab2181",
                    secret = "fa99975c3908e173e1d6a5b9731841adb54168d1")

# 3. Get OAuth credentials
github_token <- oauth2.0_token(oauth_endpoints("github"), myapp)

# 4. Use API
gtoken <- config(token = github_token)
req <- GET("https://api.github.com/users/jtleek/repos", gtoken)
stop_for_status(req)
content(req)

## Read the content from req
json1 <- content(req)
## Convert from json to data frame 
json2 <- jsonlite::fromJSON(toJSON(json1))
## Subset the tables just for datasharing repository und just the columns that are from 
## my interest
subset(json2,name =="datasharing",select=c(name,created_at,updated_at,pushed_at))

#------------------------------------------------------------------------------------
## Question 2

### The sqldf package allows for execution of SQL commands on R data frames. We 
### will use the sqldf package to practice the queries we might send with the 
### dbSendQuery command in RMySQL.

### Download the American Community Survey data and load it into an R object called
### acs
### https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv
### Which of the following commands will select only the data for the probability 
### weights pwgtp1 with ages less than 50?


### Load sqldf package
library(sqldf)

### Read "W2_Question2.csv" and assign its content to the data frame acs
acs <- read.csv("W2_Question2.csv")
sqldf("select pwgtp1 from acs where AGEP < 50")

#------------------------------------------------------------------------------------
## Question 3

### Using the same data frame you created in the previous problem, what is the 
### equivalent function to unique(acs$AGEP)
library(sqldf)
acs <- read.csv("W2_Question2.csv")
unique(acs$AGEP)
sqldf("select distinct AGEP from acs")

#------------------------------------------------------------------------------------
## Question 4

### How many characters are in the 10th, 20th, 30th and 100th lines of HTML 
### from this page:
    ###  http://biostat.jhsph.edu/~jleek/contact.html
### (Hint: the nchar() function in R may be helpful)

## Connect to the url
con <- url("http://biostat.jhsph.edu/~jleek/contact.html")
## Read the lines from con into the variable htmlCode
htmlCode <- readLines(con)
## Close the connection with the Url <- This step is really important
close(con)
## Count the number of characters with the function nchar for he 10th, 20th, 
## 30th and 100th lines
answer <- c(nchar(htmlCode[10]),nchar(htmlCode[20]),nchar(htmlCode[30]),nchar(htmlCode[100]))
## print the result vector 
print(answer)

#------------------------------------------------------------------------------------
## Question 5

### Read this data set into R and report the sum of the numbers in the fourth of 
### the nine columns.
#### https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for

#### Original source of the data: http://www.cpc.ncep.noaa.gov/data/indices/wksst8110.for
### (Hint this is a fixed width file format)

x <- read.fwf(file=url("http://www.cpc.ncep.noaa.gov/data/indices/wksst8110.for"),
              skip=3,widths=c(12, 7, 4, 9, 4, 9, 4, 9, 4))

sum(x[,4])
