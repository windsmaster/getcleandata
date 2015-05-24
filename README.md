# run_analysis.R
*For "Getting and Cleaning Data" (4 May 2015 - 1 Jun 2015).*

This repository contains an R script <b>run_analysis.R</b> needed for the course project. The script is used for creating a new tidy data set with the average of each measurement for each activity and each subject from the raw data (but only measurements on the mean and standard deviation are used).

Raw data set should be [downloaded](http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) and extracted into the R working directory (in other words, you should have `UCI HAR Dataset` folder in your working directory). 

The script does the following:
* Extracts training and test data on the mean and the standard deviation 
      for each measurement from the initial data files.
* Merges training and test data to create one data set.
* Applies descriptive activity names to the activities in the data set.
* Labels the data set with descriptive variable names.
* Creates an independent tidy data set with the average of each measurement  
      for each activity and each subject.
* Outputs the tidy data set to a txt file in the working directory (`./analysis.txt`)

The generated tidy data set can be read and viewed with this code:
```{r}
analysis <- read.table("./analysis.txt", header=TRUE)
View(analysis)
```
Further details on the data are provided in [CodeBook.md](CodeBook.md)

## Special Remarks
In the raw data set, there are several variables with the "mean" word in their name, such as `meanFreq` or angle data (`gravityMean`, `tBodyAccMean`, `tBodyAccJerkMean`, `tBodyGyroMean`, `tBodyGyroJerkMean`).
I do not include these variables when extracting "the mean and the standard deviation", because meanFreq seems to represent weighted averages and the angle variables seem to use the mean variables as parameters and are themselves not mean or standard deviation variables. Moreover, there are no corresponding standard deviation measurements for these.

