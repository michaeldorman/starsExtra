#' Apply a focal filter on a raster
#'
#' Applies a focal filter with neighborhood size \code{k}*\code{k} on a raster (class \code{stars}).
#'
#' @param	x	A raster (class \code{stars}) with two dimensions: \code{x} and \code{y}, i.e., a single-band raster
#' @param k Neighborhood size around the focal cell. For example, \code{k=3} implies a neighborhood of size 3*3. Must be an odd positive integer.
#' @param fun A function to be applied on each 3x3 neighborhood. The function needs to accepts a vector of length 9 and return a vector of length 1
#' @param mask If \code{TRUE}, pixels with \code{NA} in the input are set to \code{NA} in the output as well, i.e., the output is "masked" with the input (default \code{FALSE})
#' @param ... Further arguments passed to \code{fun}
#' @return The filtered \code{stars} raster
#'
#' @note The raster is "padded" with one more row/column of \code{NA} values on all sides, so that the neigborhood of the outermost rows and columns is still a complete 3x3 neighborhood. Those rows and columns are removed from the filtered result before returning it.
#'
#' @examples
#' # Small example
#' data(dem)
#' dem1 = focal2(dem, 3, mean, na.rm = TRUE)
#' dem2 = focal2(dem, 3, min, na.rm = TRUE)
#' dem3 = focal2(dem, 3, max, na.rm = TRUE)
#' r = c(dem, round(dem1, 1), dem2, dem3, along = 3)
#' r = st_set_dimensions(r, 3, values = c("input", "mean", "min", "max"))
#' plot(r, text_values = TRUE, breaks = "equal", col = terrain.colors(10))
#'
#' \dontrun{
#' # Larger example
#' data(carmel)
#' carmel1 = focal2(carmel, 3, mean, na.rm = TRUE)
#' carmel2 = focal2(carmel, 9, mean, na.rm = TRUE)
#' carmel3 = focal2(carmel, 15, mean, na.rm = TRUE)
#' r = c(carmel, carmel1, carmel2, carmel3, along = 3)
#' r = st_set_dimensions(r, 3, values = c("input", "k=3", "k=5", "k=7"))
#' plot(r, breaks = "equal", col = terrain.colors(100))
#' }
#'
#' @export

# Apply focal filter
focal2 = function(x, k = 3, fun, mask = FALSE, ...) {

  # Number of steps in each direction beyond focal cell
  steps = (k - 1) / 2

  # Make template
  template = x

  # To matrix
  input = layer_values_matrix(template)  # Checks take place here
  input = matrix_extend(input, n = steps)

  # Apply filter
  output = matrix(NA, nrow = nrow(input), ncol = ncol(input))
  for(i in (1+steps):(nrow(input)-steps)) {
    for(j in (1+steps):(ncol(input)-steps)) {
      v = matrix_get_neighbors(m = input, pos = c(i, j), k = k)
      output[i, j] = fun(v, ...)
    }
  }

  # Back to raster
  output = matrix_trim(output, n = steps)
  if(mask) output[is.na(input)] = NA
  template[[1]] = t(output)

  # Return
  return(template)

}






