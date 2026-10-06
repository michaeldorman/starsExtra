# Convert RGB to greyscale

Convert a 3-band RGB raster to 1-band greyscale raster. Based on
`wvtool::rgb2gray`.

## Usage

``` r
rgb_to_greyscale(x, rgb = 1:3, coefs = c(0.3, 0.59, 0.11))
```

## Arguments

- x:

  A three-dimensional `stars` object with RGB values

- rgb:

  Indices of RGB bands, default is `c(1, 2, 3)`

- coefs:

  RGB weights, default is `c(0.30,0.59,0.11)`

## Value

A two-dimensional `stars` object greyscale values

## Examples

``` r
data(landsat)
plot(landsat, rgb = 1:3)

landsat_grey = rgb_to_greyscale(landsat)
plot(landsat_grey, breaks = "equal")

```
