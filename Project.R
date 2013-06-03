###########################################################
#
#Initialize environment
#
###########################################################
source('lib/utilities.R')
source('lib/load_libraries.R')
source('lib/load_data.R')
source('lib/preprocess_data.R')

#Add rowid to test data
test.data<-cbind(RowID=as.numeric(rownames(test.data)),test.data)
#Add topic feature to training and test sets
source('add_topic.R')

###########################################################
#
#Generate model and predictions for Example 1
#
###########################################################
source('example_model.R')
summary(fit)
logit.fit1<-fit
training.data$Logit1Probabilities <- predict(logit.fit1,type="response")
logit.fit1.roc <- roc(training.data$Installed,training.data$Logit1Probabilities)
logit.fit1.roc$auc #0.8145 on training data
plot(logit.fit1.roc,main="Example 1 ROC: AUC=0.8145")

###########################################################
#
#Generate model and predictions for Example 2
#
###########################################################
source('example_model_2.R')
summary(fit)
logit.fit2<-fit
training.data$Logit2Probabilities <- predict(logit.fit2,type="response")
logit.fit2.roc <- roc(training.data$Installed,training.data$Logit2Probabilities)
logit.fit2.roc$auc #0.9489 on training data
plot(logit.fit2.roc,main="Example 2 ROC: AUC=0.9489")

###########################################################
#
#Generate model and predictions for Example 3
#
###########################################################
source('example_model_3.R')
summary(fit)
logit.fit3<-fit
training.data$Logit3Probabilities <- predict(logit.fit3,type="response")
logit.fit3.roc <- roc(training.data$Installed,training.data$Logit3Probabilities)
logit.fit3.roc$auc #0.9507 on training data
plot(logit.fit3.roc,main="Example 3 ROC: AUC=0.9507")

###########################################################
#
#Generate model and predictions for Decision Tree test
#
###########################################################
source('decision_tree_model.R')
summary(fit)
dt.fit1<-fit
training.data$dtProbabilities <- predict(dt.fit1,type="prob")[,2]
dt.fit1.roc <- roc(training.data$Installed,training.data$dtProbabilities)
dt.fit1.roc$auc #0.796 on training data
plot(dt.fit1.roc,main="Decision Tree ROC: AUC=0.796")

###########################################################
#
#Logistic regression with new features
#
###########################################################
source('new_features_1.R')

#Generate model and predictions using the new features
source('logit_model_4.R')
summary(fit)
logit.fit4<-fit
training.data$Logit4Probabilities <- predict(logit.fit4,type="response")
logit.fit4.roc <- roc(training.data$Installed,training.data$Logit4Probabilities)
logit.fit4.roc$auc #0.9659 on training data
plot(logit.fit4.roc,main="Logit ROC: AUC=0.9659")

#Calculate predictions for test data
test.data$Logit4Probabilities <- predict(logit.fit4,test.data,type="response")
#0.96641 on private leaderboard
write.csv(test.data$Logit4Probabilities,file="Logit4.csv",row.names=FALSE)


###########################################################
#
#Logistic regression with new features part 2
#
###########################################################
source('new_features_2.R')

#Generate model and predictions using the new features
#Omit "R" and "base" packages from the training set
#Explicitly set probabilities to 0 and 1 respectively
source('logit_model_5.R')
logit.fit5<-fit
training.data$Logit5Probabilities <- NA
training.data[which(training.data$Package == "R"),"Logit5Probabilities"] <- 0
training.data[which(training.data$Package == "base"),"Logit5Probabilities"] <- 1
training.data[which(training.data$Package != "R" & training.data$Package != "base"),"Logit5Probabilities"] <- predict(logit.fit5,type="response")
logit.fit5.roc <- roc(training.data$Installed,training.data$Logit5Probabilities)
logit.fit5.roc$auc #0.9735 on training data
plot(logit.fit5.roc,main="Logit ROC: AUC=0.9735")

#Calculate predictions
test.data$Logit5Probabilities <- predict(logit.fit5,test.data,type="response")
#Overwrite predictions for Package=="R" or Package=="base"
test.data[which(test.data$Package == "R"),"Logit5Probabilities"] <- 0
test.data[which(test.data$Package == "base"),"Logit5Probabilities"] <- 1

#Output results to file: Private AUC = 0.97467
write.csv(test.data$Logit5Probabilities,file="Logit5.csv",row.names=FALSE)


###########################################################
#
#Evaluate best model
#
###########################################################
#Calculate average predicted probability and the empirical probability
training.predict<-subset(training.data,select=c(Package,User,Installed,Logit5Probabilities))
training.predict$errors<-training.predict$Installed-training.predict$Logit5Probabilities
predicted.probs <- ddply(training.predict,
      'Package',
      function (d) {mean(d$Logit5Probabilities)})
names(predicted.probs) <- c('Package', 'PredictedProbability')
empirical.probs <- ddply(training.data,
                         'Package',
                         function (d) {nrow(subset(d, Installed == 1)) / nrow(d)})
names(empirical.probs) <- c('Package', 'EmpiricalProbability')
probabilities <- merge(predicted.probs,
                       empirical.probs,
                       by = 'Package')
probabilities$error<-with(probabilities,abs(PredictedProbability-EmpiricalProbability))
hist(probabilities$error,main="Absolute error by package",xlab="Absolute error")
#Output probabilities to a sortable html table
library('SortableHTMLTables')
sortable.html.table(probabilities,
                    'probabilities.html',
                    'reports')