# Normalize a 2D 'stars' object

Check, and possibly correct, that the input `stars` object:

- Has exactly one attribute.

- Has exactly two dimensions.

- The dimensions are spatial, named `x` and `y` (in that order).

## Usage

``` r
normalize_2d(x)
```

## Arguments

- x:

  A `stars` object

## Value

A new `stars` object

## Examples

``` r
# Small example
data(dem)
normalize_2d(dem)
#> stars object with 2 dimensions and 1 attribute
#> attribute(s):
#>            Min. 1st Qu. Median     Mean 3rd Qu. Max.
#> elevation    -2    12.5    112 102.9371     178  211
#> dimension(s):
#>   from to  offset delta                       refsys x/y
#> x    1 13  689164    90 +proj=utm +zone=36 +ellps... [x]
#> y    1 11 3629999   -90 +proj=utm +zone=36 +ellps... [y]
```
