## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  dpi = 50
)
options(preferRaster = TRUE)

## ----installation1, eval=FALSE------------------------------------------------
#  install.packages("starsExtra")

## ----installation2, eval=FALSE------------------------------------------------
#  install.packages("remotes")
#  remotes::install_github("michaeldorman/starsExtra")

## -----------------------------------------------------------------------------
library(starsExtra)

## -----------------------------------------------------------------------------
data(dem)
dem_mean3 = focal2(dem, matrix(1, 3, 3), "mean", na.rm = TRUE)
dem_sum3 = focal2(dem, matrix(1, 3, 3), "sum", na.rm = TRUE)
dem_min3 = focal2(dem, matrix(1, 3, 3), "min", na.rm = TRUE)
dem_max3 = focal2(dem, matrix(1, 3, 3), "max", na.rm = TRUE)

## ---- fig.width=6, fig.height=4, out.width="45%", fig.show="hold"-------------
plot(dem, main = "input", text_values = TRUE, breaks = "equal", col = terrain.colors(10))
plot(dem, col = rep(NA, 3), key.pos = NULL, main = "")
plot(round(dem_mean3, 1), main = "mean (k=3)", text_values = TRUE, breaks = "equal", col = terrain.colors(10))
plot(dem_sum3, main = "sum (k=3)", text_values = TRUE, breaks = "equal", col = terrain.colors(10))
plot(dem_min3, main = "min (k=3)", text_values = TRUE, breaks = "equal", col = terrain.colors(10))
plot(dem_max3, main = "max (k=3)", text_values = TRUE, breaks = "equal", col = terrain.colors(10))

## -----------------------------------------------------------------------------
data(carmel)
carmel_mean9 = focal2(carmel, matrix(1, 9, 9), "mean", na.rm = TRUE, mask = TRUE)
carmel_mean27 = focal2(carmel, matrix(1, 27, 27), "mean", na.rm = TRUE, mask = TRUE)

## ---- fig.width=4, fig.height=6, out.width="30%", fig.show="hold"-------------
plot(carmel, main = "input", breaks = "equal", col = terrain.colors(10))
plot(carmel_mean9, main = "mean (k=9)", breaks = "equal", col = terrain.colors(10))
plot(carmel_mean27, main = "mean (k=27)", breaks = "equal", col = terrain.colors(10))

