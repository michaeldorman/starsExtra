library(starsExtra)
library(raster)

# Sample polygons
pol = st_bbox(landsat)
pol = st_as_sfc(pol)
set.seed(1)
pol = st_sample(pol, 5)
pol = st_buffer(pol, 100)
pol = c(pol, pol)
pol = st_as_sf(pol)

# Single-band raster
expect_equal(
  extract(as(landsat[,,,1,drop=TRUE], "Raster"), pol, mean, na.rm = TRUE)[, 1],
  extract2(landsat[,,,1,drop=TRUE], pol, mean, na.rm = TRUE)
)

# Multi-band example
expect_equal(
  unname(extract(as(landsat, "Raster"), pol, mean, na.rm = TRUE)),
  extract2(landsat, pol, mean, na.rm = TRUE)
)
