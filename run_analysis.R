
# This functuon is invoked by "run()" function to process every set
processOneSet <- function(inputdirname, setname="test") {
  input_path <- paste(inputdirname, "/UCI HAR Dataset/", sep="")
  
  # read activity_labels.txt
  activity_labels_filename <- (paste(input_path, "activity_labels.txt", sep=""))
  activities <- read.table(activity_labels_filename,sep=" ",col.names=c("activityid","activityname"))
  
  # read features.txt (561 entries)
  features_filename <- (paste(input_path, "features.txt", sep=""))
  features <- read.table(features_filename,sep=" ",col.names=c("featureid","featurename"))
  featurenames <- features$featurename
  
  # read set
  
  # read subject_test.txt
  subject_filename <- (paste(input_path, setname, "/subject_", setname, ".txt", sep=""))
  subject <- read.table(subject_filename,sep=" ",col.names=c("subjectid"))
  
  # make id column
  id <- rownames(subject)
  subject <- cbind(id=id, subject)
  
  # read y_test.txt
  y_filename <- (paste(input_path, setname, "/y_", setname,".txt", sep=""))
  y <- read.table(y_filename,sep=" ",col.names=c("lableid"))
  
  # replace ativity ids with activity names
  y2 <- y
  y2[] <- lapply(y, function(x) activities$activityname[match(x, activities$activityid)])
  colnames(y2) <- c("activity")
  y2 <- cbind(id=id, y2)
  
  # read x_test.txt
  x_filename <- (paste(input_path, setname, "/x_", setname, ".txt", sep=""))
  x <- read.table(x_filename, col.names=featurenames)
  
  # filter columns
  x2 <- x[ , which(names(x) %in% grep('[Mm]ean\\.\\.|[Ss]td\\.\\.', names(x), value="True"))]
  colnames(x2)
  x2 <- cbind(id=id, x2)
  
  # join all
  dfList = list(subject, y2, x2)
  j1 <- join_all(dfList)
  names(j1) <- gsub("\\.", "", names(j1))
  j1
}

# This is main function. Run it to perform all tasks of programming assignment.
# Parameters: "inputdirname" - path to folder where folder "UCI HAR Dataset/" is situated. 
run <- function(inputdirname = "C:/Users/Ult/Documents/R/course3progrAssignment") {
  library(plyr)
  library(reshape2)
  data1 <- processOneSet(inputdirname, "test")
  data2 <- processOneSet(inputdirname, "train")
  data3 <- rbind(data1, data2)
  data3 <- data3[ , !(names(data3) %in% "id")]
  
  # save tidy dataset
  filename <- paste(inputdirname, "/out_tidy.txt", sep="")
  write.table(data3, file = filename, row.name=FALSE)
  
  # calc group averages
  df_melt <- melt(data3, id = c("subjectid", "activity"), na.rm = TRUE)
  data4 <- dcast(df_melt, subjectid + activity ~ ..., mean, na.rm = TRUE)
  
  # save averages
  filename <- paste(inputdirname, "/out_means.txt", sep="")
  write.table(data4, file = filename, row.name=FALSE)
}