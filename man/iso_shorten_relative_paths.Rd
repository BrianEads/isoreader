% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/utils.R
\name{iso_shorten_relative_paths}
\alias{iso_shorten_relative_paths}
\title{Shorten relative paths}
\usage{
iso_shorten_relative_paths(path, root = ".")
}
\arguments{
\item{path}{vector of file/folder paths, mixed relative and absolute paths are allowed.}

\item{root}{root for relative paths. Can be relative to the current working directory (e.g. \code{"data"}) or an absolute path on the file system (e.g. \code{"/Users/..."} or \code{"C:/Data/.."}). The default is the current working directory (\code{"."}). Can be supplied as a vector of same length as the provided paths if the paths have different roots.}
}
\value{
a data frame with the root directories and paths relative to the root - order of input paths is preserved
}
\description{
Convenience function to shorten relative paths based on overlap with the provided root(s). Also simplifies current directory repeats (e.g. "././." becomes ".") for better legiblity. Does not check whether the original or resulting paths point to valid files or folders. Relative paths that do not start with the supplied \code{root} default back to the current working directory (\code{.}). Absolute paths are allowed but are returned as is without attempts at shortening. See \code{iso_find_absolute_path_roots} for rooting absolute paths.
}
\examples{
iso_shorten_relative_paths(file.path("A", "B", "C"), "A") # root = "A", path = B/C
iso_shorten_relative_paths(file.path("A", "B", "C"), file.path("A", "B")) # root = "A/B", path = "C"
iso_shorten_relative_paths(file.path("A", "C", "D"), file.path("A", "B")) # root = "A", path = "C/D"
iso_shorten_relative_paths(file.path("A", "B", "C"), "B") # root = ".", path stays "A/B/C"
}
\seealso{
Other file system functions: \code{\link{iso_expand_paths}},
  \code{\link{iso_find_absolute_path_roots}},
  \code{\link{iso_root_paths}}
}
\concept{file system functions}
