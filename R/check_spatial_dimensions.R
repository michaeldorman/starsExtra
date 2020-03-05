check_spatial_dimensions = function(x) {
  d = attr(st_dimensions(x), "raster")$dimensions
  if(length(d) != 2) stop("Rasters with number of spatial dimensions other than two are not supported.")
  x = aperm(x, d)
  return(x)
}
