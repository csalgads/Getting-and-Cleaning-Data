# Practical R- swirl  Week 3 

#-------------------------------------------------------------------------------
#- 1 Manipulating Data with dplyr

library(swirl)
swirl()
## In this lesson, you'll learn how to manipulate data using dplyr. dplyr is a fast and
## powerful R package written by Hadley Wickham and Romain Francois that provides a
## consistent and concise grammar for manipulating tabular data.

## One unique aspect of dplyr is that the same set of tools allow you to work with tabular
## data from a variety of sources, including data frames, data tables, databases and
## multidimensional arrays. In this lesson, we'll focus on data frames, but everything you
## learn will apply equally to other formats.


## As you may know, "CRAN is a network of ftp and web servers around the world that store
## identical, up-to-date, versions of code and documentation for R"
## (http://cran.rstudio.com/). RStudio maintains one of these so-called 'CRAN mirrors' and
## they generously make their download logs publicly available
## (http://cran-logs.rstudio.com/). We'll be working with the log from July 8, 2014, which
## contains information on roughly 225,000 package downloads.

## I've created a variable called path2csv, which contains the full file path to the
## dataset. Call read.csv() with two arguments, path2csv and stringsAsFactors = FALSE, and
## save the result in a new variable called mydf. Check ?read.csv if you need help.

mydf <- read.csv(path2csv,stringsAsFactors = FALSE)

## Use dim() to look at the dimensions of mydf.

dim(mydf)

# ** [1] 225468     11

## Now use head() to preview the data.

head(mydf)

## The dplyr package was automatically installed (if necessary) and loaded at the
## beginning of this lesson. Normally, this is something you would have to do on your own.
## Just to build the habit, type library(dplyr) now to load the package again.

library(dplyr)

## It's important that you have dplyr version 0.4.0 or later. To confirm this, type
## packageVersion("dplyr").

packageVersion("dplyr")

# **  [1] '0.7.2'

##  The first step of working with data in dplyr is to load the data into what the package
## authors call a 'data frame tbl' or 'tbl_df'. Use the following code to create a new
## tbl_df called cran:
     ## cran <- tbl_df(mydf).
cran <- tbl_df(mydf)

## To avoid confusion and keep things running smoothly, let's remove the original data
## frame from your workspace with rm("mydf").

rm("mydf")

## From ?tbl_df, "The main advantage to using a tbl_df over a regular data frame is the
## printing." Let's see what is meant by this. Type cran to print our tbl_df to the
## console.

cran

## This output is much more informative and compact than what we would get if we printed
## the original data frame (mydf) to the console.

## First, we are shown the class and dimensions of the dataset. Just below that, we get a
## preview of the data. Instead of attempting to print the entire dataset, dplyr just
## shows us the first 10 rows of data and only as many columns as fit neatly in our
## console. At the bottom, we see the names and classes for any variables that didn't fit
## on our screen.

## According to the "Introduction to dplyr" vignette written by the package authors, "The
## dplyr philosophy is to have small functions that each do one thing well." Specifically,
## dplyr supplies five 'verbs' that cover most fundamental data manipulation tasks:
## select(), filter(), arrange(), mutate(), and summarize().

## Use ?select to pull up the documentation for the first of these core functions

?select

## As may often be the case, particularly with larger datasets, we are only interested in
## some of the variables. Use select(cran, ip_id, package, country) to select only the
## ip_id, package, and country variables from the cran dataset.

select(cran, ip_id, package, country)

## The first thing to notice is that we don't have to type cran$ip_id, cran$package, and
## cran$country, as we normally would when referring to columns of a data frame. The
## select() function knows we are referring to columns of the cran dataset.

## Also, note that the columns are returned to us in the order we specified, even though
## ip_id is the rightmost column in the original dataset.

## Recall that in R, the `:` operator provides a compact notation for creating a sequence
## of numbers. For example, try 5:20.

## Normally, this notation is reserved for numbers, but select() allows you to specify a
## sequence of columns this way, which can save a bunch of typing. 
## Use select(cran, r_arch:country) to select all columns starting from r_arch 
## and ending with country.

select(cran, r_arch:country)

## We can also select the same columns in reverse order. Give it a try

select(cran, country:r_arch)

## Instead of specifying the columns we want to keep, we can also specify the columns we
## want to throw away. To see how this works, do select(cran, -time) to omit the time
## column.

select(cran, -time)

## The negative sign in front of time tells select() that we DON'T want the time column.
## Now, let's combine strategies to omit all columns from X through size (X:size). To see
## how this might work, let's look at a numerical example with -5:20.

-5:20

## Oops! That gaves us a vector of numbers from -5 through 20, which is not what we want.
## Instead, we want to negate the entire sequence of numbers from 5 through 20, so that we
## get -5, -6, -7, ... , -18, -19, -20. Try the same thing, except surround 5:20 with
## parentheses so that R knows we want it to first come up with the sequence of numbers,
## then apply the negative sign to the whole thing.

-(5:20)

## Use this knowledge to omit all columns X:size using select().

