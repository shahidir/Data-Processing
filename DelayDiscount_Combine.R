rm(list=ls())
library(foreign)
library(stringr)
library(filesstrings)


# Combining all Delay Discounting data --------------------------------------------------
setwd( "C:/Users/shahidir/Dropbox/Research/Data Processing/Raw Data/DelayDiscounting" ) #Sets working directory to folder where the IQDAT files are
delay_discounting_all = NULL #Dataset where the files containing ALL will be placed
delay_discounting_summary = NULL #Dataset where all files not containing ALL will be placed
allFiles = dir() #Gets directory of all files
numSubjs = length( allFiles )
for (subjIdx in 1:numSubjs) {
  #subjIdx=2
  tmpFile = allFiles[ subjIdx ]
  df = read.table(tmpFile)
  #Error checking to make sure the files are complete, if they are not complete they are moved to a different folder and skipped
  if((grepl("ALL", tmpFile)==TRUE) & (nrow(df)!=42 )) {
    file.move(paste("C:/Users/shahidir/Dropbox/Research/Data Processing/Raw Data/DelayDiscounting", tmpFile, sep = "/"), "C:/Users/shahidir/Dropbox/Research/Data Processing/Raw Data/Incomplete DD Data")
    next
  }
  if((grepl("ALL", tmpFile)==FALSE) & (nrow(df)!=7 )) {
    file.move(paste("C:/Users/shahidir/Dropbox/Research/Data Processing/Raw Data/DelayDiscounting", tmpFile, sep = "/"), "C:/Users/shahidir/Dropbox/Research/Data Processing/Raw Data/Incomplete DD Data")
    next
  }
  
  #Completes the merging of the files
  if(grepl("ALL", tmpFile)==TRUE){
    delay_discounting_all = rbind(delay_discounting_all, df) 
  }else{
    delay_discounting_summary = rbind(delay_discounting_summary, df) 
  }
}

colnames(delay_discounting_all)[which(names(delay_discounting_all) == "V1")] <- "subject_id" 
colnames(delay_discounting_all)[which(names(delay_discounting_all) == "V2")] <- "task_type" 
colnames(delay_discounting_all)[which(names(delay_discounting_all) == "V3")] <- "commodity" 
colnames(delay_discounting_all)[which(names(delay_discounting_all) == "V4")] <- "reward_reality" 
colnames(delay_discounting_all)[which(names(delay_discounting_all) == "V5")] <- "gain_or_losses" 
colnames(delay_discounting_all)[which(names(delay_discounting_all) == "V6")] <- "trial_number" 
colnames(delay_discounting_all)[which(names(delay_discounting_all) == "V7")] <- "amount" 
colnames(delay_discounting_all)[which(names(delay_discounting_all) == "V8")] <- "delays" 
colnames(delay_discounting_all)[which(names(delay_discounting_all) == "V9")] <- "choice" 
colnames(delay_discounting_all)[which(names(delay_discounting_all) == "V10")] <- "RT" 
colnames(delay_discounting_all)[which(names(delay_discounting_all) == "V11")] <- "reward_type" 
colnames(delay_discounting_all)[which(names(delay_discounting_all) == "V12")] <- "program_version" 
colnames(delay_discounting_all)[which(names(delay_discounting_all) == "V13")] <- "session_date" 


colnames(delay_discounting_summary)[which(names(delay_discounting_summary) == "V1")] <- "subject_id" 
colnames(delay_discounting_summary)[which(names(delay_discounting_summary) == "V2")] <- "task_type" 
colnames(delay_discounting_summary)[which(names(delay_discounting_summary) == "V3")] <- "commodity" 
colnames(delay_discounting_summary)[which(names(delay_discounting_summary) == "V4")] <- "reward_reality" 
colnames(delay_discounting_summary)[which(names(delay_discounting_summary) == "V5")] <- "gain_or_losses" 
colnames(delay_discounting_summary)[which(names(delay_discounting_summary) == "V6")] <- "questions_per_delay" 
colnames(delay_discounting_summary)[which(names(delay_discounting_summary) == "V7")] <- "amount" 
colnames(delay_discounting_summary)[which(names(delay_discounting_summary) == "V8")] <- "delays" 
colnames(delay_discounting_summary)[which(names(delay_discounting_summary) == "V9")] <- "indifference_points" 
colnames(delay_discounting_summary)[which(names(delay_discounting_summary) == "V10")] <- "program_version" 
colnames(delay_discounting_summary)[which(names(delay_discounting_summary) == "V11")] <- "session_date" 
#Outputing all data
write.table( delay_discounting_all, "Delay_Discounting_Combine_All.txt",row.names=F, col.names=T, sep = "\t", quote=FALSE  )
write.table( delay_discounting_summary, "Delay_Discounting_Summary.txt",row.names=F, col.names=T, sep = "\t", quote=FALSE  )
