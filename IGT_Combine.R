rm(list=ls())
library(foreign)


#setwd( "~/Desktop/Impulsivity" ) #Sets working directory to folder where SPSS file is
logData <- read.spss("R01 IMPULSIIVITY DATABASE 4-24-2019.sav",to.data.frame=TRUE,
                     use.value.labels=FALSE) #Imports SPSS file
setwd( "C:/Users/shahidir/Dropbox/Research/Data Processing/Raw Data" ) #Sets working directory to folder where the raw data is





groupInfo = logData 
allFiles = dir()
numSubjs = length( allFiles )
allData = NULL
contDataM = NULL
contDataF = NULL
heroinDataM = NULL
heroinDataF = NULL
amphDataM = NULL
amphDataF = NULL
polyDataM=NULL
polyDataF=NULL
sibHeroinM=NULL
sibHeroinF=NULL
sibAmphetamineM=NULL
sibAmphetamineF=NULL
allM=NULL
allF=NULL

allFiles = dir()
numSubjs = length( allFiles )
for (subjIdx in 1:numSubjs) {
  #subjIdx=582
  
  
  tmpFile = allFiles[ subjIdx ]
  tmp= read.table(tmpFile, skip=21, header=T)
  if(nrow(tmp)!=100){
    tmp= read.table(tmpFile, header=T)
  }
  if(nrow(tmp)==101 & as.character(tmp[1,1])=="Trial"){
    tmp<-tmp[2:101,]
  }
  if(nrow(tmp)==101 & as.character(tmp[101,1])=="Trial"){
    tmp<-tmp[1:100,]
  }
  
  tmp2 = tmp[1:100,] #Check this value here if the numbers dont line up, need to match IGT output************************************************************************************************************
  subjID = substring(tmpFile, 1,3)  # subject ID
  tmp3 = cbind( tmp2, subjID)  # add a col. with subjID
  # replace A', B', C', D' with 1, 2, 3, 4
  deckTmp = tmp3$Deck
  deckTmp2 = gsub("A", 1, deckTmp)
  deckTmp2 = gsub("B", 2, deckTmp2)
  deckTmp2 = gsub("C", 3, deckTmp2)
  deckTmp2 = gsub("D", 4, deckTmp2)
  tmp3$Deck = deckTmp2 # now replace abcd with deckTmp2
  
  
  tmpLog = subset( groupInfo, PRE_1_SUBJ==subjID)  # find this subject's group membership using PRE_1_SUBJ from SPSS file
  tmpDx = tmpLog[,"PRE_GROUP"]  # 0, 1, 2 for group memebership
  tmpDx1 = tmpLog[,"PRE_10_GENDER"]  # 0, 1, 2 for gender
  
  
  tmp5 = cbind( tmp3, tmpDx, tmpDx1) #Adds column with group membership
  allData = rbind(allData, tmp5) 
  if (tmpDx == 0) {
    if(tmpDx1 == 1){
      contDataM = rbind(contDataM, tmp5)
      allM = rbind(allM, tmp5)
    }
    if(tmpDx1 ==2){
      contDataF = rbind(contDataF, tmp5)
      allF = rbind(allF, tmp5)
    }
  }
  else if (tmpDx == 1) {
    if(tmpDx1==1){
      heroinDataM = rbind(heroinDataM, tmp5)
      allM = rbind(allM, tmp5)
    }
    if(tmpDx1==2){
      heroinDataF = rbind(heroinDataF, tmp5)
      allF = rbind(allF, tmp5)
    }
  } 
  else if(tmpDx==2){
    if(tmpDx1==1){
      amphDataM = rbind(amphDataM, tmp5)
      allM = rbind(allM, tmp5)
    }
    if(tmpDx1==2){
      amphDataF = rbind(amphDataF, tmp5)
      allF = rbind(allF, tmp5)
    }
  }
  else if(tmpDx==3){
    if(tmpDx1==1){
      polyDataM = rbind(polyDataM, tmp5)
      allM = rbind(allM, tmp5)
    }
    if(tmpDx1==2){
      polyDataF = rbind(polyDataF, tmp5)
      allF = rbind(allF, tmp5)
    }
  }
  else if(tmpDx==4){
    if(tmpDx1==1){
      sibHeroinM = rbind(sibHeroinM, tmp5)
      allM = rbind(allM, tmp5)
    }
    if(tmpDx1==2){
      sibHeroinF = rbind(sibHeroinF, tmp5)
      allF = rbind(allF, tmp5)
    }
  }
  else if(tmpDx==5){
    if(tmpDx1==1){
      sibAmphetamineM = rbind(sibAmphetamineM, tmp5)
      allM = rbind(allM, tmp5)
    }
    if (tmpDx1==2){
      sibAmphetamineF = rbind(sibAmphetamineF, tmp5)
      allF = rbind(allF, tmp5)
    }
  }
}


