# Convert `matrix` to `stars`

Converts `matrix` to a single-band `stars` raster, conserving the matrix
orientation where rows become the y-axis and columns become the y-axis.
The bottom-left corner of the axis is set to `(0,0)` coordinate, so that
x and y coordinates are positive across the raster extent.

## Usage

``` r
matrix_to_stars(m, res = 1)
```

## Arguments

- m:

  A `matrix`

- res:

  The cell size, default is `1`

## Value

A `stars` raster

## Examples

``` r
data(volcano)
r = matrix_to_stars(volcano, res = 10)
plot(r)

```
