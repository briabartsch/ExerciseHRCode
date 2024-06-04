
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ExerciseHRCodePackage

<!-- badges: start -->
<!-- badges: end -->

ExerciseHRCode provides an easy way to analyze exercise heart rate data
(saved as a CSV file) from Polar for the purpose of:

1)  Increasing scientific rigor, reproducibility, and transparency when
    reporting exercise-based research
2)  Promoting reaching target exercise intensities in research and
    clinical practice

With ExerciseHRCode, the user selects whether they want mean, maximum,
and minimum heart rate response reported in 15, 30, 45, or 60 second
bins. This information will be provided in an excel output file which
also show total time spent in the target intensity zone.

The user is asked to select: 1) Whether the exercise intensity is light,
moderate, or vigorous, and 2) How maximal heart rate should be
determined. Maximal heart rate can be determined by either 1) Entering a
predetermined maximal heart rate, or 2) Selecting a predetermined
equation to predict maximal heart rate. If an equation is selected, the
user will be asked to enter any relevant information such as age and
resting heart rate.

After completing the selection process in the console, the user will be
provided with the maximum heart rate and heart rate intensity range. Two
files will be exported to the output_folder filepath. One file will be a
summarized_data CSV file with heart rate analyzed for each bin and total
time spent in the intensity zone provided. The other file will be a JPG
graph of the heart rate response during exercise with the target
intensity zone highlighted. The JPG graph can be a black and white
publication-ready graph or a color graph depending on what is
prespecified in the code, i.e., publication_graph = TRUE or
publication_graph = FALSE.

## Installation

You can install the development version of ExerciseHRCodePackage from
[GitHub](https://github.com/) with:

``` r
install.packages("devtools")
library(devtools)
devtools::install_github("briabartsch/ExerciseHRCode")
```

## Example

This is a basic example which shows you how to run the code:

The following image shows how to set-up your R Studio environment and
run the ExerciseHRCode.

1)  “devtools” must be installed and loaded.

2)  “ExerciseHRCode” must be installed from GitHub.

3)  Run the code. Note: You will need to specify where you want the
    output files to be saved (output_folder = “XX”) and if you want a
    publication-style graph to be produced. If you want a
    publication-style graph, set “publication_graph” to TRUE. If you do
    not want a publication-style graph, set “publication_graph” to
    FALSE.

![](images/Code%20to%20run.jpg)

When you run the code, a file window will automatically open, as shown
below. Navigate to the location where you have your CSV file saved,
select the file, and press open. The code will continue to run.

![](images/Selection%20Window.jpg)

You will now be brought through a series of interactive steps in the
console, as shown below.

1)  You will be asked to select your desired bin size. Type 1, 2, 3, or
    4 into the console, and press enter.

2)  You will be asked to select the exercise intensity. Type 1, 2, or 3
    into the console, and press enter.

3)  You will be asked to determine maximal heart rate. If you have a
    predetermined heart rate that you would like to enter, type 1 into
    the console, and press enter. You will then be asked to enter your
    predetermined maximal heart rate. If you do not have a predetermined
    heart rate, press 2, and enter.

4)  If you did not enter a predetermined maximal heart rate, you will be
    asked to select the equation you wish to use for determining maximal
    heart rate. Type 1, 2, or 3 into the console, and press enter. For
    all selections, you will be asked to enter age. For HRR, you will
    also be asked to enter resting heart rate.

5)  You will be provided with the maximal heart rate and heart rate
    range in the console. You will also be told the path to where the
    graph and summarized date file were saved.

![](images/Console%20Selection%20Window.png)

Below is an example of the export if you select “publication_graph =
TRUE”

![](images/HIIT%20publication%20graph.jpg)

Below is an example of the export if you select “publication_graph =
FALSE”

![](images/HR%20graph.jpg)

Below is an example of what the summarize data CSV will look like:

![](images/File%20Screenshot.jpg)
