#' Apply a focal filter on a raster
#'
#' Applies a focal filter with weighted neighborhood \code{w} on a raster. The weights (\code{w}) can be added to, subtracted from, multiplied by or divided with the raster values (as specified with \code{weight_fun}). The focal cell is then taken as the mean, sum, minimum or maximum of the weighted values (as specified with \code{fun}).  Input and output are rasters of class \code{stars}, single-band (i.e., only `"x"` and `"y"` dimensions), with one attribute.
#'
#' @param x A raster (class \code{stars}) with one attribute and two dimensions: \code{x} and \code{y}, i.e., a single-band raster.
#' @param w Weights matrix defining the neighborhood size around the focal cell, as well as the weights. For example, \code{matrix(1,3,3)} implies a neighborhood of size 3*3 with equal weights of 1 for all cells. The matrix must be square, with an odd number of rows and columns.
#' @param fun A function to aggregate the resulting values for each neighborhood. Possible values are: \code{"mean"}, \code{"sum"}, \code{"min"}, \code{"max"}. The default is \code{"mean"}, i.e., the resulting values per neighborhood are \emph{averaged} before being assigned to the new focal cell value.
#' @param weight_fun An operator which is applied on each pair of values comprising the cell value and the respective weight value, as in \code{raster_value-weight}. Possible values are: \code{"+"}, \code{"-"}, \code{"*"}, \code{"/"}. The default is \code{"*"}, i.e., each cell value is \emph{multiplied} by the respective weight.
#' @param na.rm Should \code{NA} values in the neighborhood be removed from the calculation? Default is \code{FALSE}.
#' @param mask If \code{TRUE}, pixels with \code{NA} in the input are set to \code{NA} in the output as well, i.e., the output is "masked" using the input (default is \code{FALSE}).
#' @param na_flag Value used to mark \code{NA} values in C code. This should be set to a value which is guaranteed to be absent from the input raster \code{x} (default is \code{-9999}).
#' @return The filtered \code{stars} raster.
#'
#' @note The raster is "padded" with \code{(nrow(w)-1)/2} more rows and columns of \code{NA} values on all sides, so that the neighborhood of the outermost rows and columns is still a complete neighborhood. Those rows and columns are removed from the final result before returning it. This means, for instance, that the outermost rows and columns in the result will be \code{NA} when using \code{na.rm=FALSE}.
#'
#' @references The function interface was inspired by function \code{raster::focal}. The C code for this function is a modified and expanded version of the C function named \code{applyKernel} included with R package \code{spatialfil}.
#'
#' @examples
#' # Small example
#' data(dem)
#' dem_mean3 = focal2(dem, matrix(1, 3, 3), "mean")
#' r = c(dem, round(dem_mean3, 1), along = 3)
#' r = st_set_dimensions(r, 3, values = c("input", "mean (k=3)"))
#' plot(r, text_values = TRUE, breaks = "equal", col = terrain.colors(10))
#' \donttest{
#' # Larger example
#' data(carmel)
#' carmel_mean15 = focal2(carmel, matrix(1, 15, 15), "mean")
#' r = c(carmel, carmel_mean15, along = 3)
#' r = st_set_dimensions(r, 3, values = c("input", "mean (k=15)"))
#' plot(r, breaks = "equal", col = terrain.colors(10))
#' }
#'
#' @export

focal2 = function(x, w, fun = "mean", weight_fun = "*", na.rm = FALSE, mask = FALSE, na_flag = -9999) {

  # Checks
  x = check_one_attribute(x)
  x = check_2d(x)
  stopifnot(is(w, "matrix"))
  if(any(is.na(w))) { stop("weight matrix 'w' includes 'NA's") }
  if(!nrow(w) == ncol(w)) { stop("weight matrix is not rectangular") }
  stopifnot(is.character(fun))
  stopifnot(fun %in% c("mean", "sum", "min", "max"))
  stopifnot(weight_fun %in% c("+", "-", "*", "/"))

  # Make template
  template = x

  # Number of extra lines
  steps = (nrow(w) - 1) / 2

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

  # Encode 'fun' and 'weight_fun' to integer
  if(fun == "mean") fun = 1
  if(fun == "sum") fun = 2
  if(fun == "min") fun = 3
  if(fun == "max") fun = 4
  if(weight_fun == "+") weight_fun = 1
  if(weight_fun == "-") weight_fun = 2
  if(weight_fun == "*") weight_fun = 3
  if(weight_fun == "/") weight_fun = 4

  # Apply filter
  result = .C(
    "focal2_c",
    as.double(input_vector2),
    as.integer(nrows),
    as.integer(ncols),
    as.double(t(w)),
    as.integer(steps),
    as.integer(kindex),
    as.integer(na.rm),
    as.double(na_flag),
    as.integer(fun),
    as.integer(weight_fun),
    as.double(output_vector2)
  )
  output_vector = result[[length(result)]]

  # Back to 'stars'
  if(mask) output_vector[is.na(input_vector)] = NA
  output_vector[output_vector == na_flag] = NA
  output = matrix(output_vector, nrow(input), ncol(input), byrow = TRUE)
  output = matrix_trim(output, n = steps)
  output = t(output)
  template[[1]] = output

  # Return
  return(template)

}






