# The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.
# 
# One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:
#   
#   http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
# 
# Here are the data for the project:
#   
#   https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
# 
# You should create one R script called run_analysis.R that does the following.
# 
# Merges the training and the test sets to create one data set.
# Extracts only the measurements on the mean and standard deviation for each measurement.
# Uses descriptive activity names to name the activities in the data set
# Appropriately labels the data set with descriptive variable names.
# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

if (!require("stringr")) {
  install.packages("stringr")
  require("stringr")
}

# 1. Merges the training and the test sets to create one data set.

testSubjects <- read.table("test/subject_test.txt", col.names="subject")
testLabels <- read.table("test/y_test.txt", col.names="label")
testData <- read.table("test/X_test.txt")

trainLabels <- read.table("train/y_train.txt", col.names="label")
trainSubjects <- read.table("train/subject_train.txt", col.names="subject")
trainData <- read.table("train/X_train.txt")

test <- cbind(testSubjects, testLabels, testData)
train <- cbind(trainSubjects, trainLabels, trainData)
data <- rbind(test, train)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
features <- read.table("features.txt", strip.white=TRUE, stringsAsFactors=FALSE)
featuresMeanStd <- features[grep("mean\\(\\)|std\\(\\)", features$V2), ]

dataMeanStd <- data[, c(1, 2, featuresMeanStd$V1+2)]

# 3. Uses descriptive activity names to name the activities in the data set
labels <- read.table("activity_labels.txt", stringsAsFactors=FALSE)
dataMeanStd$label <- labels[dataMeanStd$label, 2]

# 4. Appropriately labels the data set with descriptive variable names.
niceNames <- c("subject", "label", features.mean.std$V2)
niceNames <- str_to_lower(gsub("[^[:alpha:]]", "", niceNames))
colnames(dataMeanStd) <- niceNames

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable 
# for each activity and each subject.
aggr.data <- aggregate(
  dataMeanStd[, 3:ncol(dataMeanStd)],
  by=list(subject = dataMeanStd$subject, 
  label = dataMeanStd$label),
  mean
  )

write.table(
  format(aggr.data, scientific=T), 
  "tidy_data_set.txt",
  row.names = FALSE, 
  quote = 2
  )