select(cran, -(X:size))

## Now that you know how to select a subset of columns using select(), a natural next
## question is "How do I select a subset of rows?" That's where the filter() function
## comes in.

## Use filter(cran, package == "swirl") to select all rows for which the package variable
## is equal to "swirl". Be sure to use two equals signs side-by-side!

filter(cran, package == "swirl")

## Again, note that filter() recognizes 'package' as a column of cran, without you having
## to explicitly specify cran$package.

## The == operator asks whether the thing on the left is equal to the thing on the right.
## If yes, then it returns TRUE. If no, then FALSE. In this case, package is an entire
## vector (column) of values, so package == "swirl" returns a vector of TRUEs and FALSEs.
## filter() then returns only the rows of cran corresponding to the TRUEs.

## You can specify as many conditions as you want, separated by commas. For example
## filter(cran, r_version == "3.1.1", country == "US") will return all rows of cran
## corresponding to downloads from users in the US running R version 3.1.1. Try it out.

filter(cran, r_version == "3.1.1", country == "US")

## The conditions passed to filter() can make use of any of the standard comparison
## operators. Pull up the relevant documentation with ?Comparison (that's an uppercase C).

## Edit your previous call to filter() to instead return rows corresponding to users in
## "IN" (India) running an R version that is less than or equal to "3.0.2". The up arrow
## on your keyboard may come in handy here. Don't forget your double quotes!

filter(cran, r_version <= "3.0.2", country == "IN")

## Our last two calls to filter() requested all rows for which some condition AND another
## condition were TRUE. We can also request rows for which EITHER one condition OR another
## condition are TRUE. For example, filter(cran, country == "US" | country == "IN") will
## gives us all rows for which the country variable equals either "US" or "IN". Give it a
## go.

filter(cran, country == "US" | country == "IN")

## Now, use filter() to fetch all rows for which size is strictly greater than (>) 100500
## (no quotes, since size is numeric) AND r_os equals "linux-gnu". Hint: You are passing
## three arguments to filter(): the name of the dataset, the first condition, and the
## second condition.

filter(cran, size > 100500, r_os == "linux-gnu")

## Finally, we want to get only the rows for which the r_version is not missing. R
## represents missing values with NA and these missing values can be detected using the
## is.na() function.

## To see how this works, try is.na(c(3, 5, NA, 10)).

is.na(c(3, 5, NA, 10))

## Now, put an exclamation point (!) before is.na() to change all of the TRUEs to FALSEs
## and all of the FALSEs to TRUEs, thus telling us what is NOT NA: !is.na(c(3, 5, NA, 10)).

!is.na(c(3, 5, NA, 10))

## Okay, ready to put all of this together? Use filter() to return all rows of cran for
## which r_version is NOT NA. Hint: You will need to use !is.na() as part of your second
## argument to filter().

filter(cran, !is.na(r_version))

## We've seen how to select a subset of columns and rows from our dataset using select()
## and filter(), respectively. Inherent in select() was also the ability to arrange our
## selected columns in any order we please.

## Sometimes we want to order the rows of a dataset according to the values of a
## particular variable. This is the job of arrange().

## To see how arrange() works, let's first take a subset of cran. select() all columns
## from size through ip_id and store the result in cran2.

cran2 <- select(cran, size:ip_id)

## Now, to order the ROWS of cran2 so that ip_id is in ascending order (from small to
## large), type arrange(cran2, ip_id). You may want to make your console wide enough so
## that you can see ip_id, which is the last column.

arrange(cran2, ip_id)

## To do the same, but in descending order, change the second argument to desc(ip_id),
## where desc() stands for 'descending'. Go ahead.

arrange(cran2, desc(ip_id))

## We can also arrange the data according to the values of multiple variables. For
## example, arrange(cran2, package, ip_id) will first arrange by package names (ascending
## alphabetically), then by ip_id. This means that if there are multiple rows with the
## same value for package, they will be sorted by ip_id (ascending numerically). Try
## arrange(cran2, package, ip_id) now.

arrange(cran2, package, ip_id)

## Arrange cran2 by the following three variables, in this order: country (ascending),
## r_version (descending), and ip_id (ascending).

arrange(cran2,country,desc(r_version),ip_id)

## To illustrate the next major function in dplyr, let's take another subset of our
## original data. Use select() to grab 3 columns from cran -- ip_id, package, and size (in
## that order) -- and store the result in a new variable called cran3.

cran3 <- select(cran,ip_id, package,size)

## It's common to create a new variable based on the value of one or more variables
## already in a dataset. The mutate() function does exactly this.

## The size variable represents the download size in bytes, which are units of computer
## memory. These days, megabytes (MB) are a more common unit of measurement. One megabyte
## is equal to 2^20 bytes. That's 2 to the power of 20, which is approximately one million
## bytes!

## We want to add a column called size_mb that contains the download size in megabytes.
## Here's the code to do it:
## mutate(cran3, size_mb = size / 2^20)

mutate(cran3, size_mb = size / 2^20)

