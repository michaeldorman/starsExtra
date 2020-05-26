# Apply a focal filter on a raster (R)
#
# Applies a focal filter with neighborhood size \code{k}*\code{k} on a raster (class \code{stars}), using R code.
#
# @param	x	A raster (class \code{stars}) with two dimensions: \code{x} and \code{y}, i.e., a single-band raster
# @param k Neighborhood size around focal cell. Must be an odd number. For example, \code{k=3} implies a 3*3 neighborhood.
# @param fun A function to be applied on each neighborhood. The function needs to accepts a vector (of length equal to \code{length(w)} and return a vector of length \code{1}
# @param mask If \code{TRUE}, pixels with \code{NA} in the input are set to \code{NA} in the output as well, i.e., the output is "masked" with the input (default \code{FALSE})
# @param ... Further arguments passed to \code{fun}
# @return The filtered \code{stars} raster
#
# @note The raster is "padded" with one more row/column of \code{NA} values on all sides, so that the neigborhood of the outermost rows and columns is still a complete 3x3 neighborhood. Those rows and columns are removed from the filtered result before returning it.
#
# @examples
# \donttest{
# # Small example
# data(dem)
# dem1 = focal2r(dem, 3, mean, na.rm = TRUE)
# dem2 = focal2r(dem, 3, min, na.rm = TRUE)
# dem3 = focal2r(dem, 3, max, na.rm = TRUE)
# r = c(dem, round(dem1, 1), dem2, dem3, along = 3)
# r = st_set_dimensions(r, 3, values = c("input", "mean", "min", "max"))
# plot(r, text_values = TRUE, breaks = "equal", col = terrain.colors(10))
# # Larger example
# data(carmel)
# carmel1 = focal2r(carmel, 3, mean, na.rm = TRUE, mask = TRUE)
# carmel2 = focal2r(carmel, 9, mean, na.rm = TRUE, mask = TRUE)
# carmel3 = focal2r(carmel, 15, mean, na.rm = TRUE, mask = TRUE)
# r = c(carmel, carmel1, carmel2, carmel3, along = 3)
# r = st_set_dimensions(r, 3, values = c("input", "k=3", "k=9", "k=15"))
# plot(r, breaks = "equal", col = terrain.colors(100))
# }

focal2r = function(x, k = 3, fun, mask = FALSE, ...) {

  # Checks
  check_odd_k(k)

  # Number of steps in each direction beyond focal cell
  steps = (k - 1) / 2

  # Make template
  template = x

  # To matrix
  input = layer_to_matrix(template)  # Checks take place here
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
  if(mask) output[is.na(input)] = NA
  output = matrix_trim(output, n = steps)
  output = t(output)
  output[is.nan(output)] = NA
  template[[1]] = output

  # Return
  return(template)

}






