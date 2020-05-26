#' Calculate flow length
#'
#' Calculates flow length for each pixel in a Digital Elevation Model (DEM) raster. Inputs and output are rasters of class \code{stars}, single-band (i.e., only `"x"` and `"y"` dimensions), with one attribute.
#'
#' @param	elev	A numeric \code{stars} raster representing a Digital Elevation Model (DEM).
#' @param	veg	A matching logical \code{stars} raster representing vegetation presence. \code{TRUE} values represent vegetated cells where flow is absorbed (i.e. sinks), \code{FALSE} values represent cells where flow is unobstructed.
#' @return	A numeric \code{stars} raster where each cell value is flow length, in resolution units.
#'
#' @references
#' The algorithm is described in:
#'
#' Mayor, A. G., Bautista, S., Small, E. E., Dixon, M., & Bellot, J. (2008). Measurement of the connectivity of runoff source areas as determined by vegetation pattern and topography: A tool for assessing potential water and soil losses in drylands. Water Resources Research, 44(10).
#'
#' @examples
#' # Example from Fig. 2 in Mayor et al. 2008
#'
#' elev = rbind(
#'   c(8, 8, 8, 8, 9, 8, 9),
#'   c(7, 7, 7, 7, 9, 7, 7),
#'   c(6, 6, 6, 6, 6, 5, 7),
#'   c(4, 5, 5, 3, 5, 4, 7),
#'   c(4, 5, 4, 5, 4, 6, 5),
#'   c(3, 3, 3, 3, 2, 3, 3),
#'   c(2, 2, 2, 3, 4, 1, 3)
#' )
#' veg = rbind(
#'   c(TRUE,  TRUE,  TRUE,  TRUE,  FALSE, FALSE, TRUE),
#'   c(TRUE,  TRUE,  TRUE,  TRUE,  TRUE,  FALSE, FALSE),
#'   c(FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE),
#'   c(FALSE, TRUE,  FALSE, FALSE, FALSE, FALSE, TRUE),
#'   c(TRUE,  TRUE,  FALSE, FALSE, FALSE, FALSE, FALSE),
#'   c(TRUE,  TRUE,  TRUE,  FALSE, FALSE, FALSE, FALSE),
#'   c(FALSE, TRUE,  TRUE,  FALSE, FALSE, TRUE,  TRUE)
#' )
#' elev = matrix_to_stars(elev)
#' veg = matrix_to_stars(veg)
#'
#' # Calculate flow length
#' fl = flowlength(elev, veg)
#'
#' # Plot
#' plot(round(elev, 1), text_values = TRUE, breaks = "equal", col = terrain.colors(6))
#' plot(veg*1, text_values = TRUE, breaks = "equal", col = rev(terrain.colors(2)))
#' plot(round(fl, 1), text_values = TRUE, breaks = "equal", col = terrain.colors(6))
#' \donttest{
#' # Larger example
#' data(carmel)
#' elev = carmel
#' elev[is.na(elev)] = 0
#' veg = elev > 100
#' fl = flowlength(elev, veg)
#' plot(fl)
#' }
#' @export

flowlength = function(elev, veg) {

  # Checks
  elev = check_one_attribute(elev)
  elev = check_spatial_dimensions(elev)
  elev = check_one_layer(elev)
  veg = check_one_attribute(veg)
  veg = check_spatial_dimensions(veg)
  veg = check_one_layer(veg)
  stopifnot(all.equal(st_dimensions(elev), st_dimensions(veg)))

  # Check and set resolution
  res_x = abs(st_dimensions(elev)[["x"]][["delta"]])
  res_y = abs(st_dimensions(elev)[["y"]][["delta"]])
  stopifnot(res_x == res_y)
  res = st_dimensions(elev)[["x"]][["delta"]]

  # Set template
  template = elev

  # To matrix
  elev = layer_to_matrix(elev)
  veg = layer_to_matrix(veg)

  # Add "padding"
  elev = matrix_extend(elev, n = 1, fill = Inf)
  veg = matrix_extend(veg, n = 1, fill = TRUE)

  # Progress bar
  pb = utils::txtProgressBar(min = 2, max = nrow(elev)-1, style = 3)

  # Calculate 'flowlength' matrix
  result = matrix(NA, nrow = nrow(elev), ncol = ncol(elev))
  for(i in 2:(nrow(elev)-1)) {
    for(j in 2:(ncol(elev)-1)) {
      result[i, j] = flowlength1(elev, veg, c(i, j), res)
      utils::setTxtProgressBar(pb, i)
    }
  }

  # Remove "padding"
  result = matrix_trim(result, n = 1)

  # Insert into template
  template[[1]] = t(result)

  # Return
  cat("\n")
  return(template)

}

# Function to calculate 'flowlength' for one cell, *non-border* cells only
flowlength1 = function(elev, veg, pos, res) {

  # Check
  stopifnot(all(dim(elev) == dim(veg)))

  # Distances
  dists = c(
    sqrt(2), 1, sqrt(2),
    1,          1,
    sqrt(2), 1, sqrt(2)
  )
  dists = dists * res

  # Flow length counter
  fl = 0

  # Visited cells
  visited = matrix(FALSE, nrow = nrow(elev), ncol = ncol(elev))
  visited[c(1, nrow(visited)), ] = TRUE
  visited[, c(1, ncol(visited))] = TRUE

  while(TRUE) {

    # Break if visited or vegetated
    if(visited[pos[1], pos[2]]) break
    if(veg[pos[1], pos[2]]) break

    # Mark current cell
    visited[pos[1], pos[2]] = TRUE

    # Find neighbors (3*3 excluding focal cell)
    nElev = matrix_get_neighbors(elev, pos, k = 3)[-5]
    nVeg = matrix_get_neighbors(veg, pos, k = 3)[-5]

    # Find drops
    drops = elev[pos[1], pos[2]] - nElev
    dropsNorm = drops / dists
    dropsNorm[dropsNorm < 0] = NA

    # Break if nowhere to go
    if(all(is.na(dropsNorm))) break

    # Pick maximal & non-vegetated drop
    dropsNorm[dropsNorm != max(dropsNorm, na.rm = TRUE)] = NA

    # Places to go to
    goto = length(dropsNorm[!is.na(dropsNorm)])

    # Randomly choose one in case of ties
    if(goto > 1) {
      toDelete = sample(which(!is.na(dropsNorm)), goto - 1)
      dropsNorm[toDelete] = NA
    }

    # Change position to next cell
    i = which(!is.na(dropsNorm))
    if(i == 1) {pos[1] = pos[1]-1; pos[2] = pos[2]-1}
    if(i == 2) {pos[1] = pos[1]-1}
    if(i == 3) {pos[1] = pos[1]-1; pos[2] = pos[2]+1}
    if(i == 4) {pos[2] = pos[2]-1}
    if(i == 5) {pos[2] = pos[2]+1}
    if(i == 6) {pos[1] = pos[1]+1; pos[2] = pos[2]-1}
    if(i == 7) {pos[1] = pos[1]+1}
    if(i == 8) {pos[1] = pos[1]+1; pos[2] = pos[2]+1}

    # Increment length
    fl = fl + sqrt(drops[i]^2 + dists[i]^2)

  }

  return(fl)

}
