#' Extract raster values by lines or polygons
#'
#' Extract raster values by lines or polygons, summarizing for each feature using a function specified by the user. This function is aimed to reproduce (some of) the functionality of \code{raster::extract}.
#'
#' @param x A \code{stars} object
#' @param v An \code{sf} layer that determines values to extract
#' @param fun A function to summarize cell values per feature/band
#' @param progress Display progress bar? The default is \code{TRUE}
#' @param ... Further arguments passed to \code{fun}
#'
#' @return A vector (single-band raster) or \code{matrix} (multi-band raster) with the extracted and summarized values
#' @export
#'
#' @examples
#' 
#' # Polygons
#' pol = st_bbox(landsat)
#' pol = st_as_sfc(pol)
#' set.seed(1)
#' pol = st_sample(pol, 5)
#' pol = st_buffer(pol, 100)
#' pol = c(pol, pol)
#' 
#' # Plot
#' plot(landsat[,,,1,drop=TRUE], reset = FALSE)
#' plot(pol, add = TRUE)
#' 
#' # Single-band raster
#' aggregate(landsat[,,,1,drop=TRUE], pol, mean, na.rm = TRUE)[[1]]  ## Duplicated areas get 'NA'
#' extract2(landsat[,,,1,drop=TRUE], pol, mean, na.rm = TRUE, progress = FALSE)
#' 
#' # Multi-band example
#' extract2(landsat, pol, mean, na.rm = TRUE, progress = FALSE)
#' 
#' # Lines
#' lines = st_cast(pol, "LINESTRING")
#' 
#' # Single-band raster
#' extract2(landsat[,,,1,drop=TRUE], lines, mean, na.rm = TRUE, progress = FALSE)
#' 
#' # Multi-band example
#' extract2(landsat, lines, mean, na.rm = TRUE, progress = FALSE)
#' 

extract2 = function(x, v, fun, progress = TRUE, ...) {

  # Get vector layer 'geometry', if not already
  v = st_geometry(v)

  # Checks
  x = check_2d_3d(x)

  # Progress bar
  if(progress) pb = utils::txtProgressBar(min = 0, max = length(v), initial = 0, style = 3)

  # Extract
  result = list()
  for(i in 1:length(v)) {
    
    # 2D
    if(length(dim(x)) == 2) {
      result[[i]] = fun(x[v[i]][[1]], ...)
    }

    # 3D
    if(length(dim(x)) == 3) {
      result[[i]] = apply(x[v[i]][[1]], 3, fun, ...)
    }

    # Progress
    if(progress) utils::setTxtProgressBar(pb, i)

  }

  # Progress bar
  if(progress) cat("\n")

  # 2D
  if(length(dim(x)) == 2) {
    result = do.call(c, result)
  }
  
  # 3D
  if(length(dim(x)) == 3) {
    result = do.call(rbind, result)
  }

  # Replace 'NaN' with 'NA'
  result[is.nan(result)] = NA

  # Return
  return(result)

}

