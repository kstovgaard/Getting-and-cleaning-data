# script for preparing the UCI HAR dataset for further analysis
library(dplyr)

# Merge the test and training data sets column-wise
test_x = read.csv("UCI HAR Dataset/test/X_test.txt",header=FALSE, sep="")
train_x = read.csv("UCI HAR Dataset/train/X_train.txt",header=FALSE, sep="")
merged_x = rbind(train_x,test_x)

# Extract measurements on the mean and standard deviation (i.e. mean() and std())
cnames = read.csv("UCI HAR Dataset/features.txt",sep=" ")[,2]
std_mean_cols = grep("std()|mean()",cnames)
filtered_merged_x = merged_x %>% select(std_mean_cols)
colnames(filtered_merged_x)= cnames[std_mean_cols]

# Parse and merge activities (keepiong train/test order)
test_y = read.csv("UCI HAR Dataset/test/y_test.txt",header=FALSE, sep="")
train_y = read.csv("UCI HAR Dataset/train/y_train.txt",header=FALSE, sep="")
merged_y= rbind(train_y,test_y)

# Use descriptive activity names to name the activities in the data set
# activity factors named according to the Readme.txt
activity_names = c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING")
merged_y[,1] = activity_names[merged_y[,1]]

# Parse and merge subjects (keeping train/test order)
subjects_test = read.csv("UCI HAR Dataset/test/subject_test.txt",header=FALSE, sep="")
subjects_train = read.csv("UCI HAR Dataset/train/subject_train.txt",header=FALSE, sep="")
merged_subjects = rbind(subjects_train,subjects_test)

# merging column-wise into: activities, subject, features
merged_data = cbind(merged_y,merged_subjects, merged_x)

# an appropriately label the data set with descriptive variable names. 
header = c("Activity","Subject")
header = append(header,as.character(cnames[std_mean_cols]))
colnames(merged_data) = header

# creates a second, independent tidy data set with the average of each variable for each activity and each subject
mean_grouped_data = aggregate(merged_data[,3:ncol(merged_data)],by=list(activity=merged_data$Activity,subject = merged_data$Subject),mean)

# Ssve to file, as instructed
write.table(mean_grouped_data, "UCI_HAR_tidy.txt", row.names = F)
