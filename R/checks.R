# Check that 'k' is odd and positive
check_odd_k = function(k) {
  if(k <= 0) stop("k must be positive")
  if(k %% 2 != 1) stop("k must be odd")
}

# Check that raster 'x' has one attribute, if not: subset first 
check_one_attribute = function(x) {
  if(length(x) > 1) warning("Only first attribute used")
  return(x[1])
}

# Check that raster 'x' has one layer, if not: subset first 
check_one_layer = function(x) {
  d = length(dim(x))
  if(d > 3) stop("Objects with >3 dimensions are not supported")
  if(d == 3) {
    warning("Only first layer used!")
    return(x[, , 1])
  }
  if(d == 2) return(x)
}

# Check that raster 'x' has one spatial attributes as 1 and 2, if not: rearrange 
check_spatial_dimensions = function(x) {
  d = attr(st_dimensions(x), "raster")$dimensions
  if(length(d) != 2) stop("Rasters with number of spatial dimensions other than two are not supported")
  x = aperm(x, d)
  return(x)
}