## An even larger unit of memory is a gigabyte (GB), which equals 2^10 megabytes. We might
## as well add another column for download size in gigabytes!

## One very nice feature of mutate() is that you can use the value computed for your
## second column (size_mb) to create a third column, all in the same line of code. To see
## this in action, repeat the exact same command as above, except add a third argument
## creating a column that is named size_gb and equal to size_mb / 2^10.


mutate(cran3, size_mb = size / 2^20,size_gb = size_mb / 2^10)

## Let's try one more for practice. Pretend we discovered a glitch in the system that
## provided the original values for the size variable. All of the values in cran3 are 1000
## bytes less than they should be. Using cran3, create just one new column called
## correct_size that contains the correct size.


mutate(cran3, correct_size = size + 1000)

## The last of the five core dplyr verbs, summarize(), collapses the dataset to a single
## row. Let's say we're interested in knowing the average download size. summarize(cran,
## avg_bytes = mean(size)) will yield the mean value of the size variable. Here we've
## chosen to label the result 'avg_bytes', but we could have named it anything. Give it a
## try.

summarize(cran,avg_bytes = mean(size))

## That's not particularly interesting. summarize() is most useful when working with data
## that has been grouped by the values of a particular variable.

## We'll look at grouped data in the next lesson, but the idea is that summarize() can
## give you the requested value FOR EACH group in your dataset.

## In this lesson, you learned how to manipulate data using dplyr's five main functions.
## In the next lesson, we'll look at how to take advantage of some other useful features
## of dplyr to make your life as a data analyst much easier.



#-------------------------------------------------------------------------------
#- 2 Grouping and Chaining with dplyr

## In the last lesson, you learned about the five main data manipulation 'verbs' in dplyr:
## select(), filter(), arrange(), mutate(), and summarize(). The last of these,
## summarize(), is most powerful when applied to grouped data.

## The main idea behind grouping data is that you want to break up your dataset into
## groups of rows based on the values of one or more variables. The group_by() function is
## reponsible for doing this.

## We'll continue where we left off with RStudio's CRAN download log from July 8, 2014,
## which contains information on roughly 225,000 R package downloads
## (http://cran-logs.rstudio.com/).


## As with the last lesson, the dplyr package was automatically installed (if necessary)
## and loaded at the beginning of this lesson. Normally, this is something you would have
## to do on your own. Just to build the habit, type library(dplyr) now to load the package
## again.

## I've made the dataset available to you in a data frame called mydf. Put it in a 'data
## frame tbl' using the tbl_df() function and store the result in a object called cran. If
## you're not sure what I'm talking about, you should start with the previous lesson.
## Otherwise, practice makes perfect!


cran <- tbl_df(mydf)

## To avoid confusion and keep things running smoothly, let's remove the original
## dataframe from your workspace with rm("mydf").

rm("mydf")


## Our first goal is to group the data by package name. Bring up the help file for
## group_by().
## Group cran by the package variable and store the result in a new object called
## by_package.

by_package <- group_by(cran,package)

## At the top of the output above, you'll see 'Groups: package', which tells us that this
## tbl has been grouped by the package variable. Everything else looks the same, but now
## any operation we apply to the grouped data will take place on a per package basis.

## Recall that when we applied mean(size) to the original tbl_df via summarize(), it
## returned a single number -- the mean of all values in the size column. We may care
## about what that number is, but wouldn't it be so much more interesting to look at the
## mean download size for each unique package?

## That's exactly what you'll get if you use summarize() to apply mean(size) to the
## grouped data in by_package. Give it a shot.

summarize(by_package,mean(size))

## Instead of returning a single value, summarize() now returns the mean size for EACH
## package in our dataset.

## Let's take it a step further. I just opened an R script for you that contains a
## partially constructed call to summarize(). Follow the instructions in the script
## comments.
## When you are ready to move on, save the script and type submit(), or type reset() to
## reset the script to its original state.


## Summarize1.R script -----------------------------------------------------------------
# Compute four values, in the following order, from
# the grouped data:
#
# 1. count = n()
# 2. unique = n_distinct(ip_id)
# 3. countries = n_distinct(country)
# 4. avg_bytes = mean(size)
#
# A few thing to be careful of:
#
# 1. Separate arguments by commas
# 2. Make sure you have a closing parenthesis
# 3. Check your spelling!
# 4. Store the result in pack_sum (for 'package summary')
#
# You should also take a look at ?n and ?n_distinct, so
# that you really understand what is going on.

pack_sum <- summarize(by_package,count = n()
                      ,unique = n_distinct(ip_id) 
                      ,countries = n_distinct(country)
                      ,avg_bytes = mean(size))

## -------------------------------------------------------------------------------------

## The 'count' column, created with n(), contains the total number of rows (i.e.
## downloads) for each package. The 'unique' column, created with n_distinct(ip_id), gives
## the total number of unique downloads for each package, as measured by the number of
## distinct ip_id's. The 'countries' column, created with n_distinct(country), provides
## the number of countries in which each package was downloaded. And finally, the
## 'avg_bytes' column, created with mean(size), contains the mean download size (in bytes)
## for each package.

