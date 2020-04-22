## code to prepare `dem` dataset

library(stars)

v = c(NA, NA, NA, NA, NA, NA, NA, 3, 5, 7, NA, 
NA, NA, 61, 106, 47, 31, 39, 32, 49, NA, NA, NA, 9, 132, 
254, 233, 253, 199, 179, NA, NA, NA, 4, 11, 146, 340, 383, 
357, 307, NA, 4, 6, 9, 6, 6, 163, 448, 414, 403, 3, 6, 9, 10, 
6, 6, 13, 152, 360, 370, 3, 4, 7, 16, 27, 12, 64, 39, 48, 55)
m = matrix(v, nrow = 10, ncol = 7)
s = st_as_stars(t(m))
s = st_set_dimensions(s, 1, offset = 679624, delta = 2880)
s = st_set_dimensions(s, 2, offset = 3644759, delta = -2880)
s = st_set_dimensions(s, names = c("x", "y"))
s = st_set_crs(s, 32636)
names(s) = "elevation"

dem = s
usethis::use_data(dem)
