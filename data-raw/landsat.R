## code to prepare `landsat` dataset

library(stars)

# Landsat-8 Surface Reflectance image
path = "~/Downloads/LC081740372020060501T1-SC20200614090527"

# Read
r = list.files(path = path, full.names = TRUE, pattern = "band4") %>% read_stars
g = list.files(path = path, full.names = TRUE, pattern = "band3") %>% read_stars
b = list.files(path = path, full.names = TRUE, pattern = "band2") %>% read_stars
r = c(r, g, b, along = 3)
r = st_set_dimensions(r, names = c("x", "y", "band"))
r = st_set_dimensions(r, "band", values = c("red", "green", "blue"))
names(r) = "refl"

# Crop
aoi = c(xmin = 34.940729, ymin = 32.780199, xmax = 35.021582, 
ymax = 32.843987)
aoi = st_bbox(aoi)
aoi = st_as_sfc(aoi)
st_crs(aoi) = 4326
aoi = st_transform(aoi, st_crs(r))
r = r[aoi]

# Scale
r[[1]] = r[[1]] * 0.0001
r[[1]][r[[1]] < 0] = 0

# Replace non-ascii characters
crs = st_crs(r)
crs$wkt = crs$wkt %>% gsub("°", "", .)
st_crs(r) = crs

# Normalize
r = st_normalize(r)

# Write
landsat = r
usethis::use_data(landsat, overwrite = TRUE)
