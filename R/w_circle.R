#' Create matrix with circular weight pattern
#'
#' Creates a \code{matrix} with where a circular pattern is filled with values of \code{1} and the remaining cells are filled with values of \code{0} (see Examples).
#'
#' @param k Neighborhood size around focal cell. Must be an odd number. For example, \code{k=3} implies a 3*3 neighborhood.
#' @return A \code{matrix} with a circular pattern.
#'
#' @examples
#' m = w_circle(3)
#' image(m, asp = 1, axes = FALSE)
#' m = w_circle(5)
#' image(m, asp = 1, axes = FALSE)
#' m = w_circle(15)
#' image(m, asp = 1, axes = FALSE)
#' m = w_circle(35)
#' image(m, asp = 1, axes = FALSE)
#' m = w_circle(91)
#' image(m, asp = 1, axes = FALSE)
#' m = w_circle(151)
#' image(m, asp = 1, axes = FALSE)
#'
#' @export

w_circle = function(k) {

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
  radius = unname(diff(st_bbox(s)[c(1, 3)]) / 2)
  circle = st_buffer(ctr, radius + 0.001)
  in_circle = st_intersects(u, circle, sparse = FALSE)[, 1]
  u$value[in_circle] = 1
  u$value[!in_circle] = 0
  s = st_rasterize(u[, "value"], s)
  m = layer_to_matrix(s)

  # Return
  return(m)

}

