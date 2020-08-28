#' Get \code{stars} layer values as matrix
#'
#' Extracts the values of a single layer in a \code{stars} object to a \code{matrix}.
#'
#' @param	x	A \code{stars} raster with one attribute and two dimensions, \code{x} and \code{y}, i.e., a single-band raster.
#' @param check Whether to check (and fix if necessary) that input has one attribute, one layer and x-y as dimensions 1-2 (default is \code{TRUE}).
#' @return A \code{matrix} with the layer values, having the same orientation as the raster (i.e., rows represent the y-axis and columns represent the x-axis).
#'
#' @examples
#' data(dem)
#' m = layer_to_matrix(dem)
#' m
#'
#' @export

layer_to_matrix = function(x, check = TRUE) {

  # Checks
  if(check) {
    x = check_one_attribute(x)
    x = check_2d(x)
  }

  # To matrix
  m = t(x[[1]])

  # Return
  return(m)

}
