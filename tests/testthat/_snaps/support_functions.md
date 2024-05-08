# clean and wrangled dataframe

    Code
      waldo::compare(c(minute = "numeric", mean_hr = "numeric", max_hr = "numeric",
        min_hr = "numeric"), sapply(wrangle_data(clean_file(fs::path_package(
        "extdata", "mi_example.csv", package = "ExerciseHRCodePackage"))$df,
      bin_size = 60, clean_file(fs::path_package("extdata", "mi_example.csv",
        package = "ExerciseHRCodePackage"))$date), class))
    Output
      `names(old)`: "minute"   "mean_hr" "max_hr" "min_hr"
      `names(new)`: "time_bin" "mean_hr" "max_hr" "min_hr"
      
      `old`: "numeric" "numeric" "numeric" "numeric"
      `new`: "Period"  "numeric" "numeric" "numeric"

