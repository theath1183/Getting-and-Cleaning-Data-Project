## The following script will import test and train data on wearable computing
## and will create a tidy data set that includes the mean of each mean/std
## variable from the original data sets

## Run the following two lines to install the "dplyr" package
## install.packages("dplyr")
## library("dplyr")

## Pulls in data from each file in the train folder
participants <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")
activity <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
data <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
datacolnames <- read.table("./data/UCI HAR Dataset/features.txt")
activitynames <- read.table("./data/UCI HAR Dataset/activity_labels.txt")

x <- append(grep(("mean\\(\\)"), datacolnames[, 2]), grep("std", datacolnames[, 2]))
x <- sort(x)

for(i in 1:nrow(activitynames)) {
    activity[activity == i] <- activitynames[i,2]
}

## Renames the columns of data
participants <- rename(participants, participant = V1)
activity <- rename(activity, activity = V1)
for(i in 1:ncol(data)) {
    colnames(data)[i] <- datacolnames[i, 2]
}

data <- select(data, all_of(x))

traindata <- cbind(participants, activity, data)

## Pulls in data from each file in the train folder
participants <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")
activity <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
data <- read.table("./data/UCI HAR Dataset/test/X_test.txt")

x <- append(grep(("mean\\(\\)"), datacolnames[, 2]), grep("std", datacolnames[, 2]))
x <- sort(x)

for(i in 1:nrow(activitynames)) {
    activity[activity == i] <- activitynames[i,2]
}

## Renames the columns of data
participants <- rename(participants, participant = V1)
activity <- rename(activity, activity = V1)
for(i in 1:ncol(data)) {
    colnames(data)[i] <- datacolnames[i, 2]
}

data <- select(data, all_of(x))

testdata <- cbind(participants, activity, data)

## Compile a single data set from train- and testdata.
mergedata <- rbind(traindata, testdata)

## Clean names of columns in mergedata
names(mergedata) <- tolower(names(mergedata))
names(mergedata) <- gsub("-", "", names(mergedata))
names(mergedata) <- gsub("\\(\\)", "", names(mergedata))

## Create a tidy data set including the mean of each mean/std variable grouped 
## by participant and activity
grp <- group_by(mergedata, participant, activity)
tidydata <- summarize(grp, across(everything(), list(mean)))
names(tidydata) <- names(mergedata)

View(tidydata)

## The following line creates a text file with the tidy data.
## write.table(tidydata, "./tidydata.txt")
