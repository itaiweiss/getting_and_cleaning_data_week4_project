
# Read all the input files into variables
x_test <- read.table("test\\X_test.txt")
y_test <- read.table("test\\y_test.txt")
s_test <- read.table("test\\subject_test.txt")
s_train <- read.table("train\\subject_train.txt")
y_train <- read.table("train\\y_train.txt")
x_train <- read.table("train\\X_train.txt")
activities<-read.table("activity_labels.txt")
features<-read.table("features.txt")

# Rename the columns that we intend to use
names(x_test)<-features$V2
names(x_train)<-features$V2
names(activities)=c("activity","act_desc")

# bind the different sets together
x_bind<-rbind(x_test,x_train)
y_bind<-rbind(y_test,y_train)
s_bind<-rbind(s_test,s_train)


# retain only the fields that we need and name them properly
std_mean<- x_bind[,1:6]

# add acitivity and subject_id from the other files
std_mean_all <-cbind(std_mean,y_bind)
names(std_mean_all)[7]<-"activity"
std_mean_all <-cbind(std_mean_all,s_bind)
names(std_mean_all)[8]<-"subject"

# Merge the activity description with the activity field
all_act_desc <-merge(std_mean_all,activities,by="activity",all=T)


# assign proper names to all fields
names(all_act_desc) <-c("Activity", "Body Acceleration Mean X axis","Body Acceleration Mean Y axis","Body Acceleration Mean Z axis","Body Acceleration Standard Deviation X axis","Body Acceleration Standard Deviation Y axis","Body Acceleration Standard Deviation Z axis","Subject","Activity_Description")

# use dplyr to calculate the mean for each activity and subject
library(dplyr)
all_act_desc_avg<-all_act_desc %>% group_by(Activity_Description,Subject) %>% summarise_each(funs(mean), matches("axis"))


write.table(all_act_desc_avg, file = "newData.txt", row.name=FALSE)



