#' Create matrix with azimuths to center
#'
#' Creates a \code{matrix} with directions (i.e., azimuth) to central cell, of specified size \code{k}. The matrix can be used as weight matrix when calculating the convergence index (see Examples).
#'
#' @param k Neighborhood size around focal cell. Must be an odd number. For example, \code{k=3} implies a 3*3 neighborhood.
#' @return A \code{matrix} where each cell value is the azimuth from that cell towards the matrix center.
#'
#' @examples
#' m = w_azimuth(3)
#' m
#' m = w_azimuth(5)
#' m
#'
#' @export

w_azimuth = function(k) {

  # Checks
  check_odd_k(k)

  # Create matrix
  m = matrix(1, ncol = k, nrow = k)

  # Set focal cell to zero
  m[(nrow(m)+1)/2, (ncol(m)+1)/2] = 0

  # Calculate azimuths
  s = matrix_to_stars(m)
  names(s) = "value"
  u = st_as_sf(s, as_points = TRUE)
  ctr = u[u$value == 0, ]
  pnt = u[u$value == 1, ]
  pnt$az = nngeo::st_azimuth(pnt, ctr)
  s = st_rasterize(pnt[, "az"], s)
  m = layer_to_matrix(s)

  # Return
  return(m)

}

