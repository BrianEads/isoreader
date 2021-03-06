% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/settings.R
\name{iso_show_default_reader_parameters}
\alias{iso_show_default_reader_parameters}
\title{Show the current default parameters}
\usage{
iso_show_default_reader_parameters(data = NULL, func = NULL, ...)
}
\arguments{
\item{data}{a data frame - returned invisibly as is if provided (e.g. in the middle of a pipeline)}

\item{func}{function to use for formatting the reader parameters table, e.g. \code{\link[knitr]{kable}}. 
Note that if the output is in RMarkdown chunks, the chunk option must have \code{results="asis"} for the table to be correctly formatted.}

\item{...}{additional parameters to forward to the \code{func} function}
}
\description{
Shows a table with the default function parameters for this package.
}
\seealso{
Other settings functions: \code{\link{iso_caching}},
  \code{\link{iso_get_default_reader_parameters}},
  \code{\link{iso_info_messages}},
  \code{\link{iso_set_default_read_parameters}}
}
\concept{settings functions}
