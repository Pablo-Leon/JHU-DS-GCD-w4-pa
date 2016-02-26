#!/usr/bin/R
# (utf8)
#
# run_analysis.R -- Programming Assignment by :
#     Pablo León (p.leon@ieee.org)
#
#


######################
message("############# Libraries")
########

library(dplyr)


######################
message("############# Download Data")
########

sWd <-getwd()
message( "CWD:[", sWd, "]")

sZipDir <- file.path(sWd, "zip")
sInDataset <- "UCI_HAR_Dataset"
sPathInDatasetZip <- file.path(sZipDir, paste0(sInDataset, ".zip"))

if (!dir.exists(sZipDir)) {
  dir.create(sZipDir, FALSE)

  sUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  res <- download.file(sUrl, sPathInDatasetZip, mode = "wb")
  message( "Download: sUrl:[", sUrl, "] sPathInDatasetZip:[", sPathInDatasetZip, "] res:[", res, "]")
  
}

sDataDir <- file.path(sWd, "data")

if (!dir.exists(sDataDir)) {
  dir.create(sDataDir, FALSE)
  
  setwd(sDataDir)
  res <- unzip(sPathInDatasetZip)
  file.rename("UCI HAR Dataset", sInDataset)
  message( "Unzip: res:[", res, "]")
  setwd(sWd)
}


######################
message("############# Reformating Data")
########

sBaseDir <- file.path(sDataDir, sInDataset)

message( "---- Var Names (features.txt)")
if (TRUE) {
  dfFeatures <- read.table(file.path(sBaseDir, "features.txt")
                           ,stringsAsFactors = FALSE
                           ,col.names = c("Position","Label")
                           ,sep=" "
                           )
  message( "    (features.txt) done")
  
  # *** (4) *** Appropriately labels the data set with descriptive variable names.
  # TODO : this is inneficient: should nest the calls or write a function that does it value by value
  dfFeatures$Label2 <- sub("^t", "Time", dfFeatures$Label)
  dfFeatures$Label2 <- sub("^f", "Frequency", dfFeatures$Label2)
  dfFeatures$Label2 <- sub("Acc", "Acceleration", dfFeatures$Label2)
  dfFeatures$Label2 <- sub("Mag", "Magnitude", dfFeatures$Label2)
  dfFeatures$Label2 <- sub("jerk", "Jerk", dfFeatures$Label2)
  dfFeatures$Label2 <- sub("-mean[(][)]-(.*)", "\\1_Mean", dfFeatures$Label2)
  dfFeatures$Label2 <- sub("-std[(][)]-(.*)", "\\1_StdDev", dfFeatures$Label2)
  
  # dfFeatures$Label2 <- sub("-(\\w+)\\(\\)-?", "_\\1", dfFeatures$Label)
  dfFeatures$Label2 <- gsub("[,()]", "", dfFeatures$Label2)

  message( "    Label2 done")
  
  dfFeatures <- tbl_df(dfFeatures)
  View(dfFeatures)

  # *** (2) *** Extracts only the measurements on the mean and 
  #             standard deviation for each measurement.
  vSubFeatures <- grep("-mean\\(\\)-|-std\\(\\)-", dfFeatures$Label)
}


message( "---- Activity Names (activity_labels.txt)")
if (TRUE) {
  dfActivities <- read.table(file.path(sBaseDir, "activity_labels.txt")
                           ,stringsAsFactors = FALSE
                           ,col.names = c("ActivityCode","ActivityLabel")
  )
  
  
  dfActivities <- tbl_df(dfActivities)
  View(dfActivities)
}

message( "---- Train&Test Data ( train/ X_*.txt , y_*, subject_*.txt)")

sPrefix <- ""
# sPrefix <- "head."

vSets <- c("train", "test")
# vSets <- c("train")

dfResult <- data.frame()

for (i in 1:length(vSets) ) {
  sSet <- vSets[i]
  message("sSet:[", sSet, "]")
  sSetDir <- file.path(sBaseDir, sSet)

  dfSetX <- read.table(file.path(sSetDir, paste0(sPrefix, "X_", sSet, ".txt"))
                         ,header= FALSE
                         ,col.names = dfFeatures$Label2
  )
  # View(dfSetX)

  dfSetY <- read.table(file.path(sSetDir, paste0(sPrefix, "y_", sSet, ".txt"))
                         ,header= FALSE
                         ,col.names = c("ActivityCode")
  )
  # View(dfSetY)
  
  dfSetS <- read.table(file.path(sSetDir, paste0(sPrefix, "subject_", sSet, ".txt"))
                         ,header= FALSE
                         ,col.names = c("Subject")
  )
  # View(dfSetS)


  # *** (3) *** Uses descriptive activity names to name the activities in 
  #             the data set
  dfSetAll <- cbind(sSet,
                merge(dfActivities, dfSetY)$ActivityLabel, 
                dfSetS, 
                dfSetX[vSubFeatures]
                )
  # View(dfSetAll)
  
  # *** (1) *** Merges the training and the test sets to create one data set.
  if (nrow(dfResult) == 0) {
    dfResult <- dfSetAll
  } else {
    dfResult <- rbind(dfResult, dfSetAll)
  }
}
# *** (4) *** Appropriately labels the data set with descriptive variable names.
names(dfResult)[1:2] <- c("Set", "Activity")
View(dfResult)


######################
# *** (5) *** From the data set in step 4, creates a second, 
#             independent tidy data set with the average of each variable for 
#             each activity and each subject.
message("############# Averages DataSet")
########

dfResult <- tbl_df(dfResult)

dfAverages <- dfResult %>% 
    group_by(Subject, Activity) %>% 
    summarize_each_(funs(mean), names(dfResult)[-1]) %>%
    arrange(Subject, Activity)
View(dfAverages)


######################
# Variables names file
# 
# 
message("############# Result Variable Names")
########

sOutDir <- file.path(sWd, "output")
if (!dir.exists(sOutDir)) {
  dir.create(sOutDir, FALSE)
}  
write.table(dfResult, file.path(sOutDir, "HAR_REDUX.txt"),quote=FALSE , col.names = TRUE, row.names = FALSE)
write.table(names(dfResult), file.path(sOutDir, "variables.txt"),quote=FALSE , col.names = FALSE)
write.table(dfAverages, file.path(sOutDir, "HAR_AVERAGES.txt"),quote=FALSE , col.names = TRUE, row.names = FALSE)


#
message("############# END.")
#



