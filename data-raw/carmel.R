## code to prepare `carmel` dataset

library(stars)

dem1 = read_stars("~/r/book/data/srtm_43_06.tif")
dem2 = read_stars("~/r/book/data/srtm_44_06.tif")
dem = st_mosaic(dem1, dem2)
names(dem) = "elevation"
dem = dem[, 5687:6287, 2348:2948]
dem = st_normalize(dem)
dem = st_warp(src = dem, crs = 32636, method = "near", cellsize = 90)

carmel = dem
usethis::use_data(carmel, overwrite=TRUE)

