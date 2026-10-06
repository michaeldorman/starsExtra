# Remove empty outer rows and columns

Removes complete outer rows and columns which have `NA` values.

## Usage

``` r
trim2(x)
```

## Arguments

- x:

  A two-dimensional `stars` object

## Value

A new `stars` object with empty outer rows and columns removed

## Examples

``` r
# Single-band example
data(dem)
dem[[1]][1,] = NA
dem1 = trim2(dem)

# Multi-band example
data(landsat)
landsat[[1]][1:100,,] = NA
landsat1 = trim2(landsat)
```
