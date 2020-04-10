#' Extend matrix
#'
#' Adds \code{n} rows and columns with \code{NA} values on all sides of a \code{matrix}.
#'
#' @param m A \code{matrix}
#' @param n By how many rows/columns to extend the matrix on each side?
#' @param fill Fill value (default is \code{NA})
#'
#' @return An extended \code{matrix}
#' @export
#'
#' @examples
#' m = matrix(1:6, nrow = 2, ncol = 3)
#' m
#' matrix_extend(m, 1)
#' matrix_extend(m, 2)
#' matrix_extend(m, 3)

matrix_extend = function(m, n = 1, fill = NA) {
  m2 = matrix(fill, nrow = nrow(m)+n*2, ncol = ncol(m)+n*2)
  m2[(1+n):(nrow(m2)-n), (1+n):(ncol(m2)-n)] = m
  m2
}

