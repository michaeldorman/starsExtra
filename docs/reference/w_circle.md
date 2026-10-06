# Create matrix with circular weight pattern

Creates a `matrix` with where a circular pattern is filled with values
of `1` and the remaining cells are filled with values of `0` (see
Examples).

## Usage

``` r
w_circle(k)
```

## Arguments

- k:

  Neighborhood size around focal cell. Must be an odd number. For
  example, `k=3` implies a 3\*3 neighborhood.

## Value

A `matrix` with a circular pattern.

## Examples

``` r
m = w_circle(3)
image(m, asp = 1, axes = FALSE)

m = w_circle(5)
image(m, asp = 1, axes = FALSE)

m = w_circle(15)
image(m, asp = 1, axes = FALSE)

m = w_circle(35)
image(m, asp = 1, axes = FALSE)

m = w_circle(91)
image(m, asp = 1, axes = FALSE)

m = w_circle(151)
image(m, asp = 1, axes = FALSE)

```
