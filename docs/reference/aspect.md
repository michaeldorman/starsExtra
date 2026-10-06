# Calculate topographic aspect from a DEM

Calculates topographic aspect given a Digital Elevation Model (DEM)
raster. Input and output are rasters of class `stars`, single-band
(i.e., only \`"x"\` and \`"y"\` dimensions), with one attribute.

## Usage

``` r
aspect(x, na_flag = -9999)
```

## Arguments

- x:

  A raster (class `stars`) with two dimensions: `x` and `y`, i.e., a
  single-band raster, representing a DEM.

- na_flag:

  Value used to mark `NA` values in C code. This should be set to a
  value which is guaranteed to be absent from the input raster `x`
  (default is `-9999`).

## Value

A `stars` raster with topographic slope, i.e., the azimuth where the
terrain is tilted towards, in decimal degrees (0-360) clockwise from
north. Aspect of flat terrain, i.e., where all values in the
neighborhood are equal, is set to `-1`. Returned raster values are of
class `units` (decimal degrees).

## Note

Aspect calculation results in `NA` when at least one of the cell
neighbors is `NA`, including the outermost rows and columns. Given that
the focal window size in aspect calculation is 3\*3, this means that the
outermost one row and one column are given an aspect value of `NA`.

The raster must be in projected CRS, and units of x/y resolution are
assumed to be the same as units of elevation (typically *meters*).

## References

The topographic aspect algorithm is based on the *How aspect works*
article in the ArcGIS documentation:

<https://desktop.arcgis.com/en/arcmap/10.3/tools/spatial-analyst-toolbox/how-aspect-works.htm>

## Examples

``` r
# Small example
data(dem)
dem_aspect = aspect(dem)
plot(
  dem, text_values = TRUE, breaks = "equal", 
  col = hcl.colors(11, "Spectral"), main = "input (elevation)"
)

plot(
  dem_aspect, text_values = TRUE, breaks = "equal", 
  col = hcl.colors(11, "Spectral"), main = "output (aspect)"
)

# \donttest{
# Larger example
data(carmel)
carmel_aspect = aspect(carmel)
plot(
  carmel, breaks = "equal", 
  col = hcl.colors(11, "Spectral"), main = "input (elevation)"
)

plot(
  carmel_aspect, breaks = "equal", 
  col = hcl.colors(11, "Spectral"), main = "output (aspect)"
)

# }
```
