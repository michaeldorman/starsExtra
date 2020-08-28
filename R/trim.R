#' Remove empty outer rows and columns
#'
#' Removes complete outer rows and columns which have \code{NA} values.
#'
#' @param x A two-dimensional \code{stars} object
#'
#' @return A new \code{stars} object with empty outer rows and columns removed
#' @export
#'
#' @examples
#' # Small example
#' data(dem)
#' dem[[1]][1,] = NA
#' dem1 = trim(dem)

trim = function(x) {

  # Checks
  x = check_one_attribute(x)
  x = check_2d(x)

  # Calculate rows/columns to retain
  dim1 = apply(x[[1]], 1, function(x) !all(is.na(x)))
  dim1 = which(dim1)
  dim1 = dim1[1]:dim1[length(dim1)]
  dim2 = apply(x[[1]], 2, function(x) !all(is.na(x)))
  dim2 = which(dim2)
  dim2 = dim2[1]:dim2[length(dim2)]

  # Trim
  x = x[, dim1, dim2]
  x = st_normalize(x)

  # Return
  return(x)

}

