#Add Topic feature to the training and test data per GitHub code
training.data <- merge(training.data, topics, by = 'Package', all.x = TRUE)
training.data$Topic[which(is.na(training.data$Topic))] <- 0
training.data <- transform(training.data, Topic = factor(Topic))

#RowIDs used to ensure that original and final sorting are identical
test.data <- merge(test.data, topics, by = 'Package', all.x = TRUE)
test.data[which(is.na(test.data$Topic)),"Topic"] <- 0
test.data <- transform(test.data, Topic = factor(Topic))
test.data<-test.data[order(test.data$RowID),]