% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/support_functions.R
\name{wrangle_data}
\alias{wrangle_data}
\title{Wrangle Data}
\usage{
wrangle_data(df = NULL, bin_size = NULL, date = NULL)
}
\arguments{
\item{df}{should be a data.frame from \code{\link[=clean_file]{clean_file()}}}

\item{bin_size}{numeric value from \code{\link[=select_bin_size]{select_bin_size()}}}

\item{date}{date object from \code{\link[=clean_file]{clean_file()}}}
}
\value{
A data frame ready for use or an error
}
\description{
This function takes the output from \code{\link[=clean_file]{clean_file()}} and wrangles data so that it's ready for analysis
}
\details{
20240306: Bria to add options to choose what size bins. Use the utils::menu function to create pretty functions. JC
}
\section{Development}{

20240314: updated bin_size in params. Changed structure of function from if statements to using bin_size_select numerical
output as summarizing factor. JC
}

