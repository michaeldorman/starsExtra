#' Apply a focal filter on a raster (R)
#'
#' Applies a focal filter with neighborhood size \code{k}*\code{k} on a raster (class \code{stars}), using R code. This function is relatively slow, provided here mainly for testing purposes or for custom using functions which are not provided by \code{focal2}.
#'
#' @param	x	A raster (class \code{stars}) with two dimensions: \code{x} and \code{y}, i.e., a single-band raster
#' @param w Weights matrix defining the neighborhood size around the focal cell, as well as the weights. For example, \code{matrix(1,3,3)} implies a neighborhood of size 3*3 with equal weights of 1 for all cells. Focal cell values are multiplied by the matrix values before being passed to function \code{fun}. The matrix must be square, i.e., with an odd number of rows and columns. 
#' @param fun A function to be applied on each neighborhood, after it has been multiplied by the matrix. The function needs to accepts a vector (of length equal to \code{length(w)} and return a vector of length \code{1}
#' @param mask If \code{TRUE}, pixels with \code{NA} in the input are set to \code{NA} in the output as well, i.e., the output is "masked" with the input (default \code{FALSE})
#' @param ... Further arguments passed to \code{fun}
#' @return The filtered \code{stars} raster
#'
#' @note The raster is "padded" with one more row/column of \code{NA} values on all sides, so that the neigborhood of the outermost rows and columns is still a complete 3x3 neighborhood. Those rows and columns are removed from the filtered result before returning it.
#'
#' @examples
#' \donttest{
#' # Small example
#' data(dem)
#' dem1 = focal2r(dem, matrix(1,3,3), mean, na.rm = TRUE)
#' dem2 = focal2r(dem, matrix(1,3,3), min, na.rm = TRUE)
#' dem3 = focal2r(dem, matrix(1,3,3), max, na.rm = TRUE)
#' r = c(dem, round(dem1, 1), dem2, dem3, along = 3)
#' r = st_set_dimensions(r, 3, values = c("input", "mean", "min", "max"))
#' plot(r, text_values = TRUE, breaks = "equal", col = terrain.colors(10))
#' # Larger example
#' data(carmel)
#' carmel1 = focal2r(carmel, matrix(1,3,3), mean, na.rm = TRUE, mask = TRUE)
#' carmel2 = focal2r(carmel, matrix(1,9,9), mean, na.rm = TRUE, mask = TRUE)
#' carmel3 = focal2r(carmel, matrix(1,15,15), mean, na.rm = TRUE, mask = TRUE)
#' r = c(carmel, carmel1, carmel2, carmel3, along = 3)
#' r = st_set_dimensions(r, 3, values = c("input", "k=3", "k=9", "k=15"))
#' plot(r, breaks = "equal", col = terrain.colors(100))
#' }
#' 
#' @export

focal2r = function(x, w, fun, mask = FALSE, ...) {

  # Checks
  if(inherits(x, "stars_proxy")) stop("'x' must be 'stars', not 'stars_proxy'")
  x = check_one_attribute(x)
  x = check_2d(x)
  stopifnot(is(w, "matrix"))
  if(any(is.na(w))) stop("weight matrix 'w' includes 'NA's")
  if(!nrow(w) == ncol(w)) stop("weight matrix is not rectangular")

# Matrix size
  k = nrow(w)

  # Extract matrix weights
  w = as.vector(t(w))
  
  # Number of steps in each direction beyond focal cell
  steps = (k - 1) / 2

  # Make template
  template = x

  # To matrix
  input = layer_to_matrix(template)  ## Checks take place here
  input = matrix_extend(input, n = steps)

  # Apply filter
  output = matrix(NA, nrow = nrow(input), ncol = ncol(input))
  for(i in (1+steps):(nrow(input)-steps)) {
    for(j in (1+steps):(ncol(input)-steps)) {
      v = matrix_get_neighbors(m = input, pos = c(i, j), k = k)  ## Get focal values
      v = w * v                                                  ## Multiply by weights
      output[i, j] = fun(v, ...)                                 ## Apply function
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

