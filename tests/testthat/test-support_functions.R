#' @importFrom fs path_package

#incorrect filetype
test_that("incorrect file type", {
  expect_error(clean_file(fs::path_package("extdata","strings.pdf", package = "ExerciseHRCodePackage")))
})

#' @importFrom waldo compare
#'
#Produce wrangled dataframe from clean_file and wrangle_data
test_that("clean and wrangled dataframe",{
  expect_snapshot(
    waldo::compare(c('minute' = "numeric", 'mean_hr' = "numeric",'max_hr' = "numeric",'min_hr' = "numeric"),
                   sapply(
                     wrangle_data(
                       clean_file(fs::path_package("extdata","mi_example.csv", package = "ExerciseHRCodePackage"))$df,
                       bin_size = 60,
                       clean_file(fs::path_package("extdata","mi_example.csv", package = "ExerciseHRCodePackage"))$date)
                     , class))
  )
})
