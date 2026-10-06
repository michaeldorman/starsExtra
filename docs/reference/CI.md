# Calculate the Convergence Index (CI) from a slope raster

Calculates the Convergence Index (CI) given a topographic slope raster.
Input and output are rasters of class `stars`, single-band (i.e., only
\`"x"\` and \`"y"\` dimensions), with one attribute.

## Usage

``` r
CI(x, k, na.rm = FALSE, na_flag = -9999)
```

## Arguments

- x:

  A raster (class `stars`) with two dimensions: `x` and `y`, i.e., a
  single-band raster, representing aspect in decimal degrees clockwise
  from north, possibly including `-1` to specify flat terrain, such as
  returned by function [`aspect`](aspect.md).

- k:

  k Neighborhood size around focal cell. Must be an odd number. For
  example, `k=3` implies a 3\*3 neighborhood.

- na.rm:

  Should `NA` values be ignored when calculating CI? Default is `FALSE`,
  i.e., when at least one aspect value in the neighborhood is `NA` the
  CI is also set to `NA`.

- na_flag:

  Value used to mark `NA` values in C code. This should be set to a
  value which is guaranteed to be absent from the input raster `x`
  (default is `-9999`).

## Value

A `stars` raster with CI values.

## Note

The raster is "padded" with `(k-1)/2` more rows and columns of `NA`
values on all sides, so that the neighborhood of the outermost rows and
columns is still a complete neighborhood. Those rows and columns are
removed from the final result before returning it. Aspect values of
`-1`, specifying flat terrain, are assigned with a CI value of `0`
regardless of their neighboring values.

## References

The Convergence Index algorithm is described in:

Thommeret, N., Bailly, J. S., & Puech, C. (2010). Extraction of thalweg
networks from DTMs: application to badlands.

## Examples

``` r
# Small example
data(dem)
dem_asp = aspect(dem)
dem_ci = CI(dem_asp, k = 3)
r = c(dem, round(dem_ci, 1), along = 3)
r = st_set_dimensions(r, 3, values = c("input (aspect)", "output (CI, k=3)"))
plot(r, text_values = TRUE, breaks = "equal", col = terrain.colors(10), mfrow = c(1, 2))

# \donttest{
# Larger example
data(golan)
golan_asp = aspect(golan)
golan_ci = CI(golan_asp, k = 25)
plot(golan_asp, breaks = "equal", col = hcl.colors(11, "Spectral"), main = "input (aspect)")

plot(golan_ci, breaks = "equal", col = hcl.colors(11, "Spectral"), main = "output (CI, k=25)")

# }
```
