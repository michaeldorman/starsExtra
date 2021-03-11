#' Calculate topographic slope from a DEM
#'
#' Calculates topographic slope given a Digital Elevation Model (DEM) raster. Input and output are rasters of class \code{stars}, single-band (i.e., only `"x"` and `"y"` dimensions), with one attribute.
#'
#' @param x A raster (class \code{stars}) with two dimensions: \code{x} and \code{y}, i.e., a single-band raster, representing a DEM.
#' @param na_flag Value used to mark \code{NA} values in C code. This should be set to a value which is guaranteed to be absent from the input raster \code{x} (default is \code{-9999}).
#' @return A \code{stars} raster with topographic slope, i.e., the azimuth where the terrain is tilted towards, in decimal degrees (0-360) clockwise from north.
#'
#' @note Slope calculation results in \code{NA} when at least one of the cell neighbors is \code{NA}, including the outermost rows and columns. Given that the focal window size in slope calculation is 3*3, this means that the outermost one row and one column are given an slope value of \code{NA}.
#'
#' @references The topographic slope algorithm is based on the \emph{How slope works} article in the ArcGIS documentation:
#'
#' \url{https://desktop.arcgis.com/en/arcmap/10.3/tools/spatial-analyst-toolbox/how-slope-works.htm}
#'
#' @examples
#' # Small example
#' data(dem)
#' dem_slope = slope(dem)
#' plot(
#'   dem, text_values = TRUE, breaks = "equal", 
#'   col = hcl.colors(11, "Spectral"), main = "input (elevation)"
#' )
#' \donttest{
#' plot(
#'   dem_slope, text_values = TRUE, breaks = "equal", 
#'   col = hcl.colors(11, "Spectral"), main = "output (slope)"
#' )
#' # Larger example
#' data(carmel)
#' carmel_slope = slope(carmel)
#' plot(
#'   carmel, breaks = "equal", 
#'   col = hcl.colors(11, "Spectral"), main = "input (elevation)"
#' )
#' plot(
#'   carmel_slope, breaks = "equal", 
#'   col = hcl.colors(11, "Spectral"), main = "output (slope)"
#' )
#' }
#'
#' @export

slope = function(x, na_flag = -9999) {

  # Checks
  if(inherits(x, "stars_proxy")) stop("'x' must be 'stars', not 'stars_proxy'")
  x = check_one_attribute(x)
  x = check_2d(x)
  stopifnot(is.numeric(na_flag))
  stopifnot(length(na_flag) == 1)

  # Make template
  template = x

  # Number of extra lines
  steps = 1

  # To matrix
  input = layer_to_matrix(template, check = FALSE)
  input = matrix_extend(input, n = steps)

  # Matrix dimensions
  nrows = nrow(input)
  ncols = ncol(input)

  # Index matrix for the kernel
  kindex = NULL
  for(n in -steps:steps)    # Index for columns
    for(m in -steps:steps)  # Index for rows
      kindex = c(kindex, n*ncols + m)

  # To vector
  input_vector = as.vector(t(input))

  # Replace 'NA' with 'na_flag'
  input_vector2 = input_vector
  input_vector2[is.na(input_vector2)] = na_flag
  output_vector2 = rep(na_flag, length(input_vector2))

  # Cellsize
  cellsize_x = abs(st_dimensions(x)[[1]][["delta"]])
  cellsize_y = abs(st_dimensions(x)[[2]][["delta"]])

  # Apply filter
  result = .C(
    "slope_c",
    as.double(input_vector2),
    as.integer(nrows),
    as.integer(ncols),
    as.integer(kindex),
    as.double(na_flag),
    as.double(cellsize_x),
    as.double(cellsize_y),
    as.double(output_vector2)
  )
  output_vector = result[[length(result)]]

  # Back to 'stars'
  output_vector[output_vector == na_flag] = NA
  output = matrix(output_vector, nrow(input), ncol(input), byrow = TRUE)
  output = matrix_trim(output, n = steps)
  output = t(output)
  template[[1]] = output

  # Set name and units
  names(template) = "slope"
  template[[1]] = units::set_units(template[[1]], "degree")


  # Return
  return(template)

}

