#' Calculate the Convergence Index (CI) from a slope raster
#'
#' Calculates the Convergence Index (CI) given a topographic slope raster. Input and output are rasters of class \code{stars}, single-band (i.e., only `"x"` and `"y"` dimensions), with one attribute.
#'
#' @param x A raster (class \code{stars}) with two dimensions: \code{x} and \code{y}, i.e., a single-band raster, representing aspect in decimal degrees clockwise from north, possibly including \code{-1} to specify flat terrain, such as returned by function \code{\link{aspect}}.
#' @param k k Neighborhood size around focal cell. Must be an odd number. For example, \code{k=3} implies a 3*3 neighborhood.
#' @param na.rm Should \code{NA} values be ignored when calculating CI? Default is \code{FALSE}, i.e., when at least one aspect value in the neighborhood is \code{NA} the CI is also set to \code{NA}.
#' @param na_flag Value used to mark \code{NA} values in C code. This should be set to a value which is guaranteed to be absent from the input raster \code{x} (default is \code{-9999}).
#' @return A \code{stars} raster with CI values.
#'
#' @note The raster is "padded" with \code{(k-1)/2} more rows and columns of \code{NA} values on all sides, so that the neighborhood of the outermost rows and columns is still a complete neighborhood. Those rows and columns are removed from the final result before returning it.
#' Aspect values of \code{-1}, specifying flat terrain, are assigned with a CI value of \code{0} regardless of their neighboring values.
#'
#' @references The Convergence Index algorithm is described in:
#'
#' Thommeret, N., Bailly, J. S., & Puech, C. (2010). Extraction of thalweg networks from DTMs: application to badlands.
#'
#' @examples
#' # Small example
#' data(dem)
#' dem_asp = aspect(dem)
#' dem_ci = CI(dem_asp, k = 3)
#' r = c(dem, round(dem_ci, 1), along = 3)
#' r = st_set_dimensions(r, 3, values = c("input", "CI (k=3)"))
#' plot(r, text_values = TRUE, breaks = "equal", col = terrain.colors(10))
#' \donttest{
#' # Larger example
#' data(golan)
#' golan_asp = aspect(golan)
#' golan_ci = CI(golan_asp, k = 25)
#' plot(golan_ci)
#' }
#'
#' @export

# Apply focal filter
CI = function(x, k, na.rm = FALSE, na_flag = -9999) {

  # Check odd 'k'
  check_odd_k(k)

  # Set units to 'NA'
  if(class(x[[1]]) == "units") x[[1]] = units::drop_units(x[[1]])

  # Check range 0-360
  if(any(!is.na(x[[1]]) & ((x[[1]] < 0 & x[[1]] != -1) | x[[1]] > 360))) stop("Raster values must be in [0-360]")

  # Make template
  template = x

  # Number of extra lines
  steps = (k - 1) / 2

  # To matrix
  input = layer_to_matrix(template)  # Checks take place here
  input = matrix_extend(input, n = steps)

  # Matrix dimensions
  nrows = nrow(input)
  ncols = ncol(input)

  # Calculate weights
  w = w_azimuth(k)

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

  # Remove central cell from 'w' and 'kindex'
  w = t(w)[-((length(w)+1)/2)]
  kindex = kindex[-((length(kindex)+1)/2)]

  # Apply filter
  result = .C(
    "CI_c",
    as.double(input_vector2),
    as.integer(nrows),
    as.integer(ncols),
    as.double(w),
    as.integer(steps),
    as.integer(kindex),
    as.integer(na.rm),
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

  # Set name
  names(template) = "CI"

  # Return
  return(template)

}






