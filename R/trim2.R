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
#' # Single-band example
#' data(dem)
#' dem[[1]][1,] = NA
#' dem1 = trim2(dem)
#' 
#' # Multi-band example
#' data(landsat)
#' landsat[[1]][1:100,,] = NA
#' landsat1 = trim2(landsat)
#' 

trim2 = function(x) {

  # Checks
  x = check_one_attribute(x)
  x = check_2d_3d(x)

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

