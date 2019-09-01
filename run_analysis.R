


library(dplyr)


# Download file

name <- "datafile.zip"
if(!file.exists(filename)){
  url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(url, name, method = "curl")
}

# extracting the file

if(!file.exists("UCI HAR Dataset")){
  unzip(name)
}

# loading all data frames from both folders

features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")


# merging the two sets with have 3 column each

x <- rbind(x_train, x_test)
y <- rbind(y_train, y_test)
Subject <- rbind(subject_train,subject_test)
MergedData <- cbind(Subject, x, y)

# extract only mean and SD

tidy <- MergedData %>% select(subject, code, contains("mean"), contains("std"))

# naming activities in dataset

tidy$code <- activities[tidy$code,2]

# label data sets with random names :D

names(tidy)[2] = "activity"
names(tidy)<-gsub("Acc", "Accelerometer", names(tidy))
names(tidy)<-gsub("Gyro", "Gyroscope", names(tidy))
names(tidy)<-gsub("BodyBody", "Body", names(tidy))
names(tidy)<-gsub("Mag", "Magnitude", names(tidy))
names(tidy)<-gsub("^t", "Time", names(tidy))
names(tidy)<-gsub("^f", "Frequency", names(tidy))
names(tidy)<-gsub("tBody", "TimeBody", names(tidy))
names(tidy)<-gsub("-mean()", "Mean", names(tidy), ignore.case = TRUE)
names(tidy)<-gsub("-std()", "STD", names(tidy), ignore.case = TRUE)
names(tidy)<-gsub("-freq()", "Frequency", names(tidy), ignore.case = TRUE)
names(tidy)<-gsub("angle", "Angle", names(tidy))
names(tidy)<-gsub("gravity", "Gravity", names(tidy))

# creating seperate data

sepData <- tidy %>%
  group_by(subject, activity) %>%
  summarise_all(funs(mean))

write.table(sepData, "S=sepData.txt", row.names = FALSE)

str(FinalData)