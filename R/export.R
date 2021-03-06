## Export functions =======

#' Export data to R Data Archive (.rda) (deprecated)
#' 
#' This function is deprecated. Please use \code{\link{iso_save}} instead to save collections of isofiles.
#' 
#' @inheritParams iso_get_raw_data
#' @param filepath the path (folder and filename) to the export file. The correct file extension is automatically added if not already in the filename, i.e. filename can be provided with or without extension.
#' @family export functions
#' @return returns the iso_files object invisibly for use in pipelines
#' @export
iso_export_to_rda <- function(iso_files, filepath, quiet = default(quiet)) {
  # throw deprecation warning
  log_warning("'iso_export_to_rda' is deprecated and will call 'iso_save()'. Please call 'iso_save()' directly to avoid this warning.")

  # call iso_save
  iso_save(iso_files, filepath, quiet)
}

#' Export data to Excel
#' 
#' This function exports the passed in iso_files to Excel. The different kinds of data (raw data, file info, methods info, etc.) are exported to separate tabs within the excel file but they are only exported if the corresponding \code{include_} parameter is set to \code{TRUE} and only for data types for which this type of data is available and was read (see \code{\link{iso_read_dual_inlet}}, \code{\link{iso_read_continuous_flow}} for details on read parameters). Note that in rare instances where vectorized data columns exist in the file information (e.g. measurement_info), they are concatenated with ', ' in the excel export.
#' 
#' @inheritParams iso_save
#' @param include_raw_data whether to include the raw data in the export (if available)
#' @param include_file_info whether to include the file info in the export (if available)
#' @param include_method_info whether to include methods infor in the export (if available)
#' @param include_vendor_data_table whether to include the vendor data table in the export (if available)
#' @param include_problems whether to include the problems table
#' @family export functions
#' @return returns the iso_files object invisibly for use in pipelines
#' @export
iso_export_to_excel <- function(iso_files, filepath, 
                            include_raw_data = TRUE, include_file_info = TRUE, 
                            include_method_info = TRUE, include_vendor_data_table = TRUE,
                            include_problems = TRUE,
                            quiet = default(quiet)) {
  
  # safety checks
  if(!iso_is_object(iso_files)) stop("can only export iso files or lists of iso files", call. = FALSE)
  filepath <- get_excel_export_filepath(iso_files, filepath)
  
  # save iso_files
  export_iso_files <- iso_as_file_list(iso_files)
  if (!quiet) {
    sprintf("Info: exporting data from %d iso_files into Excel '%s'", length(export_iso_files), 
            str_replace(filepath, "^\\.(/|\\\\)", "")) %>% message()
  }
  
  # make excel workbook
  wb <- createWorkbook()
  hs <- createStyle(textDecoration = "bold")
  if (include_raw_data) {
    addWorksheet(wb, "raw data")
    raw_data <- iso_get_raw_data(export_iso_files, quiet = TRUE)
    if (ncol(raw_data) > 0) writeData(wb, "raw data", raw_data, headerStyle = hs)
  }
  if (include_file_info) {
    addWorksheet(wb, "file info")
    # note: this takes care of nested vectors, they get concatenated with ', '
    writeData(wb, "file info", 
              iso_get_file_info(export_iso_files, quiet = TRUE) %>% collapse_list_columns(),
              headerStyle = hs)
  }
  if (include_method_info) {
    addWorksheet(wb, "method info")
    standards <- iso_get_standards_info(export_iso_files, quiet = TRUE)
    resistors <- iso_get_resistors_info (export_iso_files, quiet = TRUE)
    if (ncol(standards) > 0) writeData(wb, "method info", standards, headerStyle = hs)
    if (ncol(resistors) > 0) writeData(wb, "method info", resistors, startRow = nrow(standards) + 3, headerStyle = hs)
  }
  if (include_vendor_data_table) {
    addWorksheet(wb, "vendor data table")
    vendor_data <- iso_get_vendor_data_table(export_iso_files, quiet = TRUE)
    if (ncol(vendor_data) > 0) writeData(wb, "vendor data table", vendor_data, headerStyle = hs)
  }
  if (include_problems) {
    addWorksheet(wb, "problems")
    writeData(wb, "problems", problems(iso_files), headerStyle = hs)
  }
  saveWorkbook(wb, filepath, overwrite = TRUE)
  
  return(invisible(iso_files))
}


