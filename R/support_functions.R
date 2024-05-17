#required_libraries <- c('tidyverse', 'rio', 'janitor')


#### Load language ####
#### Declares language upload loading the package.
.onAttach <- function(libname, pkgname) {
  packageStartupMessage("ExerciseHRCode has been loaded")
}

#### Global Variables ####
globalVariables(c("time","hr_bpm","datetime","time_bin","Name","bounds"))

#### clean_file function ####
#' @name clean_file
#'
#' @title Clean File
#'
#' @description This function reads and cleans the HR file by setting the header line and cleaning names
#'
#' @param file_path Should be the export from polar in either csv or xlsx format
#'
#' @import rio
#' @import janitor
#' @importFrom lubridate dmy
#' @importFrom utils head
#'
#' @returns A list including a data frame ready for analysis as well as the date and name of testing
#'
#' @section Notes for development:
#' Double check to make sure file is output in seconds. JC \cr
#'
#'
clean_file <- function(file_path = NULL) {

  #Check to make sure the filetype is correct
  if(!rio::get_ext(file_path) %in% c('csv','xlsx','xls')){
    stop(paste0(basename(file_path),'s filetype is not usable. It must be a .csv, .xlsx, or .xls filetype. Please correct the filetype before continuing'))
  }

  date <- rio::import(file_path) %>%
    select(Date) %>%
    utils::head(1) %>%
    mutate(Date = lubridate::dmy(Date)) %>%
    pull()

  name <- rio::import(file_path) %>%
    select(Name) %>%
    utils::head(1) %>%
    pull()

  # Read and clean the data
  suppressWarnings(df <- rio::import(file_path) %>%
    janitor::row_to_names(row_number = 2) %>%
    janitor::clean_names())

  # Check if 'hr_bpm' and 'time' columns are present in the data frame
  if (!("hr_bpm" %in% colnames(df)) || !("time" %in% colnames(df))) {
    stop("Required columns 'hr_bpm' and 'time' are missing in the data frame.")
  }

  return(list(date = date, df = df, name = name))
}


#### Select bin size selection ####
#' @name select_bin_size
#'
#' @title Select Bin Size
#'
#' @description This function allows users to select 15, 30, 45, or 60 second time bins for dividing the data.
#'
#' @returns Selected bin size
#'
#' @importFrom utils menu
#'
#' @section Development:
#' 20240314: Removed df from function parameters
#'
#'
select_bin_size <- function() {
  cat("Would you like the exercise to be divided into 15s, 30s, 45s, or 60s time bins?\n")
  choice <- utils::menu(title = "Select Bin Size", choices = c("15 seconds", "30 seconds", "45 seconds", "60 seconds"))

  # Mapping user choice to corresponding time interval
  time_intervals <- c(15, 30, 45, 60)
  bin_size <- time_intervals[choice]

  #User confirmation of bin selection
  cat("You selected", bin_size, "seconds as the bin size.\n")

  return(bin_size)
}


#### wrangle_data function ####
#' 20240306: Bria to add options to choose what size bins. Use the utils::menu function to create pretty functions. JC
#' @name wrangle_data
#'
#' @title Wrangle Data
#'
#' @description This function takes the output from [clean_file()] and wrangles data so that it's ready for analysis
#'
#' @param df should be a data.frame from [clean_file()]
#' @param bin_size numeric value from [select_bin_size()]
#' @param date date object from [clean_file()]
#'
#' @import lubridate
#' @import dplyr
#'
#' @returns A data frame ready for use or an error
#'
#' @section Development:
#' 20240314: updated bin_size in params. Changed structure of function from if statements to using bin_size_select numerical
#' output as summarizing factor. JC
#'
#'
wrangle_data <- function(df = NULL, bin_size = NULL, date = NULL) {
  if (is.null(df)) {stop("Data frame is missing.")
    }

  df_return <- df %>%
    dplyr::mutate(datetime = ymd_hms(paste(date,time)),
                  hr_bpm = as.numeric(hr_bpm)) %>%
    dplyr::group_by(time_bin = cut(datetime, breaks = paste0(bin_size," sec"), labels = F)) %>%
    dplyr::summarize(mean_hr = mean(hr_bpm),
                     max_hr = max(hr_bpm),
                     min_hr = min(hr_bpm)) %>%
    dplyr::mutate(time_bin = seconds(time_bin*bin_size))

  return(df_return)
}


#' Use TryCatch here too. JC
#Select participant age
#' @name enter_age
#'
#' @title Enter Age
#'
#' @description This function allows the user to enter the participant's age. Age is required for calculating maximal heart rate.
#'
#' @returns Participant's age
#' @section Details:
#' 20240323: Roxygen Skeleton added. BB


enter_age <- function() {

  age <- as.numeric(readline(prompt = "Please enter the participant's age: "))

  while(is.na(age)){
    message("The text entered is not numeric. Please try again.")
    age <- as.numeric(readline(prompt = "Please enter the participant's age: "))
  }

  cat("You entered", age, "years of age.\n")
  return(age)


}

