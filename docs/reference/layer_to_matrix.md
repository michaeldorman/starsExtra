# Get `stars` layer values as matrix

Extracts the values of a single layer in a `stars` object to a `matrix`.

## Usage

``` r
layer_to_matrix(x, check = TRUE)
```

## Arguments

- x:

  A `stars` raster with one attribute and two dimensions, `x` and `y`,
  i.e., a single-band raster.

- check:

  Whether to check (and fix if necessary) that input has one attribute,
  one layer and x-y as dimensions 1-2 (default is `TRUE`).

## Value

A `matrix` with the layer values, having the same orientation as the
raster (i.e., rows represent the y-axis and columns represent the
x-axis).

## Examples

``` r
data(dem)
m = layer_to_matrix(dem)
m
#>       [,1] [,2] [,3] [,4] [,5] [,6] [,7] [,8] [,9] [,10] [,11] [,12] [,13]
#>  [1,]  171  140  115   64   44   31   16    6    4     2     0     1     2
#>  [2,]  189  167  140   86   60   43   27   14    4     5     0    -2     5
#>  [3,]  204  185  166  108   86   62   41   20    5     5     4     5     6
#>  [4,]  208  199  183  141  115   91   64   34   15     7     5     7     6
#>  [5,]  208  207  203  167  139  112   93   64   39     8     3     4     5
#>  [6,]  209  210  211  207  162  140  117   91   69    27     2     1     5
#>  [7,]  207  206  208  211  185  167  141  112   87    63     6     1     3
#>  [8,]  200  198  197  203  204  188  161  139  113    88    11     1     2
#>  [9,]  191  183  184  188  198  196  181  158  135   109    69    10     4
#> [10,]  173  166  168  174  191  191  186  173  163   120    95    26     5
#> [11,]  155  152  153  155  175  177  179  183  166   121   109    32    15
```
