===========================================================================
Tidy Data Set based on Human Activity Recognition Using Smartphones Dataset
===========================================================================
Jim Gianoglio
==================================================================

The run_analysis.R script downloads the data collected from the accelerometers
from the Samsung Galaxy S smartphone. A full description of the original data
is available at the site where the data was obtained: 

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

The original data for the project is located at the following link: 

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

It transforms the data by combining the test and train data, activity names and
subject IDs into a single data frame. It includes only variables that are the
mean or standard deviation measurements. It averges these measurements for each
activity and each subject. It provides clear and descriptive names for the
variables.

A full listing of these variables with descriptions and details can be found in the CodeBook.md file.

The script generates a tidy data file that meets the principles of
tidy data as set forth by Hadley Wickham in his paper titled *Tidy Data*:

http://vita.had.co.nz/papers/tidy-data.pdf

Specific details and descriptions about the tidy data file contents can be found
in the CodeBook.md file.

To read the tidy data file into R, you can use the following code:
data <- read.table(file_path, header = TRUE)
View(data)
