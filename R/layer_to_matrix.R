#' Get \code{stars} layer values as matrix
#'
#' Extracts the values of a single layer in a \code{stars} object to a \code{matrix}.
#'
#' @param	r	A \code{stars} raster with one attribute and two dimensions, \code{x} and \code{y}, i.e., a single-band raster.
#' @return A \code{matrix} with the layer values, having the same orientation as the raster (i.e., rows represent the y-axis and columns represent the x-axis).
#'
#' @examples
#' data(dem)
#' m = layer_to_matrix(dem)
#' m
#'
#' @export

layer_to_matrix = function(r) {

  # Checks
  r = check_one_attribute(r)
  r = check_spatial_dimensions(r)
  r = check_one_layer(r)

  # To matrix
  m = t(r[[1]])

  # Return
  return(m)

}
