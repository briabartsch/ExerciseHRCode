% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/support_functions.R
\name{clean_file}
\alias{clean_file}
\title{Clean File}
\usage{
clean_file(file_path = NULL)
}
\arguments{
\item{file_path}{Should be the export from polar in either csv or xlsx format}
}
\value{
A list including a data frame ready for analysis as well as the date and name of testing
}
\description{
This function reads and cleans the HR file by setting the header line and cleaning names
}
\section{Notes for development}{

Double check to make sure file is output in seconds. JC \cr
}

