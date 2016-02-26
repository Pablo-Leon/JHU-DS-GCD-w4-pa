

CodeBook.md
============

   * JHU-DS MOOC Course 
      * Getting and Cleaneaning Data
      * Course Programming Assigment
   * By : Pablo León  (p.leon@ieee.org)
      * 2016-02-25


General
-------

There are two dataset presented in this work.

The first dataset (HAR_REDUX) is a reformated subset of the datasets included in the source data.
The second (HAR_AVERAGES) is a summary  of the first dataset.

The source data comes from "Human Activity Recognition Using Smartphones Dataset" Version 1.0 ([1]).

The source data includes several statistics (mean, std.deviation, min, max, etc.)
for measurments corresponding for each experiment. Each experiment is associated 
with one subject and one activity. Subjects has been randomly partitioned into 
two sets ("train" and "test").
This statistics represent the variables of the original datasets.

From those, only mean and std.deviatios source variables where included in the
presented dataset.


Source data, variables and features
-----------------------------------
### Subjects
The subjects are identified by a number in the range [1,30]

### Activity
The activity is labeled by one of these six activities:
 WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING

### Measurments
The original data  come from the accelerometer and gyroscope 3-axial raw 
signals, recorden on activities of 30. 

Features are normalized and bounded within [-1,1].

These time domain signals (prefix 'Time' to denote time) were captured at a 
constant rate of 50 Hz. 

Then they were filtered using a median filter and a 3rd order low pass 
Butterworth filter with a corner frequency of 20 Hz to remove noise. 
Similarly, the acceleration signal was then separated into body and gravity 
acceleration signals (TimeBodyAcceleration-XYZ and TimeGravityAcceleration-XYZ) 
using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 


Subsequently, the body linear acceleration and angular velocity were derived in 
time to obtain Jerk signals (TimeBodyAccelerationJerk-XYZ and TimeBodyGyroJerk-XYZ). 

Also the magnitude of these three-dimensional signals were calculated using the
Euclidean norm (TimeBodyAccelerationMagnitude, TimeGravityAccelerationMagnitude,
TimeBodyAccelerationJerkMagnitude, TimeBodyGyroMagnitude, 
TimeBodyGyroJerkMagnitude). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals 
producing FrequencyBodyAcceleration-XYZ, FrequencyBodyAccelerationJerk-XYZ, 
FrequencyBodyGyro-XYZ, FrequencyBodyAccelerationJerkMag, FrequencyBodyGyroMag,
FrequencyBodyGyroJerkMag. 
(Note the 'Frequency' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each 
pattern:
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.



The HAR_REDUX dataset
---------------------

### General
This dataset contains one record (row) for each observation reported,
regardles of original dataset (train and test).

The features identifying the characteristics of the observation where preserved:
   * Subject : Code of the volunteer
   * Activity : label of the activity
   * Set : Source dataset (train and test)

Of the features representing the measurments from the smartphone only those
representing statistics mean ("mean()") and standard deviation ("std()") 
where preserved.

Variables names where changed to a more readable ones.
 
### Construction
This dataset was build from the source data as follows:
   * Features/variables:
      * Select the features to be used in the presented dataset 
         (those identified as result of "mean()" and "std()" functions)
      * Generate new, more readable, names for the features,
         * mean statistics identified by "_Mean" suffix
         * std.deviation identified by "_StdDev" suffix
   * Activities
      * Read the activities code/descriptions from activity_labels.txt
   * Iterate over train and test sets
      * Read the X (measures), y(activity labels) and subject data
         for each observation from:
         * Train set: X_train.txt, y_train.txt, subject_train.txt
         * Test set:  X_test.txt, y_test.txt, subject_test.txt
      * Merge the data (column wise) for each observation:
         * Each record number on each file corresponds to the same observation
         * A variable identifing the set is appended as the first column
         * Activity codes in X files are changed for the description (activity_labels.txt)
         * Selected measurments are aded
      * Merge the datasets (row wise) for all observations
         * The sub-sets buld from train and test datasets where concatenated
            (row wise)
            
            
### Variables
Position    Variable    Values or explanation

1           Set         Source data set. Can be "train" or "test"

2           Activity    Name of the activity associated with measurments,
                        it was set mannually, by watching videos of the activities.
                        Can be one of:
                           WALKING
                           WALKING_UPSTAIRS
                           WALKING_DOWNSTAIRS
                           SITTING
                           STANDING
                           LAYING                        

3           Subject     Identifier for the subject (person) who's activity was measured
                        

4..9        TimeBodyAcceleration[X,Y,Z]_[Mean,StdDev]
                        3-axial body acceleration.

10..15      TimeGravityAcceleration[X,Y,Z]_[Mean,StdDev]
                        3-axial gravity acceleration.

16..21      TimeBodyAccelerationJerk[X,Y,Z]_[Mean,StdDev]
                        3-axial body acceleration jerk.

22..27      TimeBodyGyro[X,Y,Z]_[Mean,StdDev]
                        3-axial angular velocity. 

28..33      TimeBodyGyroJerk[X,Y,Z]_[Mean,StdDev]
                        3-axial angular velocity jerk. 

34..39      FrequencyBodyAcceleration[X,Y,Z]_[Mean,StdDev]
                        Frequency (FFT) of body acceleration. 

40..45      FrequencyBodyAccelerationJerk[X,Y,Z]_[Mean,StdDev]
                        Frequency (FFT) of body acceleration jerk. 

46..51      FrequencyBodyGyro[X,Y,Z]_[Mean,StdDev]
                        Frequency (FFT) of body angular velocity. 

         
   
The HAR_AVERAGES dataset
------------------------

### General

The variables presented in this dataset are the arithmetic means of the HAR_REDUX dataset
variables, taken across all observations, for each Subject and Activity pair,
regardles of the original data set ("train" or "test" ).

So for each record of the HAR_AVERAGES dataset the variables are:
   * Subject
   * Activity
   * ... arithmetic means of the HAR_REDUX variables correspionding
      to positions 4..51 .

Each row (record) summarize all data available for each pair of Subject and Activity.





[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012



