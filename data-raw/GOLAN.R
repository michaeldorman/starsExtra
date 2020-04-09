## code to prepare `golan` dataset

library(stars)
library(nngeo)

r = read_stars("~/Sync/Layers/Israel_SRTM_1arc/SRTM_1arc_UTM.tif")
aoi = st_read('{
  "type": "FeatureCollection",
  "features": [
    {
      "type": "Feature",
      "properties": {},
      "geometry": {
        "type": "Polygon",
        "coordinates": [
          [
            [
              35.57304382324219,
              32.79304687845155
            ],
            [
              35.80375671386719,
              32.79304687845155
            ],
            [
              35.80375671386719,
              33.01096671579776
            ],
            [
              35.57304382324219,
              33.01096671579776
            ],
            [
              35.57304382324219,
              32.79304687845155
            ]
          ]
        ]
      }
    }
  ]
}')
aoi = st_transform(aoi, st_crs(r))
aoi = st_bbox(aoi)
aoi = st_as_sfc(aoi)
r = r[aoi]
r = st_normalize(r)
r = r[, 1:740, 1:824]
r = round(r, 1)

# w = water
# w = w[w$name == "Sea of Galilee", ]
# w = st_geometry(w)
# w = st_transform(w, st_crs(r))
# level = aggregate(r, w, min)

golan = r
usethis::use_data(golan)
