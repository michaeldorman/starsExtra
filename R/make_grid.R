#' Make 'stars' grid from 'sf' layer
#'
#' Create 'stars' raster grid from bounding box of 'sf' vector layer, possibly buffered, with specified resolution.
#'
#' @param x An \code{sf}, \code{sfc} or \code{sfg} object
#' @param res Required grid resolution, in CRS units of \code{x}
#' @param buffer Buffer size around \code{x} (default is \code{0}, i.e., no buffer)
#'
#' @return A \code{stars} raster with the grid, with all cell values equal to \code{1}
#' @export
#'
#' @examples
#' # Sample 'sf' layer
#' x = st_point(c(0,0))
#' y = st_point(c(1,1))
#' x = st_sfc(x, y)
#' x = st_sf(x)
#' 
#' # Make grid
#' r = make_grid(x, res = 0.1, buffer = 0.5)
#' r[[1]][] = rep(1:3, length.out = length(r[[1]]))
#' 
#' # Plot
#' plot(r, axes = TRUE, reset = FALSE)
#' plot(st_geometry(x), add = TRUE, pch = 4, cex = 3, col = "red")

make_grid = function(x, res, buffer = 0) {

  # Checks
  stopifnot(inherits(x, "sfg") | inherits(x, "sfc") | inherits(x, "sf"))
  stopifnot(is.numeric(res))
  stopifnot(length(res) == 1)
  stopifnot(is.numeric(buffer))
  stopifnot(length(buffer) == 1)

  # To 'geometry'
  x = st_geometry(x)

  # Calculate grid
  if(buffer != 0) x = st_buffer(x, buffer)
  x = st_bbox(x)
  x = st_as_sfc(x)
  x = st_as_stars(x, dx = res, dy = res)
  x[[1]][] = 1

  # Return
  return(x)

}

