# 1. A tidy data set as described below, 
# 2. A link to a Github repository with your script for performing the analysis, and 
# 3. A code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. 
# 4. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.  
# 5. You should create one R script called run_analysis.R that does the following.

setwd("C:/Users/root/Documents/rprogramming/datacleaning")
library(plyr)

# Objective 3: Uses descriptive activity names to name the activities in the data set 
# the features, become the headers for xtest + xtrain data
# make R friendly columns 
features <- read.table("UCI HAR Dataset/features.txt")
features[,2] = gsub('[-()]', '', features[,2])
features[,2] = gsub(',', '', features[,2])
features[,2] = tolower(features[,2])

# Objective 1: Merges the training and the test sets to create one data set.
xtrain <- read.table("UCI HAR Dataset/train/X_train.txt")
# the activity labels of the obs, so these need to get into the data in a column
ytrain <- read.table("UCI HAR Dataset/train/y_train.txt")
# the subject in the obs, so these need to get into the data in a column
subjecttrain <- read.table("UCI HAR Dataset/train/subject_train.txt")
colnames(subjecttrain) = c("subject")
colnames(xtrain) = features$V2
train <- cbind(subjecttrain,ytrain,xtrain)

# the test files:
xtest  <- read.table("UCI HAR Dataset/test/X_test.txt")
ytest  <- read.table("UCI HAR Dataset/test/y_test.txt")
subjecttest <- read.table("UCI HAR Dataset/test//subject_test.txt")
colnames(subjecttest) = c("subject")
colnames(xtest) = features$V2
test <- cbind(subjecttest,ytest,xtest)

# make the big test + train DF
testtrain<- rbind(test,train)

# Objective 4: Appropriately labels the data set with descriptive variable names. 
# make human readable activity labels and merge them onto the data frame:
activitylabels <- read.table("UCI HAR Dataset/activity_labels.txt")
colnames(activitylabels) = c("activitycode","activityname")
alldata <- merge(activitylabels, testtrain, by.x= 'activitycode', by.y = 'V1',all = TRUE)

# 2 Extracts only the measurements on the mean and standard deviation for each measurement. 
mean_std_columns <- grep("mean$|std$", names(alldata), value = TRUE)
tidydetails <- alldata[,c(mean_std_columns,"activityname","subject")]


# Objective 5: From the data set in step 4, creates a second, independent tidy data set 
# with the average of each variable for each activity and each subject.

tidymeandata <- aggregate(tidydetails[,mean_std_columns], list(activity = tidydetails$activityname, subject =tidydetails$subject), mean)

write.table(tidymeandata, "tidymeandata.txt", sep=" ")
