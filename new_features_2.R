#Append features for missing dependencies, dependency of installed packages
#Suggested by installed packages and imported by installed packages
#Initialize new features with 0
training.data$MissingDependency <- 0
training.data$DependentInstalled <- 0
training.data$Suggested <- 0
training.data$Imported <- 0

#Build lists of Package/User combinations for each new feature
all.installed <- subset(installations,subset=Installed==1 | Package == "base" | Package == "R",select=c(Package,User))
all.not.installed <- subset(installations,subset=Installed==0 & Package != "R",select=c(Package,User))
all.missing.dependencies <- merge(all.not.installed,depends,by.x="Package",by.y="LinkedPackage")[,2:3]
dependent.installed <- merge(all.installed,depends,by="Package")
suggested <- merge(all.installed,suggests,by="Package")
imported <- merge(all.installed,imports,by="Package")

#Update new features to 1 if present in the corresponding list
training.data[with(training.data, paste(Package, User)) %in% with(all.missing.dependencies, paste(Package, User)),"MissingDependency"] <- 1
training.data[with(training.data,paste(Package,User)) %in% with(dependent.installed,paste(LinkedPackage,User)),"DependentInstalled"] <- 1
training.data[with(training.data,paste(Package,User)) %in% with(suggested,paste(LinkedPackage,User)),"Suggested"] <- 1
training.data[with(training.data,paste(Package,User)) %in% with(imported,paste(LinkedPackage,User)),"Imported"] <- 1

#Initialize new features for test data to 0
test.data$MissingDependency <- 0
test.data$DependentInstalled <- 0
test.data$Suggested <- 0
test.data$Imported <- 0

#Update new features to 1 if present in the corresponding list
test.data[with(test.data, paste(Package, User)) %in% with(all.missing.dependencies, paste(Package, User)),"MissingDependency"] <- 1
test.data[with(test.data,paste(Package,User)) %in% with(dependent.installed,paste(LinkedPackage,User)),"DependentInstalled"] <- 1
test.data[with(test.data,paste(Package,User)) %in% with(suggested,paste(LinkedPackage,User)),"Suggested"] <- 1
test.data[with(test.data,paste(Package,User)) %in% with(imported,paste(LinkedPackage,User)),"Imported"] <- 1
#Ensure that the test data is still sorted correctly
test.data<-test.data[order(test.data$RowID),]
