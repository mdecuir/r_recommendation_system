fit <- glm(Installed ~ LogDependencyCount +
                             LogSuggestionCount +
                             LogImportCount +
                             LogViewsIncluding +
                             LogPackagesMaintaining +
                             CorePackage +
                             RecommendedPackage +
                             factor(User),
                 data = training.data,
                 family = binomial(link = 'logit'))

summary(fit)
