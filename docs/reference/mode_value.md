# Mode

Find the mode (i.e., most common value) in a numeric vector. In case of
ties, the first encountered value is returned.

## Usage

``` r
mode_value(x, na_flag = -9999)
```

## Arguments

- x:

  A `numeric` or `logical` vector

- na_flag:

  Value used to mark `NA` values in C code. This should be set to a
  value which is guaranteed to be absent from the input vector `x`
  (default is `-9999`).

## Value

The mode, `numeric` vector of length 1

## Examples

``` r
x = c(3, 2, 5, 5, 3, 10, 2, 5)
mode_value(x)
#> [1] 5
```