## It's important that you understand how each column of pack_sum was created and what it
## means. Now that we've summarized the data by individual packages, let's play around
## with it some more to see what we can learn.

## Naturally, we'd like to know which packages were most popular on the day these data
## were collected (July 8, 2014). Let's start by isolating the top 1% of packages, based
## on the total number of downloads as measured by the 'count' column.

## We need to know the value of 'count' that splits the data into the top 1% and bottom
## 99% of packages based on total downloads. In statistics, this is called the 0.99, or
## 99%, sample quantile. Use quantile(pack_sum$count, probs = 0.99) to determine this
## number.

quantile(pack_sum$count, probs = 0.99)

## Now we can isolate only those packages which had more than 679 total downloads. Use
## filter() to select all rows from pack_sum for which 'count' is strictly greater (>)
## than 679. Store the result in a new object called top_counts.

top_counts <- filter(pack_sum,count > 679)

## There are only 61 packages in our top 1%, so we'd like to see all of them. Since dplyr
## only shows us the first 10 rows, we can use the View() function to see more.

## View all 61 rows with View(top_counts). Note that the 'V' in View() is capitalized.

## arrange() the rows of top_counts based on the 'count' column and assign the result to a
## new object called top_counts_sorted. We want the packages with the highest number of
## downloads at the top, which means we want 'count' to be in descending order. If you
## need help, check out ?arrange and/or ?desc.

top_counts_sorted <- arrange(top_counts,desc(count))

## Now use View() again to see all 61 rows of top_counts_sorted.

## If we use total number of downloads as our metric for popularity, then the above output
## shows us the most popular packages downloaded from the RStudio CRAN mirror on July 8,
## 2014. Not surprisingly, ggplot2 leads the pack with 4602 downloads, followed by Rcpp,
## plyr, rJava, ....

## Perhaps we're more interested in the number of *unique* downloads on this particular
## day. In other words, if a package is downloaded ten times in one day from the same
## computer, we may wish to count that as only one download. That's what the 'unique'
## column will tell us.

## Like we did with 'count', let's find the 0.99, or 99%, quantile for the 'unique'
## variable with quantile(pack_sum$unique, probs = 0.99).

quantile(pack_sum$unique, probs = 0.99)

## Apply filter() to pack_sum to select all rows corresponding to values of 'unique' that
## are strictly greater than 465. Assign the result to a object called top_unique.

top_unique <- filter(pack_sum,unique > 465)

View(top_unique)

## Now arrange() top_unique by the 'unique' column, in descending order, to see which
## packages were downloaded from the greatest number of unique IP addresses. Assign the
## result to top_unique_sorted.

top_unique_sorted <- arrange(top_unique, desc(unique))

## Now Rcpp is in the lead, followed by stringr, digest, plyr, and ggplot2. swirl moved up
## a few spaces to number 40, with 698 unique downloads. Nice!

## Our final metric of popularity is the number of distinct countries from which each
## package was downloaded. We'll approach this one a little differently to introduce you
## to a method called 'chaining' (or 'piping').

## Chaining allows you to string together multiple function calls in a way that is compact
## and readable, while still accomplishing the desired result. To make it more concrete,
## let's compute our last popularity metric from scratch, starting with our original data.

## I've opened up a script that contains code similar to what you've seen so far. Don't
## change anything. Just study it for a minute, make sure you understand everything that's
## there, then submit() when you are ready to move on.


## Summarize2.R script -----------------------------------------------------------------
# Don't change any of the code below. Just type submit()
# when you think you understand it.

# We've already done this part, but we're repeating it
# here for clarity.

by_package <- group_by(cran, package)
pack_sum <- summarize(by_package,
                      count = n(),
                      unique = n_distinct(ip_id),
                      countries = n_distinct(country),
                      avg_bytes = mean(size))

# Here's the new bit, but using the same approach we've
# been using this whole time.

top_countries <- filter(pack_sum, countries > 60)
result1 <- arrange(top_countries, desc(countries), avg_bytes)

# Print the results to the console.
print(result1)

## -------------------------------------------------------------------------------------


## It's worth noting that we sorted primarily by country, but used avg_bytes (in ascending
## order) as a tie breaker. This means that if two packages were downloaded from the same
## number of countries, the package with a smaller average download size received a higher
## ranking.

## We'd like to accomplish the same result as the last script, but avoid saving our
## intermediate results. This requires embedding function calls within one another.

## That's exactly what we've done in this script. The result is equivalent, but the code
## is much less readable and some of the arguments are far away from the function to which
## they belong. Again, just try to understand what is going on here, then submit() when
## you are ready to see a better solution.


## Summarize3.R script -----------------------------------------------------------------
# Don't change any of the code below. Just type submit()
# when you think you understand it. If you find it
# confusing, you're absolutely right!

result2 <-
     arrange(
          filter(
               summarize(
                    group_by(cran,package),
                    count = n(),
                    unique = n_distinct(ip_id),
                    countries = n_distinct(country),
                    avg_bytes = mean(size)
               ),
               countries > 60
          ),
          desc(countries),
          avg_bytes
     )

