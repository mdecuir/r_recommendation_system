library(rpart)
fit <- rpart(Installed ~ DependencyCount +
                  SuggestionCount +
                  ImportCount +
                  ViewsIncluding +
                  PackagesMaintaining +
                  CorePackage +
                  RecommendedPackage +
                  factor(User) +
                  Topic,
                data=training.data,
                method="class")
summary(fit)