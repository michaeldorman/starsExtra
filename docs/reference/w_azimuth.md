# Create matrix with azimuths to center

Creates a `matrix` with directions (i.e., azimuth) to central cell, of
specified size `k`. The matrix can be used as weight matrix when
calculating the convergence index (see Examples).

## Usage

``` r
w_azimuth(k)
```

## Arguments

- k:

  Neighborhood size around focal cell. Must be an odd number. For
  example, `k=3` implies a 3\*3 neighborhood.

## Value

A `matrix` where each cell value is the azimuth from that cell towards
the matrix center.

## Examples

``` r
m = w_azimuth(3)
m
#>      [,1] [,2] [,3]
#> [1,]  135  180  225
#> [2,]   90    0  270
#> [3,]   45    0  315
m = w_azimuth(5)
m
#>           [,1]      [,2] [,3]     [,4]     [,5]
#> [1,] 135.00000 153.43495  180 206.5650 225.0000
#> [2,] 116.56505 135.00000  180 225.0000 243.4350
#> [3,]  90.00000  90.00000    0 270.0000 270.0000
#> [4,]  63.43495  45.00000    0 315.0000 296.5651
#> [5,]  45.00000  26.56505    0 333.4349 315.0000
```
