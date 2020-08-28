#' Get \code{stars} layer values as vector
#'
#' Extracts the values of a single layer in a \code{stars} object to a vector. Cell values are ordered from top-left corner to the right.
#'
#' @param	x	A raster (class \code{stars}) with two dimensions: \code{x} and \code{y}, i.e., a single-band raster.
#' @param check Whether to check (and fix if necessary) that input has one attribute, one layer and x-y as dimensions 1-2 (default is \code{TRUE}).
#' @return A vector with cell values, ordered by rows, starting from the top left corner (north-west) and to the right. 
#'
#' @examples
#' data(dem)
#' v = layer_to_vector(dem)
#' v
#'
#' @export

layer_to_vector = function(x, check = TRUE) {

  # Checks
  if(check) {
    x = check_one_attribute(x)
    x = check_2d(x)
  }

  # To matrix
  m = as.vector(x[[1]])

  # Return
  return(m)

}


