rm(list=ls())
library(foreign)
library(stringr)
library(filesstrings)


# Combining all Delay Discounting data --------------------------------------------------
setwd( "C:/Users/shahidir/Dropbox/Research/Data Processing/Raw Data/Kirby" ) #Sets working directory to folder where the IQDAT files are
allCombined = NULL #Dataset where the files containing ALL will be placed
transposedData = NULL #Dataset containing values to be transposed
allFiles = dir() #Gets directory of all files
numSubjs = length( allFiles )
for (subjIdx in 1:numSubjs) {
  #subjIdx=1
  tmpFile = allFiles[ subjIdx ]
  df= read.table(tmpFile, skip=13, sep=",", header = F) #Imports file assuming IGT description is in place
  
  
  #Error checking to make sure the files are complete, if they are not complete they are moved to a different folder and skipped
  if( (nrow(df)!=27 )) {
    file.move(paste("C:/Users/shahidir/Dropbox/Research/Data Processing/Raw Data/Kirby", tmpFile, sep = "/"), "C:/Users/shahidir/Dropbox/Research/Data Processing/Raw Data/Kirby Incomplete")
    next
  }
  
  fileName<-str_replace_all(tmpFile, fixed("_"), "-") #Replaces all _ with - to maintain consistency in filename
  dashLocation<-lapply(strsplit(fileName, ''), function(fileName) which(fileName == '-')) #Gets location of every dash in the file name
  dashLocation<-unlist(dashLocation) #Converts the list of locations into extractable info
  xpdLocation<-lapply(strsplit(fileName, ''), function(fileName) which(fileName == '.')) #Gets location of .txt in file name
  xpdLocation<-unlist(xpdLocation) #Converts the list into extractable info
  date = substring(fileName, (dashLocation[length(dashLocation)]+1), (xpdLocation[1])-1)
  date<-as.Date(date, "%Y%m%d%H%M")
  if(is.na(date)){
    message(fileName)
    next
  }
  df$date <-date
  temp<-df$V6 #Moves choice_raw to temp dataset
  temp<-t(temp) #Transposes that data
  temp<-as.data.frame(temp) #Converts to data frame
  tempColNames<-colnames(temp) #Gets colnames for later sorting
  temp$subject <- df[1,c("V1")] #Creates a subject column by getting subject id from df
  temp$date <- date #Creates a subject column by getting subject id from df
  temp<-temp[,c("subject","date", tempColNames)] #Orders column ID to place subject first
  #Completes the merging of the files
  allCombined = rbind(allCombined, df) 
  transposedData = rbind(transposedData, temp)
}

colnames(allCombined)[which(names(allCombined) == "V1")] <- "subject_id" 
colnames(allCombined)[which(names(allCombined) == "V2")] <- "trial" 
colnames(allCombined)[which(names(allCombined) == "V3")] <- "question" 
colnames(allCombined)[which(names(allCombined) == "V4")] <- "button" 
colnames(allCombined)[which(names(allCombined) == "V5")] <- "rt" 
colnames(allCombined)[which(names(allCombined) == "V6")] <- "choice_raw" 
colnames(allCombined)[which(names(allCombined) == "V7")] <- "choice_label" 

#Renames all columns to match the prior CARI output
for(i in 3:ncol(transposedData)){
  #i=2
  tempName<-colnames(transposedData)[i]
  tempName<-str_replace_all(tempName, fixed("V"), "c")
  colnames(transposedData)[i]<-tempName
}
#Outputing all data
write.table( allCombined, "Kirby_Combined.txt",row.names=F, col.names=T, sep = "\t", quote=FALSE  )
write.table( transposedData, "Kirby_Transposed.txt",row.names=F, col.names=T, sep = "\t", quote=FALSE  )
