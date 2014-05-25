# DataCleanser


The aim of DataCleanser is to read,merge the test and training data, subset, calcuate average and write the resultant in a file 

**Prerquisites:**

* sqldf package is downloaded and installed.
* 'UCI Har Dataset' is unzipped at current working directory and the name needs to be exactly the same.

**Key features:**

* function to read and combine multiple data set
* function to append new columns
* function to subset the data frame
* function to calculate average based on multiple columns


**Ouput:**

* The output which contains the means of the required column per Subject/Activity is generated with the name Result.txt under 'UCI HAR Dataset' directory. Which Contains all the 66 mean(mean freq fields not included) and standard deviatio

