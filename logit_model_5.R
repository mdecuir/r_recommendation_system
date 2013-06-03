fit <- glm(Installed ~
                    LogDependencyCount +
                    LogSuggestionCount +
                    LogImportCount +
                    LogViewsIncluding +
                    LogPackagesMaintaining +
                    CorePackage +
                    RecommendedPackage +
                    factor(User) +
                    Topic +
                    factor(MissingDependency) +
                    factor(DependentInstalled) +
                    factor(Suggested) +
                    factor(Imported),
                  data = training.data,
                  family = binomial(link = 'logit'),
                  subset=Package != "R" & Package != "base")

summary(fit)