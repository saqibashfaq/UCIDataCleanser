preparedataset<-function(fileUrl,SubjectUrl,YUrl){
  maindata <- read.table(fileUrl,quote="\"")
  subjectdata<-read.table(SubjectUrl,quote="\"")
  ydata<-read.table(YUrl,quote="\"")
  output<-cbind(maindata,subjectdata,ydata)
  return(output)
}
combiner<-function()
{
  print("Step 1 Combining Test and Train Data Started...")
  print("Step 1.1 Reading TestData Started...")
  testdata<-preparedataset ("./UCI HAR Dataset/test/X_test.txt",  "./UCI HAR Dataset/test/Subject_Test.txt",  "./UCI HAR Dataset/test/y_test.txt")
  print("Step 1.1 Reading TestData Finished...")
  print("Step 1.2 Reading TrainData Started...")
  traindata<-preparedataset("./UCI HAR Dataset/train/X_train.txt","./UCI HAR Dataset/train/Subject_Train.txt","./UCI HAR Dataset/train/y_train.txt")
  print("Step 1.2 Reading TrainData Finished...")
  combineddata<-rbind(testdata,traindata)
  print("Step 1.3 putting the Labels for Subject and Activity Started ...")
  FeaturesfileUrl<-"./UCI HAR Dataset/features.txt"
  featuredata<-read.table(FeaturesfileUrl,quote="\"")
  featuredatanames<-data.frame(featuredata$V2) # ONLY GETTING THE NAMES OF THE FEATURE
  colnames(featuredatanames)<-"extralabels"
  extralabels<-c("Subject_Number","Activity_Number")
  extralabelnames<-data.frame(extralabels)
  tableheaderdata<-rbind(featuredatanames,extralabelnames)
  colnames(combineddata) <- tableheaderdata$extralabels
  print("Step 1.3 putting the Labels for Subject and Activity Finished...")
  print("Step 1 Combining Test and Train Data Finished...")
  
  
  return(combineddata)
}
ActivityNameAppender<-function (combineddata)
{
  activitylabels <- read.table("./UCI HAR Dataset/activity_labels.txt",quote="\"")
  labels<-c("Activity_Number","Activity_Name")
  labelnames<-data.frame(labels)
  colnames(activitylabels) <- labelnames$labels
  sql_string <- "select
                d.*,l.Activity_Name
                from combineddata d LEFT OUTER JOIN activitylabels l ON d.Activity_Number=l.Activity_Number"
  
  output <- sqldf(sql_string,stringsAsFactors = FALSE)
  return(output)
  #columnames<-colnames(output)
}

Subsetter<-function (combineddata)
{
  columnnames<-colnames(combineddata)
  columnames<-data.frame(columnnames)
  meanstring<-columnnames[grep("mean_", columnnames)]
  stdstring<-columnnames[grep("std_", columnnames)]
  Subjectstring<-columnnames[grep("Subject_Number", columnnames)]
  Activitystring<-columnnames[grep("Activity_Name", columnnames)]
  
  meanstring_df<-data.frame(meanstring)
  colnames(meanstring_df)<-"field"
  
  stdstring_df<-data.frame(stdstring)
  colnames(stdstring_df)<-"field"
  Subjectstring_df<-data.frame(Subjectstring)
  colnames(Subjectstring_df)<-"field"
  Activitystring_df<-data.frame(Activitystring)
  colnames(Activitystring_df)<-"field"
columnlist<-rbind(Subjectstring_df,Activitystring_df,meanstring_df,stdstring_df)
finaldata<- combineddata[colnames(combineddata) %in% columnlist$field]

return(finaldata)
  
}
average_calculation <- function(inputdata) {
 attach(inputdata)
 output <-aggregate(inputdata[!colnames(inputdata) %in% c('Subject_Number','Activity_Name') ], by=list(Subject_Number,Activity_Name), 
                     FUN=mean, na.rm=TRUE)
  detach(inputdata)
  return (output)
}
run_analysis <- function() {
  library(sqldf)
 combineddata<-combiner()
 print("Step 2 Appending Activity Names started...")
 combineddataappended<-ActivityNameAppender(combineddata)
 print("Step 2 Appending Activity Names finshed...")
 
 print("Step 3 subsetting for only mean and std columns started...")
 subsetdata<-Subsetter(combineddataappended)
 print("Step 3 subsetting for only mean and std columns finished...")
 
 print("Step 4 calculating average for all attributes per subject and activity started...")
 averagedata<-average_calculation(subsetdata)
 print("Step 4 calculating average for all attributes per subject and activity finished...")
 
 print("Step 5 writing out the data to the file...")
 write.table(x=averagedata,file='./UCI HAR Dataset/Result.txt',sep='\t',row.names=FALSE)
 print("Step5 writing out the data to the file Finished...")
 
 print("Data Transformation Completed")
return ()
}
