#' Normalize a 2D 'stars' object
#'
#' Check, and possibly correct, that the input \code{stars} object:
#' \itemize{
#' \item{Has exactly one attribute.}
#' \item{Has exactly two dimensions.}
#' \item{The dimensions are spatial, named \code{x} and \code{y} (in that order).}
#' }
#'
#' @param x A \code{stars} object
#'
#' @return A new \code{stars} object
#' @export
#'
#' @examples
#' # Small example
#' data(dem)
#' normalize_2d(dem)

normalize_2d = function(x) {

  # Check & normalize
  x = check_one_attribute(x)
  x = check_2d(x)

  # Return
  return(x)

}