#' Export to feather
#' 
#' This function exports the passed in iso_files to the Python and R shared feather file format. The different kinds of data (raw data, file info, methods info, etc.) are exported to separate feather files that are saved with the provided \code{filepath_prefix} as prefix. All are only exported if the corresponding \code{include_} parameter is set to \code{TRUE} and only for data types for which this type of data is available and was read (see \code{\link{iso_read_dual_inlet}}, \code{\link{iso_read_continuous_flow}} for details on read parameters). Note that in rare instances where vectorized data columns exist in the file information (e.g. measurement_info), they are concatenated with ', ' in feather output.
#' 
#' @inheritParams iso_export_to_excel
#' @param filepath_prefix the path (folder and filename) prefix for the exported feather files. The correct suffix for different kinds of data and file extension is automatically added
#' @family export functions
#' @return returns the iso_files object invisibly for use in pipelines
#' @export
iso_export_to_feather <- function(iso_files, filepath_prefix, 
                              include_raw_data = TRUE, include_file_info = TRUE, 
                              include_method_info = TRUE, include_vendor_data_table = TRUE,
                              include_problems = TRUE,
                              quiet = default(quiet)) {
  
  # safety checks
  if(!iso_is_object(iso_files)) stop("can only export iso files or lists of iso files", call. = FALSE)
  
  # save iso_files
  # note: not sure yet how to best implement different data types such as scan here
  filepaths <- get_feather_export_filepaths(iso_files, filepath_prefix)
  if (!quiet) {
    sprintf("Info: exporting data from %d iso_files into %s files at '%s'", length(iso_as_file_list(iso_files)), 
            filepaths[['ext']], str_replace(filepaths[['base']], "^\\.(/|\\\\)", "")) %>% message()
  }
  
  # make feather files in temporary dir
  if (include_raw_data) 
    write_feather(iso_get_raw_data(iso_files, quiet = TRUE), filepaths[['raw_data']])
  
  if (include_file_info) 
    # note: this takes care of nested vectors, they get concatenated with ', '
    write_feather(iso_get_file_info(iso_files, quiet = TRUE) %>% collapse_list_columns(), 
                  filepaths[['file_info']])
  
  if (include_method_info) {
    write_feather(iso_get_standards_info(iso_files, quiet = TRUE), filepaths[['method_info_standards']])
    write_feather(iso_get_resistors_info (iso_files, quiet = TRUE), filepaths[['method_info_resistors']])
  }
  
  if (include_vendor_data_table) 
    write_feather(iso_get_vendor_data_table(iso_files, quiet = TRUE), filepaths[['vendor_data_table']])
  
  if (include_problems) 
    write_feather(problems(iso_files), filepaths[['problems']])
  
  return(invisible(iso_files))
}

# utility functions ====

# convenience function for export file paths (extension checks and addition)
get_export_filepath <- function(filepath, ext) {
  # file name and folder
  if (missing(filepath)) stop("no filepath provided", call. = FALSE)
  filename <- basename(filepath)
  folder <- dirname(filepath)
  if (!file.exists(folder)) stop("the folder '", folder, "' does not exist", call. = FALSE)
  if (!is.null(ext))
    filename <- filename %>% str_replace(fixed(ext), "") %>% str_c(ext) # to make sure correct extension
  return(file.path(folder, filename)) 
}

# excel export filephat
get_excel_export_filepath <- function(iso_files, filepath) {
  if (iso_is_continuous_flow(iso_files))
    ext <- ".cf.xlsx"
  else if (iso_is_dual_inlet(iso_files))
    ext <- ".di.xlsx"
  else
    stop("Excel export of this type of iso_files not yet supported", call. = FALSE) 
  return(get_export_filepath(filepath, ext))
}

# feather export filepath
get_feather_export_filepaths <- function(iso_files, filepath) {
  if (iso_is_continuous_flow(iso_files))
    ext <- ".cf.feather"
  else if (iso_is_dual_inlet(iso_files))
    ext <- ".di.feather"
  else
    stop("Feather export of this type of iso_files not yet supported", call. = FALSE) 
  
  filepath <- get_export_filepath(filepath, NULL)
  return(
    c(
      base = filepath,
      ext = ext,
      raw_data = str_c(filepath, "_raw_data", ext),
      file_info = str_c(filepath, "_file_info", ext),
      method_info_standards = str_c(filepath, "_method_info-standards", ext),
      method_info_resistors = str_c(filepath, "_method_info-resistors", ext),
      vendor_data_table = str_c(filepath, "_vendor_data_table", ext),
      problems = str_c(filepath, "_problems", ext)
    )
  )
}