print(result2)
## -------------------------------------------------------------------------------------

## In this script, we've used a special chaining operator, %>%, which was originally
## introduced in the magrittr R package and has now become a key component of dplyr. You
## can pull up the related documentation with ?chain. The benefit of %>% is that it allows
## us to chain the function calls in a linear fashion. The code to the right of %>%
## operates on the result from the code to the left of %>%.
## Once again, just try to understand the code, then type submit() to continue.

## Summarize4.R script -----------------------------------------------------------------
# Read the code below, but don't change anything. As
# you read it, you can pronounce the %>% operator as
# the word 'then'.
#
# Type submit() when you think you understand
# everything here.

result3 <-
     cran %>%
     group_by(package) %>%
     summarize(count = n(),
               unique = n_distinct(ip_id),
               countries = n_distinct(country),
               avg_bytes = mean(size)
     ) %>%
     filter(countries > 60) %>%
     arrange(desc(countries), avg_bytes)

# Print result to console
print(result3)
## -------------------------------------------------------------------------------------

## So, the results of the last three scripts are all identical. But, the third script
## provides a convenient and concise alternative to the more traditional method that we've
## taken previously, which involves saving results as we go along.
## Once again, let's View() the full data, which has been stored in result3.

## It looks like Rcpp is on top with downloads from 84 different countries, followed by
## digest, stringr, plyr, and ggplot2. swirl jumped up the rankings again, this time to
## 27th.

## To help drive the point home, let's work through a few more examples of chaining.

## Let's build a chain of dplyr commands one step at a time, starting with the script I
## just opened for you.

## chain1.R script ---------------------------------------------------------------------
# select() the following columns from cran. Keep in mind
# that when you're using the chaining operator, you don't
# need to specify the name of the data tbl in your call to
# select().
#
# 1. ip_id
# 2. country
# 3. package
# 4. size
#
# The call to print() at the end of the chain is optional,
# but necessary if you want your results printed to the
# console. Note that since there are no additional arguments
# to print(), you can leave off the parentheses after
# the function name. This is a convenient feature of the %>%
# operator.

cran %>%
     select(ip_id,country,package,size) %>%
     print 

## -------------------------------------------------------------------------------------


## chain2.R script ---------------------------------------------------------------------
# Use mutate() to add a column called size_mb that contains
# the size of each download in megabytes (i.e. size / 2^20).
#
# If you want your results printed to the console, add
# print to the end of your chain.

cran %>%
     select(ip_id, country, package, size) %>%
     mutate(size_mb = size / 2^20) %>%
     print
## -------------------------------------------------------------------------------------


## chain3.R script ---------------------------------------------------------------------
# Use filter() to select all rows for which size_mb is
# less than or equal to (<=) 0.5.
#
# If you want your results printed to the console, add
# print to the end of your chain.

cran %>%
     select(ip_id, country, package, size) %>%
     mutate(size_mb = size / 2^20) %>%
     filter (size_mb <= 0.5) %>%
     print
# Your call to filter() goes here
## -------------------------------------------------------------------------------------


## chain4.R script ---------------------------------------------------------------------
# arrange() the result by size_mb, in descending order.
#
# If you want your results printed to the console, add
# print to the end of your chain.

cran %>%
     select(ip_id, country, package, size) %>%
     mutate(size_mb = size / 2^20) %>%
     filter(size_mb <= 0.5) %>%
     arrange(desc(size_mb)) %>%
     print
# Your call to arrange() goes here
## -------------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
#- 2 Tidying Data with tidyr

## In this lesson, you'll learn how to tidy your data with the tidyr package.
## Parts of this lesson will require the use of dplyr. If you don't have a basic knowledge of dplyr,
## you should exit this lesson and begin with the dplyr lessons from earlier in the course.

library(tidyr)

## The author of tidyr, Hadley Wickham, discusses his philosophy of tidy data in 
## his 'Tidy Data' paper:
## http://vita.had.co.nz/papers/tidy-data.pdf
## This paper should be required reading for anyone who works with data, but it's 
## not required in order to complete this lesson.

## Tidy data is formatted in a standard way that facilitates exploration and 
## analysis and works seamlessly with other tidy data tools. Specifically, tidy 
## data satisfies three conditions:
## 1) Each variable forms a column
## 2) Each observation forms a row
## 3) Each type of observational unit forms a table

## The first problem is when you have column headers that are values, not variable 
## names. I've created a simple dataset called 'students' that demonstrates 
## this scenario. Type students to take a look.

students
  #grade male female
#1     A    1      5
#2     B    5      0
#3     C    5      2
#4     D    5      5
#5     E    7      4

## The first column represents each of five possible grades that students could 
## receive for a particular class. The second and third columns give the number 
## of male and female students, respectively, that received each grade.

## This dataset actually has three variables: grade, sex, and count. The first 
## variable, grade, is already a column, so that should remain as it is. 
## The second variable, sex, is captured by the second and third column headings. 
## The third variable, count, is the number of students for each combination of 
## grade and sex.

