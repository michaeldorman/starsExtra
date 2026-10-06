# Footprints

Calculates a polygon layer with the footprints of raster images.

## Usage

``` r
footprints(x)
```

## Arguments

- x:

  A `character` vector of raster file paths

## Value

An `sf` layer with the footprints (i.e., bounding box polygons) of the
rasters

## Examples

``` r
# Create sample files
file1 = tempfile(fileext = ".tif")
file2 = tempfile(fileext = ".tif")
file3 = tempfile(fileext = ".tif")
r1 = landsat[,1:100, 1:100,]
r2 = landsat[,101:200, 101:200,]
r3 = landsat[,21:40, 51:120,]
write_stars(r1, file1)
write_stars(r2, file2)
write_stars(r3, file3)

# Calculate footprints
files = c(file1, file2, file3)
pol = footprints(files)
pol
#> Simple feature collection with 3 features and 1 field
#> Geometry type: POLYGON
#> Dimension:     XY
#> Bounding box:  xmin: 681615 ymin: 3629805 xmax: 687615 ymax: 3635805
#> Projected CRS: WGS 84 / UTM zone 36N
#>                                    path                       geometry
#> 1 /tmp/RtmpcfnZiE/file326e359492bed.tif POLYGON ((681615 3632805, 6...
#> 2 /tmp/RtmpcfnZiE/file326e34cdd8628.tif POLYGON ((684615 3629805, 6...
#> 3  /tmp/RtmpcfnZiE/file326e3f206a26.tif POLYGON ((682215 3632205, 6...
```
