# Peer-graded Assignment: Getting and Cleaning Data Course Project

# Getting and Cleaning Data Course Project

## The purpose of this project is to demonstrate your ability to collect, work with, 
## and clean a data set. The goal is to prepare tidy data that can be used for later 
## analysis. You will be graded by your peers on a series of yes/no questions related 
## to the project. You will be required to submit: 1) a tidy data set as described 
## below, 2) a link to a Github repository with your script for performing the analysis, 
## and 3) a code book that describes the variables, the data, and any transformations 
## or work that you performed to clean up the data called CodeBook.md. You should also 
## include a README.md in the repo with your scripts. This repo explains how all of 
## the scripts work and how they are connected.

## One of the most exciting areas in all of data science right now is wearable computing 
## - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are 
## racing to develop the most advanced algorithms to attract new users. The data linked 
## to from the course website represent data collected from the accelerometers from 
## the Samsung Galaxy S smartphone. A full description is available at the site where 
## the data was obtained:

## http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
## Here are the data for the project:
## https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
## You should create one R script called run_analysis.R that does the following.

## 1.Merges the training and the test sets to create one data set.
## 2.Extracts only the measurements on the mean and standard deviation for each measurement.
## 3.Uses descriptive activity names to name the activities in the data set
## 4.Appropriately labels the data set with descriptive variable names.
## 5.From the data set in step 4, creates a second, independent tidy data set with 
## the average of each variable for each activity and each subject.

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,"Dataset.zip")
unzip(zipfile = "Dataset.zip")

## Files locations in the hard drive 
filetrain <- "D:\\OneDrive - Universidad de Los Andes\\Google Drive Back Up\\032016\\Academico\\Coursera\\Data Science Specialization\\Getting and Cleaning Data\\Git_Getting_and_Cleaning_Data\\UCI HAR Dataset\\train\\X_train.txt"

fileactivitytrain <- "D:\\OneDrive - Universidad de Los Andes\\Google Drive Back Up\\032016\\Academico\\Coursera\\Data Science Specialization\\Getting and Cleaning Data\\Git_Getting_and_Cleaning_Data\\UCI HAR Dataset\\train\\y_train.txt"

filesubjecttrain <- "D:\\OneDrive - Universidad de Los Andes\\Google Drive Back Up\\032016\\Academico\\Coursera\\Data Science Specialization\\Getting and Cleaning Data\\Git_Getting_and_Cleaning_Data\\UCI HAR Dataset\\train\\subject_train.txt"

filetest <- "D:\\OneDrive - Universidad de Los Andes\\Google Drive Back Up\\032016\\Academico\\Coursera\\Data Science Specialization\\Getting and Cleaning Data\\Git_Getting_and_Cleaning_Data\\UCI HAR Dataset\\test\\X_test.txt"

fileactivitytest <- "D:\\OneDrive - Universidad de Los Andes\\Google Drive Back Up\\032016\\Academico\\Coursera\\Data Science Specialization\\Getting and Cleaning Data\\Git_Getting_and_Cleaning_Data\\UCI HAR Dataset\\test\\y_test.txt"

filesubjecttest <- "D:\\OneDrive - Universidad de Los Andes\\Google Drive Back Up\\032016\\Academico\\Coursera\\Data Science Specialization\\Getting and Cleaning Data\\Git_Getting_and_Cleaning_Data\\UCI HAR Dataset\\test\\subject_test.txt"

filefeatures <- "D:\\OneDrive - Universidad de Los Andes\\Google Drive Back Up\\032016\\Academico\\Coursera\\Data Science Specialization\\Getting and Cleaning Data\\Git_Getting_and_Cleaning_Data\\UCI HAR Dataset\\features.txt"

fileactivity_labels <- "D:\\OneDrive - Universidad de Los Andes\\Google Drive Back Up\\032016\\Academico\\Coursera\\Data Science Specialization\\Getting and Cleaning Data\\Git_Getting_and_Cleaning_Data\\UCI HAR Dataset\\activity_labels.txt"

## Read data from the files locations 

testfile <- read.table(file = filetest,sep = "",header = FALSE)

activitytestfile <- read.table(file = fileactivitytest,sep = "",header = FALSE)

subjecttestfile <- read.table(file = filesubjecttest,sep = "",header = FALSE)

trainfile <- read.table(file = filetrain,sep = "",header = FALSE)

activitytrainfile <- read.table(file = fileactivitytrain,sep = "",header = FALSE)

subjecttrainfile <- read.table(file = filesubjecttrain,sep = "",header = FALSE)

features <- read.table(file = filefeatures,sep = "",header = FALSE)

activity_labels <- read.table(file = fileactivity_labels,sep = "",header = FALSE)

## Join Data from training and testing files

HRecognitionCD <- rbind(testfile,trainfile, stringsAsFactors = FALSE)

Activityvector <- rbind(activitytestfile,activitytrainfile, stringsAsFactors = FALSE)

subjectvector <- rbind(subjecttestfile,subjecttrainfile, stringsAsFactors = FALSE)

## Merge data from activity_labels to activity vector

Activityvector <- merge(activity_labels,Activityvector,by = 'V1')


## Rename variables of the data fames 
names(subjectvector)<- "Subject"

names(HRecognitionCD) <- features[,2]

nombrescolumnas <- names(HRecognitionCD)

## Rename variables using transformations
appropiatenames <- sub("^t","time",nombrescolumnas)

appropiatenames <- sub("Acc","Accelerometer",appropiatenames)

appropiatenames <- sub("Gyro","Gyroscope",appropiatenames)

appropiatenames <- sub("Mag","Euclideannormcalculation",appropiatenames)

appropiatenames <- sub("^f","frecuency",appropiatenames)

names(HRecognitionCD) <- appropiatenames

## Extract the mean and standard deviation variables 
filtermeanstd <- grep("mean|std",nombrescolumnas)

meanandstd <- HRecognitionCD [,filtermeanstd]

## Add Activity and Subject vector to the data set
Activity <- Activityvector[,2]

meanandstd <- cbind(meanandstd,Activity,subjectvector,stringsAsFactors = FALSE)

## Reorganize the data to creates a second, independent tidy data set with the 
## average of each variable for each activity and each subject.

SubjectActivityaggregate <- melt(meanandstd,id = c("Subject","Activity"))

SubjectActivitymean <- aggregate(value ~ .,data = SubjectActivityaggregate,mean)

names(SubjectActivitymean) <- c("Subject","Activity","Variable","Mean")