## To tidy the students data, we need to have one column for each of these three 
## variables. We'll use the gather() function from tidyr to accomplish this. Pull 
## up the documentation for this function with ?gather.

## Using the help file as a guide, call gather() with the following arguments 
## (in order): students,sex, count, -grade. Note the minus sign before grade, 
## which says we want to gather all columns EXCEPT grade.

gather(students,sex,count,-grade)
#grade    sex count
#1      A   male     1
#2      B   male     5
#3      C   male     5
#4      D   male     5
#5      E   male     7
#6      A female     5
#7      B female     0
#8      C female     2
#9      D female     5
#10     E female     4

## Each row of the data now represents exactly one observation, characterized by 
## a unique combination of the grade and sex variables. Each of our variables 
## (grade, sex, and count) occupies exactly one column. That's tidy data!

## It's important to understand what each argument to gather() means. The data 
## argument,students, gives the name of the original dataset. The key and value 
## arguments -- sex and count, respectively -- give the column names for our 
## tidy dataset. The final argument,-grade, says that we want to gather all 
## columns EXCEPT the grade column (since grade is already a proper column variable.)

## The second messy data case we'll look at is when multiple variables are stored 
## in one column. Type students2 to see an example of this.

students2
  #grade male_1 female_1 male_2 female_2
#1     A      3        4      3        4
#2     B      6        4      3        5
#3     C      7        4      3        8
#4     D      4        0      8        1
#5     E      1        1      2        7

## This dataset is similar to the first, except now there are two separate classes, 
## 1 and 2,and we have total counts for each sex within each class. students2 
## suffers from the same messy data problem of having column headers that are 
## values (male_1, female_1, etc.) and not variable names (sex, class, and count).

## However, it also has multiple variables stored in each column (sex and class), 
## which is another common symptom of messy data. Tidying this dataset will be a 
## two step process.

## Let's start by using gather() to stack the columns of students2, like we just 
## did with students. This time, name the 'key' column sex_class and the 'value' 
## column count. Save the result to a new variable called res. Consult ?gather 
## again if you need help.

res <-gather(students2, sex_class, count, -grade)

## That got us half way to tidy data, but we still have two different variables, 
## sex and class, stored together in the sex_class column. tidyr offers a convenient 
## separate() function for the purpose of separating one column into multiple columns. 
## Pull up the help file for separate() now.

separate(data = res, col = sex_class,into = c("sex","class"))
   #grade    sex class count
#1      A   male     1     3
#2      B   male     1     6
#3      C   male     1     7
#4      D   male     1     4
#5      E   male     1     1
#6      A female     1     4
#7      B female     1     4
#8      C female     1     4
#9      D female     1     0
#10     E female     1     1
#11     A   male     2     3
#12     B   male     2     3
#13     C   male     2     3
#14     D   male     2     8
#15     E   male     2     2
#16     A female     2     4
#17     B female     2     5
#18     C female     2     8
#19     D female     2     1
#20     E female     2     7

## Conveniently, separate() was able to figure out on its own how to separate 
## the sex_class column. Unless you request otherwise with the 'sep' argument, 
## it splits on non-alphanumeric values. In other words, it assumes that the 
## values are separated by something other than a letter or number 
## (in this case, an underscore.)

## Tidying students2 required both gather() and separate(), causing us to save an
## intermediate result (res). However, just like with dplyr, you can use the 
## %>% operator to chain multiple function calls together.


## script1.R script ---------------------------------------------------------------------
# Repeat your calls to gather() and separate(), but this time
# use the %>% operator to chain the commands together without
# storing an intermediate result.
#
# If this is your first time seeing the %>% operator, check
# out ?chain, which will bring up the relevant documentation.
# You can also look at the Examples section at the bottom
# of ?gather and ?separate.
#
# The main idea is that the result to the left of %>%
# takes the place of the first argument of the function to
# the right. Therefore, you OMIT THE FIRST ARGUMENT to each
# function.
#
students2 %>%
     gather(sex_class, count, -grade) %>%
     separate( col = sex_class,into = c("sex","class")) %>%
     print

## --------------------------------------------------------------------------------------


students3
    #name    test class1 class2 class3 class4 class5
#1  Sally midterm      A   <NA>      B   <NA>   <NA>
#2  Sally   final      C   <NA>      C   <NA>   <NA>
#3   Jeff midterm   <NA>      D   <NA>      A   <NA>
#4   Jeff   final   <NA>      E   <NA>      C   <NA>
#5  Roger midterm   <NA>      C   <NA>   <NA>      B
#6  Roger   final   <NA>      A   <NA>   <NA>      A
#7  Karen midterm   <NA>   <NA>      C      A   <NA>
#8  Karen   final   <NA>   <NA>      C      A   <NA>
#9  Brian midterm      B   <NA>   <NA>   <NA>      A
#10 Brian   final      B   <NA>   <NA>   <NA>      C

## In students3, we have midterm and final exam grades for five students, 
## each of whom were enrolled in exactly two of five possible classes.

