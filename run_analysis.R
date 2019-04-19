

if(!file.exists("./data")){dir.create("./data")}  ##Download the file
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip",method="curl")

unzip(zipfile="./data/Dataset.zip",exdir="./data")  ##Unzip the file
path_rf <- file.path("./data" , "UCI HAR Dataset")
files<-list.files(path_rf, recursive=TRUE)
files

##Reading tables - xtrain / ytrain, subject train:
xtrn=read.table(file.path(path_rf,"train","x_train.txt"),header = FALSE)
ytrn = read.table(file.path(path_rf, "train","y_train.txt"),header = FALSE)
sub_train = read.table(file.path(path_rf, "train", "subject_train.txt"),header = FALSE)

##Reading the testing tables
xt = read.table(file.path(path_rf, "test", "X_test.txt"),header = FALSE)
yt = read.table(file.path(path_rf, "test", "y_test.txt"),header = FALSE)
s_test = read.table(file.path(path_rf, "test", "subject_test.txt"),header = FALSE)

##Read the features data
f = read.table(file.path(path_rf, "features.txt"),header = FALSE)

##Read activity labels data
al = read.table(file.path(path_rf, "activity_labels.txt"),header = FALSE)


##Create Column Values to the Train, Test, subject and activity data
colnames(xtrn) = f[,2]
colnames(ytrn) = "activityId"
colnames(sub_train) = "subjectId"
colnames(xt) = f[,2]
colnames(yt) = "activityId"
colnames(s_test) = "subjectId"
colnames(al) <- c('activityId','activityType')

##Merging the train and test data
mrg_trn = cbind(ytrn, sub_train, xtrn)
mrg_t = cbind(yt, s_test, xt)

##Create the main data table merging both tables
setallinone = rbind(mrg_trn, mrg_t)
colNames = colnames(setallinone)

##Need to get a subset of all the mean and standards
mean_and_std = (grepl("activityId" , colNames) | grepl("subjectId" , colNames) | grepl("mean.." , colNames) | grepl("std.." , colNames))

##A subtset created to get the required dataset
setForMeanAndStd <- setallinone[ , mean_and_std == TRUE]
setWithActivityNames = merge(setForMeanAndStd, al, by='activityId', all.x=TRUE)

##New tidy set created
secTidySet <- aggregate(. ~subjectId + activityId, setWithActivityNames, mean)
secTidySet <- secTidySet[order(secTidySet$subjectId, secTidySet$activityId),]

##write the ouput to a text file
write.table(secTidySet, "secTidySet.txt", row.name=FALSE)
