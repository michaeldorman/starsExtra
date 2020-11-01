#' Small Digital Elevation Model
#'
#' A \code{stars} object representing a small 13*11 Digital Elevation Model (DEM), at 90m resolution
#'
#' @format A \code{stars} object with 1 attribute:
#' \describe{
#'   \item{elevation}{Elevation above sea level, in meters}
#' }
#' @examples
#' plot(dem, text_values = TRUE, breaks = "equal", col = terrain.colors(11))


"dem"

#' Digital Elevation Model of Mount Carmel
#'
#' A \code{stars} object representing a Digital Elevation Model (DEM) Digital Elevation Model of Mount Carmel, at 90m resolution
#'
#' @format A \code{stars} object with 1 attribute:
#' \describe{
#'   \item{elevation}{Elevation above sea level, in meters}
#' }
#' @examples
#' plot(carmel, breaks = "equal", col = terrain.colors(11))

"carmel"

#' Digital Elevation Model of Golan Heights
#'
#' A \code{stars} object representing a Digital Elevation Model (DEM) Digital Elevation Model of part of the Golan Heights and Lake Kinneret, at 90m resolution
#'
#' @format A \code{stars} object with 1 attribute:
#' \describe{
#'   \item{elevation}{Elevation above sea level, in meters}
#' }
#' @examples
#' plot(golan, breaks = "equal", col = terrain.colors(11))

"golan"

#' RGB image of Mount Carmel
#'
#' A \code{stars} object representing an RGB image of part of Mount Carmel, at 30m resolution. The data source is Landsat-8 Surface Reflectance product.
#'
#' @format A \code{stars} object with 1 attribute:
#' \describe{
#'   \item{refl}{Reflectance, numeric value between 0 and 1}
#' }
#' @examples 
#' plot(landsat, breaks = "equal")

"landsat"