#This renames the column titles and removes ' from the choice number
renameFunction<-function(df){
  colnames(df)[which(names(df) == "Trial")] <- "trial"
  colnames(df)[which(names(df) == "Deck")] <- "choice"
  colnames(df)[which(names(df) == "Win")] <- "gain"
  colnames(df)[which(names(df) == "Lose")] <- "loss"
  df$choice <- gsub("'", '', gsub('^,+|,+$', '', df$choice))
  return(df)
}


#Preparing output for all data
allData<-renameFunction(allData)
write.table( allData, "allData.txt",row.names=F, col.names=T, sep = "\t", quote=FALSE  )

#Preparing output for control data
contDataM<-renameFunction(contDataM)
contDataF<-renameFunction(contDataF)
allContData=rbind(contDataM, contDataF)
write.table( allContData, "contData.txt",row.names=F, col.names=T, sep = "\t", quote=FALSE  )
write.table( contDataM, "contDataM.txt",row.names=F, col.names=T, sep = "\t", quote=FALSE  )
write.table( contDataF, "contDataF.txt",row.names=F, col.names=T, sep = "\t", quote=FALSE  )

#Preparing output for heroin data
heroinDataM<-renameFunction(heroinDataM)
heroinDataF<-renameFunction(heroinDataF)
allHeroinData=rbind(heroinDataM, heroinDataF)
write.table( allHeroinData, "heroinData.txt",row.names=F, col.names=T, sep = "\t", quote=FALSE  )
write.table( heroinDataM, "heroinDataM.txt",row.names=F, col.names=T, sep = "\t", quote=FALSE  )
write.table( heroinDataF, "heroinDataF.txt",row.names=F, col.names=T, sep = "\t", quote=FALSE  )

#Preparing output for amphetamine data
amphDataM<-renameFunction(amphDataM)
amphDataF<-renameFunction(amphDataF)
allAmphData=rbind(amphDataM, amphDataF)
write.table( allAmphData, "amphData.txt",row.names=F, col.names=T, sep = "\t", quote=FALSE  )
write.table( amphDataM, "amphDataM.txt",row.names=F, col.names=T, sep = "\t", quote=FALSE  )
write.table( amphDataF, "amphDataF.txt",row.names=F, col.names=T, sep = "\t", quote=FALSE  )

#Preparing output for polysubstance use data
polyDataM<-renameFunction(polyDataM)
polyDataF<-renameFunction(polyDataF)
allPolyData=rbind(polyDataM, polyDataF)
write.table( allPolyData, "polyData.txt",row.names=F, col.names=T, sep = "\t", quote=FALSE  )
write.table( polyDataM, "polyDataM.txt",row.names=F, col.names=T, sep = "\t", quote=FALSE  )
write.table( polyDataF, "polyDataF.txt",row.names=F, col.names=T, sep = "\t", quote=FALSE  )

#Preparing output for sibling heroin data
sibHeroinM<-renameFunction(sibHeroinM)
sibHeroinF<-renameFunction(sibHeroinF)
allSibHeroinData=rbind(sibHeroinM, sibHeroinF)
write.table( allSibHeroinData, "sibHeroinData.txt",row.names=F, col.names=T, sep = "\t", quote=FALSE  )
write.table( sibHeroinM, "sibHeroinDataM.txt",row.names=F, col.names=T, sep = "\t", quote=FALSE  )
write.table( sibHeroinF, "sibHeroinDataF.txt",row.names=F, col.names=T, sep = "\t", quote=FALSE  )

#Preparing output for sibling amphetamine data
sibAmphetamineM<-renameFunction(sibAmphetamineM)
sibAmphetamineF<-renameFunction(sibAmphetamineF)
allSibAmphetamineData=rbind(sibAmphetamineM, sibAmphetamineF)
write.table( allSibAmphetamineData, "sibAmphetamineData.txt",row.names=F, col.names=T, sep = "\t", quote=FALSE  )
write.table( sibAmphetamineM, "sibAmphDataM.txt",row.names=F, col.names=T, sep = "\t", quote=FALSE  )
write.table( sibAmphetamineF, "sibAmphDataF.txt",row.names=F, col.names=T, sep = "\t", quote=FALSE  )

#Preparing output for sex data
allM<-renameFunction(allM)
allF<-renameFunction(allF)
write.table( allM, "allM.txt",row.names=F, col.names=T, sep = "\t", quote=FALSE  )
write.table( allF, "allF.txt",row.names=F, col.names=T, sep = "\t", quote=FALSE  )
