#' Get \code{stars} layer values as vector
#'
#' Extracts the values of a single layer in a \code{stars} object to a vector. Cell values are ordered from top-left corner to the right.
#'
#' @param	r	A raster (class \code{stars}) with two dimensions: \code{x} and \code{y}, i.e., a single-band raster
#' @return A vector with cell values, ordered by rows, starting from the top left corner (north-west) and to the right. 
#'
#' @examples
#' data(dem)
#' v = layer_to_vector(dem)
#' v
#'
#' @export

layer_to_vector = function(r) {

  # Checks
  r = check_one_attribute(r)
  r = check_spatial_dimensions(r)
  r = check_one_layer(r)

  # To matrix
  m = as.vector(r[[1]])

  # Return
  return(m)

}


