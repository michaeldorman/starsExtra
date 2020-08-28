#' Normalize a 3D 'stars' object
#'
#' Check, and possibly correct, that the input \code{stars} object:
#' \itemize{
#' \item{Has exactly one attribute.}
#' \item{Has exactly three dimensions.}
#' \item{The first two dimensions are spatial, named \code{x} and {y} (in that order).}
#' }
#'
#' @param x A \code{stars} object
#'
#' @return A new \code{stars} object
#' @export
#'
#' @examples
#' # Small example
#' data(landsat)
#' normalize_3d(landsat)

normalize_3d = function(x) {

  # Check & normalize
  x = check_one_attribute(x)
  x = check_3d(x)

  # Return
  return(x)

}

