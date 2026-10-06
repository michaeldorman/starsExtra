# Extend matrix

Adds `n` rows and columns with `NA` values on all sides of a `matrix`.

## Usage

``` r
matrix_extend(m, n = 1, fill = NA)
```

## Arguments

- m:

  A `matrix`

- n:

  By how many rows/columns to extend the matrix on each side?

- fill:

  Fill value (default is `NA`)

## Value

An extended `matrix`

## Examples

``` r
m = matrix(1:6, nrow = 2, ncol = 3)
m
#>      [,1] [,2] [,3]
#> [1,]    1    3    5
#> [2,]    2    4    6
matrix_extend(m, 1)
#>      [,1] [,2] [,3] [,4] [,5]
#> [1,]   NA   NA   NA   NA   NA
#> [2,]   NA    1    3    5   NA
#> [3,]   NA    2    4    6   NA
#> [4,]   NA   NA   NA   NA   NA
matrix_extend(m, 2)
#>      [,1] [,2] [,3] [,4] [,5] [,6] [,7]
#> [1,]   NA   NA   NA   NA   NA   NA   NA
#> [2,]   NA   NA   NA   NA   NA   NA   NA
#> [3,]   NA   NA    1    3    5   NA   NA
#> [4,]   NA   NA    2    4    6   NA   NA
#> [5,]   NA   NA   NA   NA   NA   NA   NA
#> [6,]   NA   NA   NA   NA   NA   NA   NA
matrix_extend(m, 3)
#>      [,1] [,2] [,3] [,4] [,5] [,6] [,7] [,8] [,9]
#> [1,]   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> [2,]   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> [3,]   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> [4,]   NA   NA   NA    1    3    5   NA   NA   NA
#> [5,]   NA   NA   NA    2    4    6   NA   NA   NA
#> [6,]   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> [7,]   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> [8,]   NA   NA   NA   NA   NA   NA   NA   NA   NA
```
