#' Convert RGB to greyscale
#'
#' Convert a 3-band RGB raster to 1-band greyscale raster. Based on \code{wvtool::rgb2gray}.
#'
#' @param x A three-dimensional \code{stars} object with RGB values
#' @param rgb Indices of RGB bands, default is \code{c(1, 2, 3)}
#' @param coefs RGB weights, default is \code{c(0.30,0.59,0.11)}
#'
#' @return A two-dimensional \code{stars} object greyscale values
#' @export
#'
#' @examples
#' data(landsat)
#' plot(landsat, rgb = 1:3)
#' landsat_grey = rgb_to_greyscale(landsat)
#' plot(landsat_grey, breaks = "equal")
#' 

rgb_to_greyscale = function(x, rgb = 1:3, coefs = c(0.3, 0.59, 0.11)) {

  # Checks
  x = check_one_attribute(x)
  x = check_3d(x)
  stopifnot(is.numeric(rgb))
  stopifnot(is.numeric(coefs))
  stopifnot(length(rgb) == 3)
  stopifnot(length(coefs) == 3)
  stopifnot(all(rgb %in% 1:3))

  # Reorder RGB bands
  x = x[,,,rgb]

  # Convert to greyscale
  f = function(x) sum(x * coefs)
  x = st_apply(x, 1:2, f)
  names(x) = "greyscale"

  # Return
  return(x)

}

