#' Calculate topographic aspect from a DEM
#'
#' Calculates topographic aspect given a Digital Elevation Model (DEM) raster. Input and output are rasters of class \code{stars}, single-band (i.e., only `"x"` and `"y"` dimensions), with one attribute.
#'
#' @param x A raster (class \code{stars}) with two dimensions: \code{x} and \code{y}, i.e., a single-band raster, representing a DEM.
#' @param na_flag Value used to mark \code{NA} values in C code. This should be set to a value which is guaranteed to be absent from the input raster \code{x} (default is \code{-9999}).
#' @return A \code{stars} raster with topographic slope, i.e., the azimuth where the terrain is tilted towards, in decimal degrees (0-360) clockwise from north. Aspect of flat terrain, i.e., where all values in the neighborhood are equal, is set to \code{-1}. Returned raster values are of class \code{units} (decimal degrees).
#'
#' @note Aspect calculation results in \code{NA} when at least one of the cell neighbors is \code{NA}, including the outermost rows and columns. Given that the focal window size in aspect calculation is 3*3, this means that the outermost one row and one column are given an aspect value of \code{NA}.
#'
#' @references The topographic aspect algorithm is based on the \emph{How aspect works} article in the ArcGIS documentation:
#'
#' \url{https://desktop.arcgis.com/en/arcmap/10.3/tools/spatial-analyst-toolbox/how-aspect-works.htm}
#'
#' @examples
#' # Small example
#' data(dem)
#' dem_aspect = aspect(dem)
#' plot(
#'   dem, text_values = TRUE, breaks = "equal", 
#'   col = hcl.colors(11, "Spectral"), main = "input (elevation)"
#' )
#' plot(
#'   dem_aspect, text_values = TRUE, breaks = "equal", 
#'   col = hcl.colors(11, "Spectral"), main = "output (aspect)"
#' )
#' \donttest{
#' # Larger example
#' data(carmel)
#' carmel_aspect = aspect(carmel)
#' plot(
#'   carmel, breaks = "equal", 
#'   col = hcl.colors(11, "Spectral"), main = "input (elevation)"
#' )
#' plot(
#'   carmel_aspect, breaks = "equal", 
#'   col = hcl.colors(11, "Spectral"), main = "output (aspect)"
#' )
#' }
#'
#' @export

# Apply focal filter
aspect = function(x, na_flag = -9999) {

  # Checks
  x = check_one_attribute(x)
  x = check_2d(x)

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

  # Apply filter
  result = .C(
    "aspect_c",
    as.double(input_vector2),
    as.integer(nrows),
    as.integer(ncols),
    as.integer(kindex),
    as.double(na_flag),
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
  names(template) = "aspect"
  template[[1]] = units::set_units(template[[1]], "degree")


  # Return
  return(template)

}