#### Function to Select Exercise Intensity ####
#' @name select_intensity
#'
#' @title Select Intensity
#'
#' @description This function allows the user to select their target exercise intensity.
#'
#' @returns Selected intensity
#'
#' @importFrom utils menu
#'
#' @section Details:
#' 20240319: Return upper bound and lower bound instead of text field. Put text about ACSM selections. JC
#' 20240323: Added in details for light, moderate, vigorous ranges, from ACSM's Guidelines for Exercise Testing and Prescription 11th ed. BB
#' 20240324: Added in if else statements to calculate upper and lower bounds and return these to the user. BB
select_intensity <- function() {
  cat("Is this for light, moderate, or vigorous intensity exercise?
     Intensity ranges are in line with ACSM's Guidelines for Exercise Testing and Prescription (11th edition)\n")
  selected_intensity <- utils::menu(title = "Select Intensity", choices = c("Light: 57-63% HRmax", "Moderate: 64-76% HRmax", "Vigorous: 77-95% HRmax"))

  # Mapping user choice to corresponding intensity
  #selected_intensity <- c("Light: 57-63% HRmax", "Moderate: 64-76% HRmax", "Vigorous: 77-95% HRmax")

  if(selected_intensity == 1){
    upper_bound <- .63
    lower_bound <- .57
  } else if (selected_intensity == 2){
    upper_bound <- .76
    lower_bound <- .64
  } else if (selected_intensity == 3){
    upper_bound <- .95
    lower_bound <- .77
  }

  return(list(upper_bound = upper_bound, lower_bound = lower_bound))

}


#' @name select_equation
#'
#' @title Select Heart Rate Max Equation
#'
#' @description This function allows the user to choose the appropriate equation for calculating maximum heart rate.
#'
#' @returns Maximum heart rate
#'
#' @param lower_bound numeric value from [select_intensity()]
#' @param upper_bound numeric value from [select_intensity()]
#'
#' @section Details:
#' 20240323: Roxygen skeleton added. BB
#' 20240324: Added hr_max variable and changed code to return predicted HRmax. BB
#' 20240326: is the 1st equation right? I see hr_max as 220-age.
#'
#'

select_equation <- function(lower_bound = NULL, upper_bound = NULL) {

  #Option to enter predetermined HRmax
  hrmax_enter <- utils::menu(title = "Do you have a predetermined maximal heart rate to enter?", choices = c("Yes", "No"))

  if (hrmax_enter == 1) {
    hr_max <- as.numeric(readline(prompt = "Please enter the maximal heart rate. This will be used for calculating intensity ranges."))

    while(is.na(hr_max)){
      message("The text entered is not numeric. Please try again.")
      hr_max <- as.numeric(readline(prompt = "Please enter the maximal heart rate. This will be used for calculating intensity ranges."))
    }

    lower_bound_hr <- hr_max * lower_bound
    upper_bound_hr <- hr_max * upper_bound
    cat("Your maximal heart rate is", hr_max, "bpm. For the intensity range, your lower bound is", lower_bound_hr, "bpm and your upper bound is",upper_bound_hr,"bpm.\n")
    return(list(hr_max = hr_max, lower_bound_hr = lower_bound_hr, upper_bound_hr = upper_bound_hr))
  }

  # Select equation
  else if (hrmax_enter == 2) {
    cat("Please select a heart rate equation.\n")
    choice <- utils::menu(title = "Select Heart Rate Equation", choices = c("220 - age", "HRR: [(220 - age) - resting HR]*target intensity + resting HR", "Beta-blocker: 164 - (0.7*age)"))


    # Mapping user choice to corresponding equation
    selected_equation <- c("220 - age", "HRR: [(220 - age) - resting HR]*target intensity + resting HR", "Beta-blocker: 164 - (0.7*age)")
    equation <- selected_equation[choice]

    #Enter age
    age <- enter_age()

    # If the user selected the HRR equation, prompt for resting HR, then calculate max predicted HR
    if (equation == "HRR: [(220 - age) - resting HR]*target intensity + resting HR") {
      resting_hr <- as.numeric(readline(prompt = "Please enter your resting heart rate. This will be used for calculating intensity ranges. "))

      while(is.na(resting_hr)){
        message("The text entered is not numeric. Please try again.")
        resting_hr <- as.numeric(readline(prompt = "Please enter your resting heart rate. This will be used for calculating intensity ranges. "))
      }
      
      if(lower_bound == .57){
        upper_bound <- .39
        lower_bound <- .30
      } else if (lower_bound == .64){
        upper_bound <- .59
        lower_bound <- .40
      } else if (lower_bound == .77){
        upper_bound <- .89
        lower_bound <- .60
      }

      hr_max <- 220 - age
      lower_bound_hr <- ((220 - age) - resting_hr) * lower_bound + resting_hr
      upper_bound_hr <- ((220 - age) - resting_hr) * upper_bound + resting_hr
      cat("Your maximal heart rate is", hr_max, "bpm. For the intensity range, your lower bound is ", lower_bound_hr, "bpm and your upper bound is ",upper_bound_hr," bpm.\n")
      return(list(hr_max = hr_max, lower_bound_hr = lower_bound_hr, upper_bound_hr = upper_bound_hr))
    }

    #If the user selected the 220-age equation, calculate max predicted HR
    else if (equation == "220 - age") {
      #hr_max <- 220-age
      #cat("Your predicted heart rate max is", hr_max, "bpm.\n")
      #return(list(equation = equation))
      hr_max <- 220 - age
      lower_bound_hr <- (220 - age) * lower_bound
      upper_bound_hr <- (220 - age) * upper_bound
      cat("Your maximal heart rate is", hr_max, "bpm. For the intensity range, your lower bound is ", lower_bound_hr, "bpm and your upper bound is ",upper_bound_hr," bpm.\n")
      return(list(hr_max = hr_max, lower_bound_hr = lower_bound_hr, upper_bound_hr = upper_bound_hr))
    }

    #If the user selected the beta-blocker equation, calculate max predicted HR
    else if (equation == "Beta-blocker: 164 - (0.7*age)") {
      # hr_max <- 164-(0.7*age)
      # cat("Your predicted heart rate max is", hr_max, "bpm.\n")
      # return(list(equation = equation))
      hr_max <- (164-(0.7*age))
      lower_bound_hr <- (164-(0.7*age)) * lower_bound
      upper_bound_hr <- (164-(0.7*age)) * upper_bound
      cat("Your maximal heart rate is", hr_max, "bpm. For the intensity range, your lower bound is ", lower_bound_hr, "bpm and your upper bound is ",upper_bound_hr," bpm.\n")
      return(list(hr_max = hr_max, lower_bound_hr = lower_bound_hr, upper_bound_hr = upper_bound_hr))
    }
  }
}

#### Create_graph ####
#' @name create_graph
#'
#' @title Create Graph for Exercise Heart Rate Response
#'
#' @description This function will graph the heart rate response over time with target intensity zone highlighted
#'
#' @param df data fram from [clean_file()]
#' @param date date from [clean_file()]
#' @param lower_bound numeric value from [select_equation()]
#' @param upper_bound numeric value from [select_equation()]
#'
#' @import ggplot2
#'
#'
#' @returns Graph with heart rate over time and target intensity zone highlighted
#'
create_graph <- function(df = NULL, date = NULL, lower_bound = NULL, upper_bound = NULL) {

  df <- df %>%
    dplyr::mutate(datetime = ymd_hms(paste(date, time)),
                  hr_bpm = as.numeric(hr_bpm))

 plot <- ggplot2::ggplot(data = df, ggplot2::aes(x = datetime, y = hr_bpm)) +
    ggplot2::geom_line(color = "red") +
    ggplot2::scale_x_datetime(date_breaks = "5 mins", date_labels = "%H:%M:%S") +
    ggplot2::scale_y_continuous(breaks = seq(50, 200, by = 10)) +
    ggplot2::labs(x = "Time", y = "Heart Rate", title = "Heart Rate Over Time") +
    ggplot2::geom_ribbon( ggplot2::aes(ymin = lower_bound, ymax = upper_bound), fill = "black", alpha = 0.2)

 return(plot)

}

#### Create_publication_graph ####
#' @name create_pub_graph
#'
#' @title Create Publication Graph for Exercise Heart Rate Response
#'
#' @description This function will graph the heart rate response over time with target intensity zone highlighted
#' and will be formatted for publication
#'
#' @param df data fram from [clean_file()]
#' @param date date from [clean_file()]
#' @param lower_bound numeric value from [select_equation()]
#' @param upper_bound numeric value from [select_equation()]
#'
#' @import ggplot2
#' @importFrom ggprism theme_prism
#'
#' @returns Graph with heart rate over time and target intensity zone highlighted
#'
create_pub_graph <- function(df = NULL, date = NULL, lower_bound = NULL, upper_bound = NULL) {

  df <- df %>%
    dplyr::mutate(datetime = ymd_hms(paste(date, time)),
                  hr_bpm = as.numeric(hr_bpm))


  plot <- ggplot2::ggplot(df, ggplot2::aes(x = datetime, y = hr_bpm)) +
    ggplot2::geom_line(size = 1.2) +
    ggplot2::scale_x_datetime(breaks = "5 mins", date_labels = "%H:%M:%S") +
    ggplot2::scale_y_continuous(breaks = seq(50, 200, by = 10)) +
    ggplot2::labs(x = "Time", y = "Heart Rate") +
    ggplot2::geom_hline(yintercept = lower_bound, linetype = 'dashed', lwd = 1.2) +
    ggplot2::geom_hline(yintercept = upper_bound, linetype = 'dashed', lwd = 1.2) +
    ggprism::theme_prism(base_size = 12)

  return(plot)

}