## The first variable, name, is already a column and should remain as it is. 
## The headers of the last five columns, class1 through class5, are all different 
## values of what should be a class variable. The values in the test column, midterm 
## and final, should each be its own variable containing the respective grades for 
## each student.

## This will require multiple steps, which we will build up gradually using %>%. 
## Edit the R script, save it, then type submit() when you are ready. Type 
## reset() to reset the script to its original state.


## script2.R script ---------------------------------------------------------------------
# Call gather() to gather the columns class1
# through class5 into a new variable called class.
# The 'key' should be class, and the 'value'
# should be grade.
#
# tidyr makes it easy to reference multiple adjacent
# columns with class1:class5, just like with sequences
# of numbers.
#
# Since each student is only enrolled in two of
# the five possible classes, there are lots of missing
# values (i.e. NAs). Use the argument na.rm = TRUE
# to omit these values from the final result.
#
# Remember that when you're using the %>% operator,
# the value to the left of it gets inserted as the
# first argument to the function on the right.
#
# Consult ?gather and/or ?chain if you get stuck.
#
students3 %>%
     gather(class,grade,-c(name,test),class1:class5 , na.rm = TRUE) %>%
     print
## --------------------------------------------------------------------------------------



## script3.R script ---------------------------------------------------------------------
# This script builds on the previous one by appending
# a call to spread(), which will allow us to turn the
# values of the test column, midterm and final, into
# column headers (i.e. variables).
#
# You only need to specify two arguments to spread().
# Can you figure out what they are? (Hint: You don't
# have to specify the data argument since we're using
# the %>% operator.
#
students3 %>%
     gather(class, grade, class1:class5, na.rm = TRUE) %>%
     spread(test,grade) %>%
     print
## --------------------------------------------------------------------------------------

## Lastly, we want the values in the class column to simply be 1, 2, ..., 5 and not
## class1, class2, ..., class5. We can use the parse_number() function from readr to
## accomplish this. To see how it works, try parse_number("class5").

parse_number("class5")
# [1] 5

## script4.R script ---------------------------------------------------------------------
# We want the values in the class columns to be
# 1, 2, ..., 5 and not class1, class2, ..., class5.
#
# Use the mutate() function from dplyr along with
# parse_number(). Hint: You can "overwrite" a column
# with mutate() by assigning a new value to the existing
# column instead of creating a new column.
#
# Check out ?mutate and/or ?parse_number if you need
# a refresher.
#
students3 %>%
     gather(class, grade, class1:class5, na.rm = TRUE) %>%
     spread(test, grade) %>%
     mutate(class = parse_number(class))%>%
     ### Call to mutate() goes here %>%
     print
## --------------------------------------------------------------------------------------

## The fourth messy data problem we'll look at occurs when multiple observational 
## units are stored in the same table. students4 presents an example of this. 
## Take a look at the data now.

students4
    #id  name sex class midterm final
#1  168 Brian   F     1       B     B
#2  168 Brian   F     5       A     C
#3  588 Sally   M     1       A     C
#4  588 Sally   M     3       B     C
#5  710  Jeff   M     2       D     E
#6  710  Jeff   M     4       A     C
#7  731 Roger   F     2       C     A
#8  731 Roger   F     5       B     A
#9  908 Karen   M     3       C     C
#10 908 Karen   M     4       A     A

## students4 is almost the same as our tidy version of students3. The only 
## difference is that students4 provides a unique id for each student, as well 
## as his or her sex (M = male; F = female).

## At first glance, there doesn't seem to be much of a problem with students4. 
## All columns are variables and all rows are observations. However, notice 
## that each id, name, and sex is repeated twice, which seems quite redundant. 
## This is a hint that our data contains multiple observational units in a 
## single table.

## Our solution will be to break students4 into two separate tables -- one containing
## basic student information (id, name, and sex) and the other containing grades (id,
## class, midterm, final).


## script5.R script ---------------------------------------------------------------------
# Complete the chained command below so that we are
# selecting the id, name, and sex column from students4
# and storing the result in student_info.
#
student_info <- students4 %>%
     select(id,name,sex) %>%
     print
## --------------------------------------------------------------------------------------

## script6.R script ---------------------------------------------------------------------
# Add a call to unique() below, which will remove
# duplicate rows from student_info.
#
# Like with the call to the print() function below,
# you can omit the parentheses after the function name.
# This is a nice feature of %>% that applies when
# there are no additional arguments to specify.
#
student_info <- students4 %>%
     select(id, name, sex) %>%
     unique(incomparables = FALSE)%>%
     ### Your code here %>%
     print
## --------------------------------------------------------------------------------------

## script7.R script ---------------------------------------------------------------------
# select() the id, class, midterm, and final columns
# (in that order) and store the result in gradebook.
#
gradebook <- students4 %>%
     select(id, class, midterm,final)%>%
     ### Your code here %>%
     print
## --------------------------------------------------------------------------------------

