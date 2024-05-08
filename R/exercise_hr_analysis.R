#### Create Wrapper Function ####
#' @title Exercise HR Analysis Wrapper Function
#'
#' @description This is a master function that uses functions written in support_functions.R to produce
#' a chart and summarized data
#'
#' @param output_folder character - A path to where you'd like the image of the graph and the summarized data to be saved
#' @param file character - pathway on local computer to unedited Polar HR file to be analyzed
#' @param publication_graph Boolean (T/F) - True if you'd like your graph output to be publication quality
#'
#' @importFrom ggplot2 ggsave
#' @importFrom grDevices dev.new
#' @importFrom rio export
#'
#'
#' @returns HR graph
#'
#' @export
#'
#'

exercise_hr_analysis <- function(output_folder = NULL, file = NULL, publication_graph = FALSE) {

  if(is.null(file)){
    hii_file <- file.choose()
  } else {
    hii_file <- file
  }

  hi_clean <- clean_file(hii_file)
  selected_bin_size <- select_bin_size()
  wrangled_data <- wrangle_data(hi_clean$df, bin_size = selected_bin_size, date = hi_clean$date)
  intensity <- select_intensity()
  bounds <- select_equation(upper_bound = intensity$upper_bound, lower_bound = intensity$lower_bound)

  time_in_zone_df <- hi_clean$df %>%
    filter(hr_bpm >= bounds$lower_bound_hr & hr_bpm <= bounds$upper_bound_hr)


  output_df <- wrangled_data %>%
    mutate("Time in Zone (min)" = NA)

  output_df[1,5] <- round(nrow(time_in_zone_df)/60, digits = 3)


  if(publication_graph == FALSE){
    output_plot <- create_graph(df = hi_clean$df, date = hi_clean$date,
                 lower_bound = bounds$lower_bound_hr, upper_bound = bounds$upper_bound_hr)

    ggplot2::ggsave(filename = file.path(output_folder,paste0(hi_clean$name,"_",hi_clean$date,'_graph.jpg')),
                    width = 8,
                    height = 4,
                    units = "in")
  } else {
    output_plot <- create_pub_graph(df = hi_clean$df, date = hi_clean$date,
                 lower_bound = bounds$lower_bound_hr, upper_bound = bounds$upper_bound_hr)

    ggplot2::ggsave(filename = file.path(output_folder,paste0(hi_clean$name,"_",hi_clean$date,'_publication_graph.jpg')),
                    width = 8,
                    height = 4,
                    units = "in")
  }


  rio::export(output_df,
              file.path(output_folder,paste0(hi_clean$name,"_",hi_clean$date,'_summarized_data.csv')))

  message(paste("The graph and summarized data frame for", hi_clean$name,"on",hi_clean$date,"have been saved to",output_folder))




}
