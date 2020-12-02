#' Mode
#'
#' Find the mode (i.e., most common value) in a numeric vector. In case of ties, the first encountered value is returned.
#' 
#' @param x A \code{numeric} or \code{logical} vector
#' @param na_flag Value used to mark \code{NA} values in C code. This should be set to a value which is guaranteed to be absent from the input vector \code{x} (default is \code{-9999}).
#' 
#' @return The mode, \code{numeric} vector of length 1
#'
#' @examples
#' x = c(3, 2, 5, 5, 3, 10, 2, 5)
#' mode_value(x)
#' 
#' @export

mode_value = function(x, na_flag = -9999) {

  # Checks
  stopifnot(is.numeric(x) | is.logical(x))
  stopifnot(is.numeric(na_flag))
  stopifnot(length(na_flag) == 1)

  # Replace 'NA' with 'na_flag'
  x[is.na(x)] = na_flag

  # Find mode
  result = .C(
    "mode_c",
    as.double(x),
    as.integer(length(x)),
    as.double(na_flag),
    as.double(na_flag)
  )
  result = result[[length(result)]]

  # Replace 'na_flag' with 'NA'
  if(result == na_flag) result = NA

  # Return
  return(result)

}

