## Loading the required libraries
library(plyr)
library(dplyr)
library(tidyr)

##Reading the test data, using read.table for text files
testX <- read.table("./cleaningQ4/UCIHARDataset/test/X_test.txt")
testY <- read.table("./cleaningQ4/UCIHARDataset/test/y_test.txt")
testSubject <- read.table("./cleaningQ4/UCIHARDataset/test/subject_test.txt")

##Reading the training data, using read.table for text files
trainX <- read.table("./cleaningQ4/UCIHARDataset/train/X_train.txt")
trainY <- read.table("./cleaningQ4/UCIHARDataset/train/y_train.txt")
trainSubject <- read.table("./cleaningQ4/UCIHARDataset/train/subject_train.txt")

##Merging data on basis of various rows and columns
finalSubject <- rbind(trainSubject, testSubject)
finalX <- rbind(trainX,testX)
finalY <- rbind(trainY, testY)

##setting names to the subject and activity data(Y)
names(finalSubject) <- c("subject")
names(finalY) <- c("activity")


##Reading the activities and features

activityLabels <- read.table("./cleaningQ4/UCIHARDataset/activity_labels.txt")
features <- read.table("./cleaningQ4/UCIHARDataset/features.txt")

##Setting names to the features data(X)
names(finalX) <- features$V2

##Merging the training and test data sets with all required names and checking dimensions
coreData <- cbind(finalSubject, finalY)
finalMergedData <- cbind(finalX, coreData)
dim(finalMergedData)

##Mean and standard deviation for each measurement
##Subsetting the names first and then subset the finalmerged data
##Using grep to find the patterns of mean and std, removing // to obtain functions
subNames <- features$V2[grep("mean\\(\\)|std\\(\\)", features$V2)]
finalNames <- c(as.character(subNames), "activity","subject")
finalMergedData <- subset(finalMergedData, select = finalNames)
dim(finalMergedData)

##Descriptive data names for the activity labels
activityLabels <- read.table("./cleaningQ4/UCIHARDataset/activity_labels.txt")
finalMergedData$activity<-factor(finalMergedData$activity,labels=activityLabels[,2])
head(finalMergedData$activity,10)


##Labelling the dataset with descriptive names 
names(finalMergedData) <- gsub("^t","time",names(finalMergedData))
names(finalMergedData) <- gsub("^f","frequency",names(finalMergedData))
names(finalMergedData) <- gsub("^[Aa]cc","Accelerometer",names(finalMergedData))
names(finalMergedData) <- gsub("^[Gg]yro","Gyroscope",names(finalMergedData))
names(finalMergedData) <- gsub("^[Mm]ag","Magnitude",names(finalMergedData))
names(finalMergedData) <- gsub("^[Bb]odyBody","Body",names(finalMergedData))
names(finalMergedData)----##To check
    
##Creating a secondary data set
    aggregate()
tidyData <- aggregate(. ~subject + activity, finalMergedData, mean)
tidyData <- tidyData[order(tidyData$subject,tidyData$activity),]
write.table(tidyData, file = "tidyData.txt", row.names = FALSE)
