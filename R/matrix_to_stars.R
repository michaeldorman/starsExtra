#' Convert \code{matrix} to \code{stars}
#'
#' Converts \code{matrix} to \code{stars}, conserving the matrix orientation where rows become the y-axis and columns become the y-axis.
#'
#' @param	m	A \code{matrix}
#' @param	res	The cell size, default is \code{1}
#' @return A \code{stars} raster
#'
#' @examples
#' data(volcano)
#' r = matrix_to_stars(volcano)
#' plot(r)
#'
#' @export

matrix_to_stars = function(m, res = 1) {

  # To stars
  r = st_as_stars(t(m))
  r = st_set_dimensions(r, names = c("x", "y"))
  r = st_set_dimensions(r, "x", offset = 0, delta = res)
  r = st_set_dimensions(r, "y", offset = 0, delta = -res)

  # Return
  return(r)

}


