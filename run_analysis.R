library(dplyr)

filename <- "getdata_dataset.zip"

## Download and unzip the dataset:
if (!file.exists(filename)){
    fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
    download.file(fileURL, filename, method="curl")
}  
if (!file.exists("UCI HAR Dataset")) { 
    unzip(filename) 
}

#read in train and test data
trainX <- read.table("UCI HAR Dataset/train/X_train.txt")
trainy <- read.table("UCI HAR Dataset/train/y_train.txt")
testX <- read.table("UCI HAR Dataset/test/X_test.txt")
testy <- read.table("UCI HAR Dataset/test/y_test.txt")

#read in y coding
codey <- read.table("UCI HAR Dataset/activity_labels.txt")

#read in X feature names
features <- read.table("UCI HAR Dataset/features.txt")

#read in subject numbers
train_sub <- read.table("UCI HAR Dataset/train/subject_train.txt")
test_sub <- read.table("UCI HAR Dataset/test/subject_test.txt")
subject <- rbind(train_sub, test_sub)
colnames(subject) <- "subject"


#rbind train and test
X <- rbind(trainX, testX)
y <- rbind(trainy, testy)

#rename all columns
colnames(X) <- features$V2
colnames(y) <- c("activity")

#select columns with mean or sd in name
## double escape on parenthesis to only capture columns with "mean()" or "std()"
cols <- grep("mean\\(\\)|std\\(\\)", names(X), value = TRUE) 
X <- X[, cols]

#map y to activity names
y$activity <- factor(y$activity, labels = codey$V2)

#join X and y into one table
df <- cbind(y, X)

#remove punctuation from column names
colnames(df) <- gsub('[[:punct:]]', '', names(df)) 

#append subject
df <- cbind(subject, df)

#lowercase column names
colnames(df) <- tolower(colnames(df))

#create tidy data
tidy_df <- df %>% group_by(subject, activity) %>% summarise_all(funs(mean))

# output to file "tidy_data.txt"
write.table(tidy_df, "tidy_data.txt", row.names = FALSE, 
            quote = FALSE)



