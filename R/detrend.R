#' Detrend a Digital Elevation Model
#'
#' Detrends a Digital Elevation Model (DEM) raster, by subtracting a trend surface. The trend is computed using \code{mgcv::gam} or \code{mgcv::bam} (when \code{parallel>1}) with formula \code{z ~ s(x, y)}.
#'
#' @param x A two-dimensional \code{stars} object representing the DEM
#' @param parallel Number of parallel processes. With \code{parallel=1} uses ordinary, non-parallel processing.
#'
#' @return A two-dimensional \code{stars} object, with two attributes:\itemize{
#' \item{\code{resid} - the detrended result, i.e., "residual"}
#' \item{\code{trend} - the estimated "trend" which was subtracted from the actual elevation to obtain \code{resid}}
#'}
#'
#' @export
#'
#' @examples
#' # Small example
#' data(dem)
#' dem1 = detrend(dem)
#' dem1 = st_redimension(dem1)
#' dem1 = st_set_dimensions(dem1, 3, values = c("resid", "trend"))
#' plot(round(dem1), text_values = TRUE, col = terrain.colors(11))
#' \donttest{
#' # Larger example 1
#' data(carmel)
#' carmel1 = detrend(carmel, parallel = 2)
#' carmel1 = st_redimension(carmel1)
#' carmel1 = st_set_dimensions(carmel1, 3, values = c("resid", "trend"))
#' plot(carmel1, col = terrain.colors(11))
#'
#' # Larger example 2
#' data(golan)
#' golan1 = detrend(golan, parallel = 2)
#' golan1 = st_redimension(golan1)
#' golan1 = st_set_dimensions(golan1, 3, values = c("resid", "trend"))
#' plot(golan1, col = terrain.colors(11))
#' }

detrend = function(x, parallel = 1) {

  # Checks
  x = check_one_attribute(x)
  x = check_2d(x)
  names(x) = "z"

  # To 'data.frame'
  dat = as.data.frame(x)
  dat = dat[stats::complete.cases(dat), ]

  # Fit model
  if(parallel > 1) {
    cl = parallel::makeCluster(parallel)
    fit = mgcv::bam(formula = z ~ s(x, y), data = dat, cluster = cl)
    dat$pred = stats::predict(fit, dat, cluster = cl)
    parallel::stopCluster(cl)
  } else {
    fit = mgcv::gam(formula = z ~ s(x, y), data = dat)
    dat$pred = stats::predict(fit, dat)
  }

  # Rasterize "residuals" and "trend"
  dat$resid = dat$z - dat$pred
  trend = st_as_sf(dat[, c("x", "y", "pred")], coords = c("x", "y"))
  trend = stars::st_rasterize(trend, x)
  resid = st_as_sf(dat[, c("x", "y", "resid")], coords = c("x", "y"))
  resid = stars::st_rasterize(resid, x)

  # Combine and rearrange
  result = c(resid, trend, along = 3)
  result = split(result, 3)
  names(result) = c("resid", "trend")

  # Return
  return(result)

}

