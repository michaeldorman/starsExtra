#' Get neighboring cell values for given matrix cell
#'
#' Get the values of a \code{k}*\code{k} neighborhood, as vector and by row, given a \code{matrix}, \code{k}, and focal cell position (row and column).
#'
#' @param m A \code{matrix}.
#' @param pos The focal cell position, a \code{numeric} vector of length two of the form \code{c(row, column)}.
#' @param k Neighborhood size around the focal cell. For example, \code{k=3} implies a neighborhood of size 3*3. Must be an odd positive integer.
#'
#' @return A vector with cell values, ordered by rows, starting from the top left corner of the neighborhood and to the right. When neighborhood extends beyond matrix bounds, only the "existing" values are returned.
#' @export
#'
#' @examples
#' m = matrix(1:12, nrow = 3, ncol = 4)
#' m
#' matrix_get_neighbors(m, pos = c(2, 2), k = 3)
#' matrix_get_neighbors(m, pos = c(2, 2), k = 5)
#' matrix_get_neighbors(m, pos = c(2, 2), k = 7)  # Same result

matrix_get_neighbors = function(m, pos, k = 3) {
  check_odd_k(k)
  steps = (k - 1) / 2
  i = (pos[1]-steps):(pos[1]+steps)
  j = (pos[2]-steps):(pos[2]+steps)
  i = i[i >= 1 & i <= nrow(m)]
  j = j[j >= 1 & j <= ncol(m)]
  as.vector(t(m[i, j]))
}

