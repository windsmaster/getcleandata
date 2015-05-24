#####################################################################################################
## This R script reshapes and manipulates the data collected from the accelerometers 
## from the Samsung Galaxy S smartphone during the following experiment:
## http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
## 
## Actual data set for the script:
## http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
##
## Requirements:
## The extracted root data folder ("UCI HAR Dataset") must be placed in the R working directory
## (./UCI HAR Dataset)
##
## The script does the following:
##  1.  Extracts training and test data on the mean and the standard deviation for each measurement
##      from the initial data files.
##  2.  Merges training and test data to create one data set.
##  3.  Applies descriptive activity names to the activities in the data set.
##  4.  Labels the data set with descriptive variable names.
##  5.  Creates an independent tidy data set with the average of each measurement  
##      for each activity and each subject.
##  6.  Outputs the tidy data set to a txt file in the working directory (./analysis.txt)
#####################################################################################################

#-----------------------------------------------------------------------------------------------
## Uncomment this section if you need to redownload the initial data 
#-----------------------------------------------------------------------------------------------
# dataURL <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
# download.file(dataURL, destfile="./rawdata.zip")
# unzip("rawdata.zip", files = NULL, list = FALSE, overwrite = TRUE, junkpaths = FALSE, unzip = "internal", setTimes = FALSE)

message("Running script for the analysis of data in ./UCI HAR Dataset")

#-----------------------------------------------------------------------------------------------
# Loading information about features and activity labels
#-----------------------------------------------------------------------------------------------
message("(1/4) Loading label data...")
activity.labels <- read.table("./UCI HAR Dataset/activity_labels.txt")
features <- read.table("./UCI HAR Dataset/features.txt")

# store a list of indexes of the columns of interest for our analysis (mean and standard deviation)
features.selected <- grep(".*mean\\(\\).*|.*std\\(\\).*", features[,2])

#-----------------------------------------------------------------------------------------------
# Extracting training and test data on the mean and the standard deviation from the initial data files
# (for the sake of optimization we only load into memory the columns of interest)
#-----------------------------------------------------------------------------------------------
message("(2/4) Loading training data...")
filename <- "./UCI HAR Dataset/train/X_train.txt"

# take a few rows of data to see its structure
sample <- read.table(filename, nrows=5) 

# make a list of data columns' "data types"
classes <- sapply(sample, class)  

# mark columns not in features.selected as NULL to not load them
classes[!(features[,1] %in% features.selected)] <- "NULL"  

# extract <training> data on the mean and the standard deviation
train.x <- read.table(filename, colClasses=classes)  # measurements
train.y <- read.table("./UCI HAR Dataset/train/y_train.txt")  # activities
train.subjects <- read.table("./UCI HAR Dataset/train/subject_train.txt")  # subjects

message("(3/4) Loading test data...")
filename <- "./UCI HAR Dataset/test/X_test.txt"

# extract <test> data on the mean and the standard deviation 
# (test and training data have exactly the same structure)
test.x <- read.table(filename, colClasses=classes)  # measurements
test.y <- read.table("./UCI HAR Dataset/test/y_test.txt")  # activities
test.subjects <- read.table("./UCI HAR Dataset/test/subject_test.txt")  # subjects
 
#-----------------------------------------------------------------------------------------------
# Merging the training and the test sets to create one data set
#-----------------------------------------------------------------------------------------------
message("(4/4) Processing data...")

# merge measurements on the mean and standard deviation
data <- rbind(train.x, test.x)
rm(train.x, test.x)

# merge activity data
data.activities <- rbind(train.y, test.y)
rm(train.y, test.y)

# merge subject data
data.subjects <- rbind(train.subjects, test.subjects)
rm(train.subjects, test.subjects)

# merge everything together to form one data set
data <- cbind(A=data.activities[,], S=data.subjects[,], D=data)
rm(data.activities, data.subjects)

#-----------------------------------------------------------------------------------------------
# Applying descriptive activity names to the activities in the data set
#-----------------------------------------------------------------------------------------------
# merge activity labels into the data set while dropping the first column (numeric activity)
data <- merge(activity.labels, data, by=1)[, 2:(ncol(data)+1)]

#-----------------------------------------------------------------------------------------------
# Labelling the data set with descriptive variable names 
#-----------------------------------------------------------------------------------------------
# assign column names
colnames(data) <- c("activity", "subject", as.character(features[features.selected, 2]))

# refine column names by removing illegal symbols, duplications, etc.
colnames(data) <- gsub("(-|BodyBody)", "", colnames(data))
colnames(data) <- gsub("mean\\(\\)", "Mean", colnames(data))
colnames(data) <- gsub("std\\(\\)", "StdDev", colnames(data))
colnames(data) <- gsub("^t", "time", colnames(data))
colnames(data) <- gsub("^f", "freq", colnames(data))
colnames(data) <- gsub("Acc", "Acceleration", colnames(data))
colnames(data) <- gsub("Mag", "Magnitude", colnames(data))
colnames(data) <- gsub("Gyro", "Gyroscope", colnames(data))
colnames(data) <- gsub("([XYZ]$)", "By\\1", colnames(data))

#-----------------------------------------------------------------------------------------------
# Creating an independent tidy data set with the average of each measurement 
# for each activity and each subject
#-----------------------------------------------------------------------------------------------
# calculating each measurement's average for each pair of activity and subject
data.final <- aggregate(data[3:ncol(data)], by=list(subject=data$subject, activity = data$activity), mean)

# saving to file
filename <- "./analysis.txt"
write.table(data.final, file=filename, row.names=FALSE)

message(paste("Processing complete. Tidy data saved to:", filename))

# viewing the saved data set 
analysis <- read.table("./analysis.txt", header=TRUE)
View(analysis)


