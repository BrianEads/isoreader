% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/aggregate_data.R
\name{iso_get_bgrd_data}
\alias{iso_get_bgrd_data}
\title{Aggregate background data}
\usage{
iso_get_bgrd_data(iso_files, select = everything(), gather = FALSE,
  include_file_info = NULL, quiet = default(quiet))
}
\arguments{
\item{iso_files}{collection of iso_file objects}

\item{select}{which raw data columns to select - use \code{c(...)} to select multiple, supports all \link[dplyr]{select} syntax. By default, all columns are selected.}

\item{gather}{whether to gather raw data into long format (e.g. for ease of use in plotting). Not that the \code{select} parameter applies to the data columns BEFORE gathering.}

\item{include_file_info}{which file information to include (see \code{\link{iso_get_file_info}}). Use \code{c(...)} to select multiple, supports all \link[dplyr]{select} syntax including renaming columns.}

\item{quiet}{whether to display (quiet=FALSE) or silence (quiet = TRUE) information messages. Set parameter to overwrite global defaults for this function or set global defaults with calls to \link[=iso_info_messages]{iso_turn_info_message_on} and \link[=iso_info_messages]{iso_turn_info_message_off}}
}
\description{
Aggregate the background data from the provided iso_files. Can aggregate either in a wide table (for easy overview) or a gathered long table (for plotting and further data processing). The background data is only available if the iso_files were read with parameter \code{read_raw_data=TRUE}.
}
\seealso{
Other data retrieval functions: \code{\link{iso_get_data}},
  \code{\link{iso_get_file_info}},
  \code{\link{iso_get_raw_data}},
  \code{\link{iso_get_resistors_info}},
  \code{\link{iso_get_standards_info}},
  \code{\link{iso_get_vendor_data_table}}
}
\concept{data retrieval functions}
