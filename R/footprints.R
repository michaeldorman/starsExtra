#' Footprints
#'
#' Calculates a polygon layer with the footprints of raster images.
#' 
#' @param x A \code{character} vector of raster file paths
#' 
#' @return An \code{sf} layer with the footprints (i.e., bounding box polygons) of the rasters
#'
#' @examples
#' 
#' # Create sample files
#' file1 = tempfile(fileext = ".tif")
#' file2 = tempfile(fileext = ".tif")
#' file3 = tempfile(fileext = ".tif")
#' r1 = landsat[,1:100, 1:100,]
#' r2 = landsat[,101:200, 101:200,]
#' r3 = landsat[,21:40, 51:120,]
#' write_stars(r1, file1)
#' write_stars(r2, file2)
#' write_stars(r3, file3)
#' 
#' # Calculate footprints
#' files = c(file1, file2, file3)
#' pol = footprints(files)
#' pol
#' 
#' @export

footprints = function(x) {

  # Read
  r = lapply(x, read_stars)

  # Calculate footprints
  r = lapply(r, st_bbox)
  r = lapply(r, st_as_sfc)
  r = do.call(c, r)

  # To 'sf'
  dat = st_sf(geometry = r, data.frame(path = x))

  # Return
  return(dat)

}

