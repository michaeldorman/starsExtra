% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/matrix_get_neighbors.R
\name{matrix_get_neighbors}
\alias{matrix_get_neighbors}
\title{Get neighboring cell values for given matrix cell}
\usage{
matrix_get_neighbors(m, pos, k = 3)
}
\arguments{
\item{m}{A \code{matrix}.}

\item{pos}{The focal cell position, a \code{numeric} vector of length two of the form \code{c(row, column)}.}

\item{k}{Neighborhood size around the focal cell. For example, \code{k=3} implies a neighborhood of size 3*3. Must be an odd positive integer.}
}
\value{
A vector with cell values, ordered by rows, starting from the top left corner of the neighborhood and to the right. When neighborhood extends beyond matrix bounds, only the "existing" values are returned.
}
\description{
Get the values of a \code{k}*\code{k} neighborhood, as vector and by row, given a \code{matrix}, \code{k}, and focal cell position (row and column).
}
\examples{
m = matrix(1:12, nrow = 3, ncol = 4)
m
matrix_get_neighbors(m, pos = c(2, 2), k = 3)
matrix_get_neighbors(m, pos = c(2, 2), k = 5)
matrix_get_neighbors(m, pos = c(2, 2), k = 7)  # Same result
}
