Project.R functions as a master controlling script for all sub components and is safe to run straight through.

The script is broken into several chunks:
Initialize Environment:
	Initialize the environment based on the source code available on GitHub. This can be rerun to reinitialize the environment.
	Creates the Topics feature for the training and test data sets.
Generate model and predictions for Example 1:
	Generates the first example model, predictions and calculates AUC and ROC
Generate model and predictions for Example 2:
	Generates the second example model, predictions and calculates AUC and ROC
Generate model and predictions for Example 3:
	Generates the third example model, predictions and calculates AUC and ROC
Generate model and predictions for Decision Tree test:
	Generates a decision tree model using default parameters,
	predictions and calculates AUC and ROC
Logistic regression with new features:
	Generates a logistic regression model based on the features of
	example 3 and the following new features
		MissingDependency:	The user is known to not have a
							dependency of this package installed
		DependentInstalled:	A package that depends on this package
							is known to be installed by the user
		Suggested:			This package is suggested by a package
							this user has installed
		Imported:			This package is imported by a package
							this user has installed
Logistic regression with new features part 2:
	Generates a model as above, that omits the "R" and "base"
	packages from the model, classifying as 0 and 1 respectively.
	Considers both packages to always be installed for purposes
	of calculating new features
Evaluate best model:
	Calculates the average predicted probability by package and compares it to
	the actual probability, outputting the results to /reports/probabilities.html