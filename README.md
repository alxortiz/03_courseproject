# 03_courseproject
Getting and Cleaning Data - Course Project

This file explains how the script run_analysis.R was created, based up the basic course project intructions.

**The source data was first reviewed/analysed, to identify and understand the relationship among 8 source tables**

Glossaries:
* activity_labels.txt: 6 rows, 2 columns (activity ID, activity description)
* features.txt: 561 rows, 2 column (feature ID, feature short description)

Data:
* Test Data
    1. subject_test.txt: 2947 rows, 1 column with subjectID
    2. X_test.txt: 2947 rows, with 561 columns (defined in features.txt)
    3. Y_test.txt: 2947 rows, 1 column with activity label (defined in activity_lables.txt)

* Train Data
    1. subject_train.txt: 7352 rows, 1 column with subjectID
    2. X_train.txt: 7352 rows, with 561 columns (defined in features.txt)
    3. Y_train.txt: 7352 rows, 1 column with activity label (defined in activity_lables.txt)

**The script then merges, transforms and summarizes the data, according to the project steps:**

1. Merge the training and the test sets to create one data set.

   Combines test and training data
    * combine subject_test.txt and subject_train.txt
    * combine X_test.txt and X_train.txt
    * combine Y_test.txt and Y_train.txt

    Merges, subject, X and Y files to create single data set

2. Extract only the measurements on the mean and standard deviation for each measurement. 
   * Selects fields with mean and stddev
   * Exlclude8 field names like 'meanFreq', as these appear to be measuring not the mean itself, but the frequency of the mean

3. Use descriptive activity names to name the activities in the data set
   * Replaces codes from Y_test with values from activity_lables, such that data such as "Walking" appears in the data set

4. Appropriately labels the data set with descriptive variable names. 
  * Short descriptions are 'cleaned' to remove parentheses, which could be problematic to the program
  * Columns of limited (mean / std dev) data set are set usign the cleaned descriptions

5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
  * Data is melted, to create a tall, narrow data set
  * Data is summarized, to show averages per Subject ID, Activity and Feature
