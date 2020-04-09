#' Calculate topographic aspect from a DEM
#'
#' Calculates topographic aspect given a Digital Elevation Model (DEM) raster
#'
#' @param x A raster (class \code{stars}) with two dimensions: \code{x} and \code{y}, i.e., a single-band raster, representing a DEM.
#' @param na_flag Value use to mark \code{NA} values in C code. This should be set to a value which is guaranteed to be absent from the raster (default is \code{-9999}).
#' @return A \code{stars} raster with topographic slope, i.e., the azimuth where the terrain is tilted towards, in decimal degrees (0-360) clockwise from north. Flat terrain, i.e., when all values in the neighborhood are equal, gets the value of \code{-1}.
#'
#' @note Aspect calculation results in \code{NA} when at least one of the cell neighbors is \code{NA}, including the outermost rows and columns.
#'
#' @references The topographic aspect algorithm is based on the \emph{How aspect works} article in the ArcGIS documentation:
#'
#' \url{https://desktop.arcgis.com/en/arcmap/10.3/tools/spatial-analyst-toolbox/how-aspect-works.htm}
#'
#' @examples
#' # Small example
#' data(dem)
#' aspect = aspect(dem)
#' r = c(dem, round(aspect, 1), along = 3)
#' r = st_set_dimensions(r, 3, values = c("input", "aspect"))
#' plot(r, text_values = TRUE, breaks = "equal", col = hcl.colors(11, "Spectral"))
#'
#' \dontrun{
#'
#' # Larger example
#' data(carmel)
#' carmel1 = aspect(carmel)
#' r = c(carmel, round(carmel1, 1), along = 3)
#' r = st_set_dimensions(r, 3, values = c("input", "aspect"))
#' plot(r, breaks = "equal", hcl.colors(11, "Spectral"))
#'
#' }
#'
#' @export

# Apply focal filter
aspect = function(x, na_flag = -9999) {

  # Make template
  template = x

  # Number of extra lines
  steps = 1

  # To matrix
  input = layer_to_matrix(template)  # Checks take place here
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

  # Return
  return(template)

}