## It's important to note that we left the id column in both tables. In the world of
## relational databases, 'id' is called our 'primary key' since it allows us to connect
## each student listed in student_info with their grades listed in gradebook. Without a
## unique identifier, we might not know how the tables are related. (In this case, we
## could have also used the name variable, since each student happens to have a unique
## name.)

## The fifth and final messy data scenario that we'll address is when a single
## observational unit is stored in multiple tables. It's the opposite of the 
## fourth problem.

## To illustrate this, we've created two datasets, passed and failed. Take a 
## look at passed now.

passed
   #name class final
#1 Brian     1     B
#2 Roger     2     A
#3 Roger     5     A
#4 Karen     4     A


failed
   #name class final
#1 Brian     5     C
#2 Sally     1     C
#3 Sally     3     C
#4  Jeff     2     E
#5  Jeff     4     C
#6 Karen     3     C

## Teachers decided to only take into consideration final exam grades in 
## determining whether students passed or failed each class. As you may have 
## inferred from the data, students passed a class if they received a final 
## exam grade of A or B and failed otherwise.

## The name of each dataset actually represents the value of a new variable 
## that we will call 'status'. Before joining the two tables together, we'll 
## add a new column to each containing this information so that it's not lost 
## when we put everything together.

## Use dplyr's mutate() to add a new column to the passed table. The column 
## should be called status and the value, "passed" (a character string), 
## should be the same for all students. 'Overwrite' the current version of 
## passed with the new one.

passed <- mutate(passed,status = "passed")

## Now, do the same for the failed table, except the status column should 
## have the value "failed" for all students.

failed <- mutate(failed,status = "failed")

## Now, pass as arguments the passed and failed tables (in order) to the dplyr 
## function bind_rows(), which will join them together into a single unit. Check 
## ?bind_rows if you need help.
## Note: bind_rows() is only available in dplyr 0.4.0 or later. If you have an 
## older version of dplyr, please quit the lesson, update dplyr, then restart the 
## lesson where you left off. If you're not sure what version of dplyr you have, 
## type packageVersion('dplyr').

bind_rows(passed,failed)

## Of course, we could arrange the rows however we wish at this point, but 
## the important thing is that each row is an observation, each column is 
## a variable, and the table contains a single observational unit. Thus, the 
## data are tidy.

## We've covered a lot in this lesson. Let's bring everything together and 
## tidy a real dataset.

## The SAT is a popular college-readiness exam in the United States that 
## consists of three sections: critical reading, mathematics, and writing. 
## Students can earn up to 800 points on each section. This dataset presents the 
## total number of students, for each combination of exam section and sex, within 
## each of six score ranges. It comes from the 'Total Group Report 2013', which 
## can be found here:
## http://research.collegeboard.org/programs/sat/data/cb-seniors-2013


## I've created a variable called 'sat' in your workspace, which contains 
## data on all college-bound seniors who took the SAT exam in 2013. Print 
## the dataset now.

sat
# A tibble: 6 x 10
  #score_range read_male read_fem read_total math_male math_fem math_total write_male
        #<chr>     <int>    <int>      <int>     <int>    <int>      <int>      <int>
#1     700-800     40151    38898      79049     74461    46040     120501      31574
#2     600-690    121950   126084     248034    162564   133954     296518     100963
#3     500-590    227141   259553     486694    233141   257678     490819     202326
#4     400-490    242554   296793     539347    204670   288696     493366     262623
#5     300-390    113568   133473     247041     82468   131025     213493     146106
#6     200-290     30728    29154      59882     18788    26562      45350      32500
# ... with 2 more variables: write_fem <int>, write_total <int>



## script8.R script ---------------------------------------------------------------------
# Accomplish the following three goals:
#
# 1. select() all columns that do NOT contain the word "total",
# since if we have the male and female data, we can always
# recreate the total count in a separate column, if we want it.
# Hint: Use the contains() function, which you'll
# find detailed in 'Special functions' section of ?select.
#
# 2. gather() all columns EXCEPT score_range, using
# key = part_sex and value = count.
#
# 3. separate() part_sex into two separate variables (columns),
# called "part" and "sex", respectively. You may need to check
# the 'Examples' section of ?separate to remember how the 'into'
# argument should be phrased.
#
sat %>%
     select(-contains("total")) %>%
     gather(part_sex,count, -score_range) %>%
     separate(part_sex,c("part","sex"))%>%
     ### <Your call to separate()> %>%
     print
## --------------------------------------------------------------------------------------


## script9.R script ---------------------------------------------------------------------
# Append two more function calls to accomplish the following:
#
# 1. Use group_by() (from dplyr) to group the data by part and
# sex, in that order.
#
# 2. Use mutate to add two new columns, whose values will be
# automatically computed group-by-group:
#
#   * total = sum(count)
#   * prop = count / total
#
sat %>%
     select(-contains("total")) %>%
     gather(part_sex, count, -score_range) %>%
     separate(part_sex, c("part", "sex")) %>%
     group_by(part,sex)%>%
     ### <Your call to group_by()> %>%
     mutate(total = sum(count),
            prop = count / total)%>% 
     print
## --------------------------------------------------------------------------------------



