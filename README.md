
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ExerciseHRCodePackage

<!-- badges: start -->
<!-- badges: end -->

ExerciseHRCode provides an easy way to analyze exercise heart rate data
from Polar for the purpose of:

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

What is special about using `README.Rmd` instead of just `README.md`?
You can include R chunks like so:

``` r
summary(cars)
#>      speed           dist       
#>  Min.   : 4.0   Min.   :  2.00  
#>  1st Qu.:12.0   1st Qu.: 26.00  
#>  Median :15.0   Median : 36.00  
#>  Mean   :15.4   Mean   : 42.98  
#>  3rd Qu.:19.0   3rd Qu.: 56.00  
#>  Max.   :25.0   Max.   :120.00
```

You’ll still need to render `README.Rmd` regularly, to keep `README.md`
up-to-date. `devtools::build_readme()` is handy for this.

You can also embed plots, for example:

<img src="man/figures/README-pressure-1.png" width="100%" />

In that case, don’t forget to commit and push the resulting figure
files, so they display on GitHub and CRAN.
