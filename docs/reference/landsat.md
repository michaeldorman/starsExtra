# RGB image of Mount Carmel

A `stars` object representing an RGB image of part of Mount Carmel, at
30m resolution. The data source is Landsat-8 Surface Reflectance
product.

## Usage

``` r
landsat
```

## Format

A `stars` object with 1 attribute:

- refl:

  Reflectance, numeric value between 0 and 1

## Examples

``` r
plot(landsat, breaks = "equal")
```
