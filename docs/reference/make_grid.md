# Make 'stars' grid from 'sf' layer

Create 'stars' raster grid from bounding box of 'sf' vector layer,
possibly buffered, with specified resolution.

## Usage

``` r
make_grid(x, res, buffer = 0)
```

## Arguments

- x:

  An `sf`, `sfc` or `sfg` object

- res:

  Required grid resolution, in CRS units of `x`

- buffer:

  Buffer size around `x` (default is `0`, i.e., no buffer)

## Value

A `stars` raster with the grid, with all cell values equal to `1`

## Examples

``` r
# Sample 'sf' layer
x = st_point(c(0,0))
y = st_point(c(1,1))
x = st_sfc(x, y)
x = st_sf(x)

# Make grid
r = make_grid(x, res = 0.1, buffer = 0.5)
r[[1]][] = rep(1:3, length.out = length(r[[1]]))

# Plot
plot(r, axes = TRUE, reset = FALSE)
plot(st_geometry(x), add = TRUE, pch = 4, cex = 3, col = "red")
```
