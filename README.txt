==================================================================
This repo holds folloving R files:
run_analysis.R
==================================================================

This script takes as input following data:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

And performs following actions with it:
- Merges the training and the test sets to create one data set.
- Extracts only the measurements on the mean and standard deviation for each measurement. 
- Uses descriptive activity names to name the activities in the data set
- Appropriately labels the data set with descriptive variable names. 
- From the data set in previous step, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

==================================================================
How to start the script:

call run() function and give it the path to folder where unzipped input data is situated as "inputdirname" argument