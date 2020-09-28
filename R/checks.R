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

# Normalize to get 2D raster (with just 1st layer if input is 3D)
check_2d = function(x) {
  d = length(dim(x))
  if(!d %in% 2:3) stop("Only objects with 2-3 dimensions are supported")
  xy_dim = attr(st_dimensions(x), "raster")$dimensions
  all_dim = names(dim(x))
  if(d == 3) {
    x = x[, , 1, drop = TRUE]
    warning("Only first layer used!")
    non_xy_dim = setdiff(all_dim, xy_dim)
    x = aperm(x, match(c(xy_dim, non_xy_dim), all_dim))
    x = st_set_dimensions(x, names = c("x", "y", non_xy_dim))
    return(x)
  }
  if(d == 2) {
    x = aperm(x, match(xy_dim, all_dim))
    x = st_set_dimensions(x, names = c("x", "y"))
    return(x)
  }
}

# Normalize to get 3D raster
check_3d = function(x) {
  d = length(dim(x))
  if(d != 3) stop("Only objects with 3 dimensions are supported")
  xy_dim = attr(st_dimensions(x), "raster")$dimensions
  all_dim = names(dim(x))
  non_xy_dim = setdiff(all_dim, xy_dim)
  x = aperm(x, match(c(xy_dim, non_xy_dim), all_dim))
  x = st_set_dimensions(x, names = c("x", "y", non_xy_dim))
  return(x)
}

# Normalize to get 2D or 3D raster
check_2d_3d = function(x) {
  d = length(dim(x))
  if(!d %in% 2:3) stop("Only objects with 2-3 dimensions are supported")
  if(d == 2) return(check_2d(x))
  if(d == 3) return(check_3d(x))
}