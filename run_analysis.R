library(stringr)
library(dplyr)

#Loading rows and columns
medtst<-read.table("./X_test.txt",header=FALSE)
#2947 obs, 561 var
subtst<-read.table("./subject_test.txt",header=FALSE)
#2947 obs, 1 var
acttst<-read.table("./y_test.txt",header=FALSE)
#2947 obs, 1 var
medtrn<-read.table("./X_train.txt",header=FALSE)
#7352 obs, 561 var
subtrn<-read.table("./subject_train.txt",header=FALSE)
#7352 obs, 1 var
acttrn<-read.table("./y_train.txt",header=FALSE)
#7352 obs, 1 var
#Read name of columns or measures
features<-read.table("./features.txt",header=FALSE)
#561 obs, 2 var
#Review if names of columns has words "mean", "std" for extract only this columns
features[grep("mean[[:punct:]]|std[[:punct:]]",features$V2),]
namesf<-as.character(features[grep("mean[[:punct:]]|std[[:punct:]]",features$V2),2:2])

#After confirm, copy data of medtst medtrn as needed
medtstf<-medtst[grep("mean[[:punct:]]|std[[:punct:]]",features$V2)]
medtrnf<-medtrn[grep("mean[[:punct:]]|std[[:punct:]]",features$V2)]
#bind rows and put labels to meditions
medition<-rbind(medtstf,medtrnf)
names(medition)<-namesf

#bind rows and put labels to subject
subject<-rbind(subtst,subtrn)
names(subject)<-c("Subject")

#load activiy labels
 actlab<-read.table("./activity_labels.txt",header=FALSE)
 #activitytst<-merge(actlab,acttst,all=TRUE) it didnt work because put labels wrong
 #Alternative putting labels activities
 acttst<-mutate(acttst,V2="")
 index=acttst[which(acttst$V1 %in% actlab$V1),1]
 acttst$V2<-actlab[index,2]
 acttrn<-mutate(acttrn,V2="")
 indexr=acttrn[which(acttrn$V1 %in% actlab$V1),1]
 acttrn$V2<-actlab[indexr,2]
 names(activity)<-c("numact","activity")

#get tidy2 with needed bind columns assignment steps 1,3
tidy2<-cbind(subject,activity,medition) 
#clean column names on tidy2
 names(tidy2)<-gsub("-","",names(tidy2))
 names(tidy2)<-gsub("[[:punct:]]","",names(tidy2))

#Review gruping and mean of 1 column for verify
> group_by(tidy2,Subject,activity)->gruposa
> summarise(gruposa,tb=mean(tBodyAccmeanX,na.rm=TRUE))
#at first mean is correct but I had 2 problems
#1. I need 66 values for calculate mean and summarize didn't work replacing names of columns with function or a loop
#2. I repeated this summarize and the values are not the same every repeated
#I used tapply with next steps
	
#tapply only get mean for values but it not extract fields on DF, so I need get one sample with keys used (row names) and later extract Subject,numactivity
grup1<-tapply(tidy2[,4],tidy2[,3],mean,na.rm=TRUE)
grup2<-mutate(grup2,Subject="",numact="")
grup2$Subject<-ifelse(nchar(grup2$V2)==4,substring(grup2$V2,1,2),substring(grup2$V2,1,1))
grup2$numact=sub(" ","",str_extract(grup2$V2,"( .)"))

#Create matrix for fill values mean of values tidy2
t1<-matrix(data=NA,nrow=180,ncol=70)
for (i in 4:69) { t1[,i]<-tapply(tidy2[,i],tidy2[,70],mean,na.rm=TRUE)}
#tidy3 will be tidy data for average columns for Subject, activity
tidy3<-tbl_df(t1)
names(tidy3)
grup1<-cbind(grup1,rownames(grup1))
grup2<-tbl_df(grup1)
vecnom<-as.vector(strsplit(grup2$V2," "))

#Bind correct order of subject,activity to mean of values on tidy3 to obtain final file to load to Coursera
tidy3<-cbind(grup2[,3:4],tidy3)
#I put column names because all my work with names has no sense
write.table(tidy3,file="./tidy3",col.names=TRUE)