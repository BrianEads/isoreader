# Note: probably best to implement these as 

#' Aggregate raw data
#' 
#' @param isofiles isotope file objects
#' @family data aggregation functions
#' @export
get_raw_data <- function(isofiles) {
  if (!is(isofiles, "list")) isofiles <- list(isofiles)
  check_isofiles(isofiles)
  check_read_options(isofiles, "raw_data")
  
  # Note: provide easy way to include additional information (merge with get_file_info() but a select set of columns)
  lapply(isofiles, function(isofile) {
    as_data_frame(isofile$raw_data) %>% 
      mutate(file_id = isofile$file_info$file_id) %>% 
      select(file_id, everything())
  }) %>% bind_rows()
}

#' Aggregate file info
#'
#' @inheritParams get_raw_data
#' @family data aggregation functions
#' @export
get_file_info <- function(isofiles) {
  if (!is(isofiles, "list")) isofiles <- list(isofiles)
  check_isofiles(isofiles)
  check_read_options(isofiles, "file_info")
  
  # Note: need to check for file info values that may have more than 1 value
  lapply(isofiles, function(isofile) {
    as_data_frame(isofile$file_info)
  }) %>% bind_rows()
}


#' Aggregate table data
#' 
#' @inheritParams get_raw_data
#' @family data aggregation functions
#' @export
get_data_table <- function(isofiles) {
  if (!is(isofiles, "list")) isofiles <- list(isofiles)
  check_isofiles(isofiles)
  
  stop("not implemented yet")
}

# check if all are isofiles
check_isofiles <- function(isofiles) {
  if (any(not_iso <- !sapply(isofiles, is, "isofile"))) {
    stop("encountered non-isofile data type(s): ",
         lapply(isofiles, class)[not_iso] %>% unlist() %>% 
           unique() %>% str_c(collapse = ", "), call. = FALSE)
  }
}

# check if read options are compatible
check_read_options <- function(isofiles, option) {
  option_values <- map(isofiles, "read_options") %>% map_lgl(option)
  if (!all(option_values)) {
    warning(sum(!option_values), "/", length(isofiles), 
            " files do not have ", str_replace(option, "_", " "), 
            " read and will have missing values in the aggregated data",
            call. = FALSE, immediate. = TRUE)
  }
}