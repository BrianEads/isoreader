# read cached isoreader files
# @param ds the data structure to fill
# @param custom reader options - none needed
iso_read_rds <- function(ds, options = list()) {
  
  # safety checks
  if(!iso_is_file(ds)) stop("data structure must be an iso_file", call. = FALSE)
  
  # load rds file
  iso_files <- readRDS(get_ds_file_path(ds)) 
  
  # make sure object in file was loaded properly
  if (exists("isofiles", inherits = FALSE)) { 
    if (!is.list(isofiles)) isofiles <- as.list(isofiles)
    is_old_isofile <- map_lgl(isofiles, ~is(.x, "isofile"))
    isofiles[is_old_isofile] <- map(isofiles[is_old_isofile], function(isofile) {
      class(isofile) <- class(isofile) %>% { .[.!="isofile"] } %>% c("iso_file")
      return(isofile)
    })
    iso_files <- iso_as_file_list(isofiles)
  }
  if (!(iso_is_object(iso_files))) 
    stop("R Data Storage did not contain iso_file data", call. = FALSE)
  iso_files <- iso_as_file_list(iso_files)
  
  # make sure all are the appropriate classes
  if (!all(ok <- lapply(iso_files, class) %>% sapply(identical, class(ds)))) 
    sprintf("Mismatched file types, expected '%s' but encountered '%s'", 
            str_c(class(ds)[1]), str_c(iso_files[!ok] %>% sapply(function(i) class(i)[1]) %>% unique(), collapse = ", ")) %>% 
    stop(call. = FALSE)
  
  # information
  if (!default(quiet)) {
    sprintf("loaded data for %d data files from R Data Storage - checking loaded files for content consistency...", length(iso_files)) %>% 
      log_message()
  }
  
  # check for version warning
  versions <- map(iso_files, `[[`, "version")
  ok_version <- map_lgl(versions, same_as_isoreader_version, packageVersion("isoreader"))
  if (any(!ok_version)) {
    messages <- sprintf("file created by a different version of the isoreader package (%s)", map_chr(versions[!ok_version], as.character))
    iso_files[!ok_version] <- map2(iso_files[!ok_version], messages, register_warning, func = "iso_read_rds", warn = FALSE)
  }

  if (any(!ok_version)) {
    sprintf("version mismatch - %.0f of the %.0f data files stored in the R Data Structure ('%s') were created by a different version of the isoreader package. This may lead to processing problems.", 
            sum(!ok_version), length(iso_files), ds$file_info$file_id) %>% 
    log_warning()
    log_warning("Consider re-reading the original data files using the 'iso_reread_files()' or 'iso_reread_storage()' function.")
  }

  return(iso_files)
}
