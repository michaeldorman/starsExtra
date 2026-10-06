# Digital Elevation Model of Golan Heights

A `stars` object representing a Digital Elevation Model (DEM) Digital
Elevation Model of part of the Golan Heights and Lake Kinneret, at 90m
resolution

## Usage

``` r
golan
```

## Format

A `stars` object with 1 attribute:

- elevation:

  Elevation above sea level, in meters

## Examples

``` r
plot(golan, breaks = "equal", col = terrain.colors(11))
```
