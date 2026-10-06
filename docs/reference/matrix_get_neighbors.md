# Get neighboring cell values for given matrix cell

Get the values of a `k`\*`k` neighborhood, as vector and by row, given a
`matrix`, `k`, and focal cell position (row and column).

## Usage

``` r
matrix_get_neighbors(m, pos, k = 3)
```

## Arguments

- m:

  A `matrix`.

- pos:

  The focal cell position, a `numeric` vector of length two of the form
  `c(row, column)`.

- k:

  Neighborhood size around the focal cell. For example, `k=3` implies a
  neighborhood of size 3\*3. Must be an odd positive integer.

## Value

A vector with cell values, ordered by rows, starting from the top left
corner of the neighborhood and to the right. When neighborhood extends
beyond matrix bounds, only the "existing" values are returned.

## Examples

``` r
m = matrix(1:12, nrow = 3, ncol = 4)
m
#>      [,1] [,2] [,3] [,4]
#> [1,]    1    4    7   10
#> [2,]    2    5    8   11
#> [3,]    3    6    9   12
matrix_get_neighbors(m, pos = c(2, 2), k = 3)
#> [1] 1 4 7 2 5 8 3 6 9
matrix_get_neighbors(m, pos = c(2, 2), k = 5)
#>  [1]  1  4  7 10  2  5  8 11  3  6  9 12
matrix_get_neighbors(m, pos = c(2, 2), k = 7)  # Same result
#>  [1]  1  4  7 10  2  5  8 11  3  6  9 12
```
