library(plyr)


if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip")


unzip(zipfile="./data/Dataset.zip",exdir="./data")


x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")


x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

features <- read.table('./data/UCI HAR Dataset/features.txt')

activityLabels = read.table('./data/UCI HAR Dataset/activity_labels.txt')

colnames(x_train) <- features[,2] 
colnames(y_train) <-"activityId"
colnames(subject_train) <- "subjectId"

colnames(x_test) <- features[,2] 
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"

colnames(activityLabels) <- c('activityId','activityType')


merge_train <- cbind(y_train, subject_train, x_train)
merge_test <- cbind(y_test, subject_test, x_test)
SetAllInOne <- rbind(merge_train, merge_test)


colNames <- colnames(SetAllInOne)

MeanAndStd <- (grepl("activityId" , colNames) | 
                   grepl("subjectId" , colNames) | 
                   grepl("mean.." , colNames) | 
                   grepl("std.." , colNames) 
)


SetForMeanAndStd <- setAllInOne[ , MeanAndStd == TRUE]


SetWithActivityNames <- merge(SetForMeanAndStd, activityLabels,
                              by='activityId',
                              all.x=TRUE)


SecondTidySet <- aggregate(. ~subjectId + activityId, SetWithActivityNames, mean)
SecondTidySet <- SecondTidySet[order(SecondTidySet$subjectId, SecondTidySet$activityId),]


write.table(SecondTidySet, "SecondTidySet.txt", row.name=FALSE)