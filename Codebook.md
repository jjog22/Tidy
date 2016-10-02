-medtst where load file X_test.txt
2947 obs, 561 var

-subtst where load file subject_test.txt
2947 obs, 1 var

-acttst where load file y_test.txt
2947 obs, 1 var

-medtrn where load file X_train.txt
7352 obs, 561 var

-subtrn where load file subject_train.txt
7352 obs, 1 var

-acttrn where load file y_train.txt
7352 obs, 1 var

-Read name of columns or measures
-features where load file features.txt
561 obs, 2 var

-Review if names of columns has words "mean", "std" for extract only this columns

-features contain column load file features.txt

-namesf contain variables mean and std of the 561 variables

-After confirm, copy data of medtst medtrn as needed

-medtstf contain column load file features.txt only test subjects

-medtrnf contain column load file features.txt only train subjects

-bind rows and put labels to meditions

-medition has bind of medtstf,medtrnf

-bind rows and put labels to subject

-subject has bind of subtst and subtrn

-actlab where load file activity_labels.txt

-indexr=acttrn[which(acttrn$V1 %in% actlab$V1),1]

-activity has bind of acttst and acttrn

-tidy2 has tidy columns for assignment steps 1,3

-at first mean in summarize of 1 column is correct but I had 2 problems

1. I need 66 values for calculate mean and summarize didn't work replacing names of columns with a function or a loop

2. I repeated this summarize and the values are not the same every time

-I used tapply with next steps
	
-tapply only get mean for values but it not extract fields on DF, so I need get one sample with keys used (row names) and later extract Subject,numactivity

-grup1 first result of tapply returns only values not keys 

-grup2 has columns keys subject and activity in order of tapply

-Create matrix for fill values mean of values tidy2
-t1 matrix for fill values with loop of tapply

-tidy3 will be tidy data for average columns for Subject, activity 

-I load file with write table including name columns because all work with names shouldnt have sense
