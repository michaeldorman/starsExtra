#' Calculate raster of distances to nearest feature
#'
#' Given a \code{stars} raster and an \code{sf} vector layer, returns a new raster with the distances of each cell centroid to the nearest feature in the vector layer.
#'
#' @param x A \code{stars} layer, used as a "grid" for distance calculations
#' @param v An \code{sf}, \code{sfc} or \code{sfg} object
#' @param progress Display progress bar? The default is \code{TRUE}
#'
#' @return A \code{stars} raster with distances to nearest feature
#' @export
#'
#' @examples
#' # Sample 'sf' layer
#' x = st_point(c(0,0))
#' y = st_point(c(1,1))
#' x = st_sfc(x, y)
#' x = st_sf(x)
#' x = st_buffer(x, 0.5)
#' 
#' # Make grid
#' r = make_grid(x, res = 0.1, buffer = 0.5)
#' d = dist_to_nearest(r, x, progress = FALSE)
#' 
#' # Plot
#' plot(d, breaks = "equal", axes = TRUE, reset = FALSE)
#' plot(st_geometry(x), add = TRUE, pch = 4, cex = 3)

dist_to_nearest = function(x, v, progress = TRUE) {

  # Checks
  stopifnot(inherits(v, "sfg") | inherits(v, "sfc") | inherits(v, "sf"))
  stopifnot(inherits(x, "stars"))
  x = check_2d(x)

  # To 'geometry'
  v = st_geometry(v)

  # Calculate distances
  pnt = st_as_sf(x, as_points = TRUE)
  d = nngeo::st_nn(pnt, v, k = 1, returnDist = TRUE, progress = progress)
  d = d$dist
  d = unlist(d)
  pnt$d = d
  pnt = pnt["d"]
  result = st_rasterize(pnt, x)

  # Return
  return(result)

}

