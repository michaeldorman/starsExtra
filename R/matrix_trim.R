#' Trim matrix
#'
#' Removes \code{n} rows and columns with \code{NA} values on all sides of a \code{matrix}.
#'
#' @param m A \code{matrix}
#' @param n By how many rows/columns to trim the matrix on each side?
#'
#' @return A trimmed \code{matrix}, or \code{NULL} if trimming results in an "empty" matrix.
#' @export
#'
#' @examples
#' m = matrix(1:80, nrow = 8, ncol = 10)
#' m
#' matrix_trim(m, 1)
#' matrix_trim(m, 2)
#' matrix_trim(m, 3)
#' matrix_trim(m, 4)

matrix_trim = function(m, n = 1) {
  if((1+n) >= (nrow(m)-n) | (1+n) >= (nrow(m)-n)) return(NULL)
  m[(1+n):(nrow(m)-n), (1+n):(ncol(m)-n), drop = FALSE]
}


