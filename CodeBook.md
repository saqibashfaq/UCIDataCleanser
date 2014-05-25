# run_analysis.R

run_analysis.R contains a list of functions and attributes to perform the data cleansing project. A brief description is given below.
**run_analysis():**

* This is the main calling function which takes no parameter and expects the 'UCI HAR Dataset' directory with the exact name on the working directory. Then it calls a series of functions(also maintained in the same file) to carry out the required cleansing and calculation.

**run_analysis():**

* This is the main calling function which takes no parameter and expects the 'UCI HAR Dataset' directory with the exact name on the working directory. Then it calls a series of functions(also maintained in the same file) to carry out the required cleansing and calculation.
* Also as the last step this function writes the data frame to the text file at '.UCI HAR Dataset/Result.txt' Which is tab delimited file.

**combiner()**
* This function takes no parameters and it read from test and train datasets and then rowbinds them into one to provide a single data frame with all the columns. It also appends Subject_Number and Activity_Number from both data sets.

**ActivityNameAppender(combineddata)**
* Activity NameAppender takes the output of combiner function. It takes the the combined dataframe which contains the train and test data. and then appends Activity Name in place of Activity_Number

**ActivityNameAppender(combineddata)**
* Activity NameAppender takes the output of combiner function. It takes the the combined dataframe which contains the train and test data. and then appends Activity Name in place of Activity_Number and returns the resultant data frame.

**Subsetter(combineddata)**
* Carrying on with the process subsetter takes only mean and standard deviation fields from the data set along with the Subject and Activity_Name. The result is a 68 Column Data Frame which is returned.

**average_calculation(inputdata)**
* Average calculation takes the input data set and calculates the average based on two columns using the aggregator function.
