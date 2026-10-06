# Small Digital Elevation Model

A `stars` object representing a small 13\*11 Digital Elevation Model
(DEM), at 90m resolution

## Usage

``` r
dem
```

## Format

A `stars` object with 1 attribute:

- elevation:

  Elevation above sea level, in meters

## Examples

``` r
plot(dem, text_values = TRUE, breaks = "equal", col = terrain.colors(11))
```
