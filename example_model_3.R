fit <- glm(Installed ~ LogDependencyCount +
                             LogSuggestionCount +
                             LogImportCount +
                             LogViewsIncluding +
                             LogPackagesMaintaining +
                             CorePackage +
                             RecommendedPackage +
                             factor(User) +
                             Topic,
                 data = training.data,
                 family = binomial(link = 'logit'))

summary(fit)
