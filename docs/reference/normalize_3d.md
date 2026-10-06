# Normalize a 3D 'stars' object

Check, and possibly correct, that the input `stars` object:

- Has exactly one attribute.

- Has exactly three dimensions.

- The first two dimensions are spatial, named `x` and `y` (in that
  order).

## Usage

``` r
normalize_3d(x)
```

## Arguments

- x:

  A `stars` object

## Value

A new `stars` object

## Examples

``` r
# Small example
data(landsat)
normalize_3d(landsat)
#> stars object with 3 dimensions and 1 attribute
#> attribute(s):
#>       Min. 1st Qu. Median      Mean 3rd Qu.   Max. NA's
#> refl     0  0.0567 0.0936 0.1060648  0.1462 0.6735 7989
#> dimension(s):
#>      from  to  offset delta                refsys point              values x/y
#> x       1 258  681615    30 WGS 84 / UTM zone 36N FALSE                NULL [x]
#> y       1 241 3635805   -30 WGS 84 / UTM zone 36N FALSE                NULL [y]
#> band    1   3      NA    NA                    NA    NA red  , green, blue     
```
