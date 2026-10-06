# Digital Elevation Model of Mount Carmel

A `stars` object representing a Digital Elevation Model (DEM) Digital
Elevation Model of Mount Carmel, at 90m resolution

## Usage

``` r
carmel
```

## Format

A `stars` object with 1 attribute:

- elevation:

  Elevation above sea level, in meters

## Examples

``` r
plot(carmel, breaks = "equal", col = terrain.colors(11))
```
