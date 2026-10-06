# Trim matrix

Removes `n` rows and columns with `NA` values on all sides of a
`matrix`.

## Usage

``` r
matrix_trim(m, n = 1)
```

## Arguments

- m:

  A `matrix`

- n:

  By how many rows/columns to trim the matrix on each side?

## Value

A trimmed `matrix`, or `NULL` if trimming results in an "empty" matrix.

## Examples

``` r
m = matrix(1:80, nrow = 8, ncol = 10)
m
#>      [,1] [,2] [,3] [,4] [,5] [,6] [,7] [,8] [,9] [,10]
#> [1,]    1    9   17   25   33   41   49   57   65    73
#> [2,]    2   10   18   26   34   42   50   58   66    74
#> [3,]    3   11   19   27   35   43   51   59   67    75
#> [4,]    4   12   20   28   36   44   52   60   68    76
#> [5,]    5   13   21   29   37   45   53   61   69    77
#> [6,]    6   14   22   30   38   46   54   62   70    78
#> [7,]    7   15   23   31   39   47   55   63   71    79
#> [8,]    8   16   24   32   40   48   56   64   72    80
matrix_trim(m, 1)
#>      [,1] [,2] [,3] [,4] [,5] [,6] [,7] [,8]
#> [1,]   10   18   26   34   42   50   58   66
#> [2,]   11   19   27   35   43   51   59   67
#> [3,]   12   20   28   36   44   52   60   68
#> [4,]   13   21   29   37   45   53   61   69
#> [5,]   14   22   30   38   46   54   62   70
#> [6,]   15   23   31   39   47   55   63   71
matrix_trim(m, 2)
#>      [,1] [,2] [,3] [,4] [,5] [,6]
#> [1,]   19   27   35   43   51   59
#> [2,]   20   28   36   44   52   60
#> [3,]   21   29   37   45   53   61
#> [4,]   22   30   38   46   54   62
matrix_trim(m, 3)
#>      [,1] [,2] [,3] [,4]
#> [1,]   28   36   44   52
#> [2,]   29   37   45   53
matrix_trim(m, 4)
#> NULL
```
