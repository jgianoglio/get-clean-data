# Download the data. A full description of this data is available at:
# http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

#install/load necessary packages
library("data.table", lib.loc="/Library/Frameworks/R.framework/Versions/3.1/Resources/library")
library("dplyr", lib.loc="/Library/Frameworks/R.framework/Versions/3.1/Resources/library")

temp <- tempfile()
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,temp ,method="curl")

dateDownloaded <- date()

# Unzip the file to extract the data text files
unzip(temp, exdir="./data")

# Read data from files into data frames
testData <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
trainData <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
testSubject <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")
trainSubject <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")
testActivity <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
trainActivity <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
features <- read.table("./data/UCI HAR Dataset/features.txt")

# Extract features as character vector
features.names <- as.character(features$V2)

# Label the testData and trainData with descriptive variable names from the features.txt file
setnames(testData, 1:561, features.names)
setnames(trainData, 1:561, features.names)

# extract the rows from the features that corresponds to mean and std
meanStd <- features[(regexpr("mean\\(|std", features$V2, perl = TRUE) > -1), ]
meanStdCols <- meanStd[,1]

# Subset the train and test data sets to extract the same rows for mean and std
testData.meanStd <- testData[,meanStdCols]
trainData.meanStd <- trainData[,meanStdCols]

# Rename column in testSubject and trainSubject
names(testSubject)[1] <- "user"
names(trainSubject)[1] <- "user"

# Rename column in testActivity and trainActivity
names(testActivity)[1] <- "Activity"
names(trainActivity)[1] <- "Activity"

#Replace numeric values for activity with descriptive activity names
testActivity$Activity[testActivity$Activity == "1"] <- "walking"
testActivity$Activity[testActivity$Activity == "2"] <- "walking_upstairs"
testActivity$Activity[testActivity$Activity == "3"] <- "walking_downstairs"
testActivity$Activity[testActivity$Activity == "4"] <- "sitting"
testActivity$Activity[testActivity$Activity == "5"] <- "standing"
testActivity$Activity[testActivity$Activity == "6"] <- "laying"
trainActivity$Activity[trainActivity$Activity == "1"] <- "walking"
trainActivity$Activity[trainActivity$Activity == "2"] <- "walking_upstairs"
trainActivity$Activity[trainActivity$Activity == "3"] <- "walking_downstairs"
trainActivity$Activity[trainActivity$Activity == "4"] <- "sitting"
trainActivity$Activity[trainActivity$Activity == "5"] <- "standing"
trainActivity$Activity[trainActivity$Activity == "6"] <- "laying"


# combine the user ID's from the testSubject with the testData.meanStd
testData.user <- cbind(testSubject, testData.meanStd)

# combine the user ID's from the trainSubject with the trainData.meanStd
trainData.user <- cbind(trainSubject, trainData.meanStd)

# combine the activity labels from the testActivity with the testData.user
testData.user.activity <- cbind(testActivity, testData.user)

# combine the activity labels from the trainActivity with the trainData.user
trainData.user.activity <- cbind(trainActivity, trainData.user)

# combine the trainData and testData sets, and arrange by user ID
fullData <- rbind(testData.user.activity, trainData.user.activity)
fullData <- arrange(fullData, user)


# Average each variable for each activity for each subject
by_activity_user <- group_by(fullData, Activity, user)
fullDataAvg <- by_activity_user %>% summarise_each(funs(mean))

# Need to rename variables to specify that they are averages
varNames <- colnames(fullDataAvg)[3:68]
varNames <- paste("Avg", varNames, sep="")
setnames(fullDataAvg, 3:68, varNames)

# Output fullDataAvg data frame to a file
write.table(fullDataAvg, "activity recognition tidy data.txt")