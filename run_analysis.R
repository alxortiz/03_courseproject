#Step 1 - Read in and combine training & test data sets, and two glossaries

  #Read in 8 source data tables:
    #Test and Train data sets for: Subjects, X data (core data), Y data (activities) [2 X 3 tables]
    #2 glossaries (features & activites)
      testa <- read.table("./UCI HAR Dataset/test/subject_test.txt")
      testb <- read.table("./UCI HAR Dataset/test/X_test.txt")
      testc <- read.table("./UCI HAR Dataset/test/Y_test.txt")
      testd <- read.table("./UCI HAR Dataset/train/subject_train.txt")
      teste <- read.table("./UCI HAR Dataset/train/X_train.txt")
      testf <- read.table("./UCI HAR Dataset/train/Y_train.txt")
      testg <- read.table("./UCI HAR Dataset/activity_labels.txt")
      testh <- read.table("./UCI HAR Dataset/features.txt")

   #Combine test and train data sets (rbind)
      subjectData <- rbind(testa, testd)
          #Give SubjectData the description column name "SubjectID"
          names(subjectData)[1]<-"SubjectID"
      XData <- rbind (testb, teste)
      YData <- rbind (testc, testf)
          # Give YData the description column name "ActivityID"
          names(YData)[1]<-"ActivityID"
  #Combine Subject, X and Y data sets (cbind)                      
      master <- cbind (XData, subjectData, YData)

  #Give Glossaries descriptive headings
      names(testg)[1]<-"ActivityID"
      names(testg)[2]<-"Activity"
      names(testh)[1]<-"FeatureID"
      names(testh)[2]<-"Feature"
      
#Step 2 - Extract Mean and Standard Deviation measurements
      
    #Identify meansurements for mean and standard deviation from features
      #Filter on Mean or Std
      mnstd <- filter(testh, grepl('mean()|std()', Feature))
      #After reviewing data, filter seems overbroad, in that it captured 'meanFreq' values - exclude these:
      mnstdnf <- filter(mnstd, !grepl('meanFreq', Feature))
      #Extract only intended fields (mean, std, as well as Subject ID and Activity)
      flds <- mnstdnf[,1]
      meanstdmaster <- select(master, flds, 562, 563)
      
#Step 3 - replace ActivityIDs with Activty Descriptions
      
      #Use descriptive activity names to name the activities in the data set
      #Replace codes from Y_test with values from activity_lables
      merged <- merge(meanstdmaster, testg, by.x = 68, by.y = "ActivityID", all = TRUE)
      #Drop ActivityID, now that description is included
      merged$ActivityID <- NULL
      
#Step 4 - Rename columns in main data set with 'cleaned' descriptions from Features data set
      
      #Note: SubjectID and Activity were named descriptively at an earlier stage.  This will
       # now add descriptions to the 66 remaining features fields
   
      #Remove parens from Activity names, for clarity and to avoid potential programming issues
        x <- as.vector(mnstdnf$Feature)
        y <- gsub("\\()","", x)

      #Rename columns in 'Merged', so as to apply descriptive headings  
      for (i in 1:length(y)) {
        names(merged)[i] <- y[i]
      }
        
# Step 5: Create Tidy data with averages by SubjectID, Activity and Feature

      #Melt data to create vertical table with SubjectID, Activity, and feature as variable 
        xMelt <- melt(merged, id=c("SubjectID", "Activity"), measure.vars =y)
      #Summarize data to find mean by SubjectID, Activty and Feature/variable
      h <- ddply(xMelt,.(SubjectID, Activity, variable),summarize,avg=mean(value))

# Write table      
    write.table(h, file = "tidy.txt", sep = "\t", quote = FALSE, row.name = FALSE)

      