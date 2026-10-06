# Get `stars` layer values as vector

Extracts the values of a single layer in a `stars` object to a vector.
Cell values are ordered from top-left corner to the right.

## Usage

``` r
layer_to_vector(x, check = TRUE)
```

## Arguments

- x:

  A raster (class `stars`) with two dimensions: `x` and `y`, i.e., a
  single-band raster.

- check:

  Whether to check (and fix if necessary) that input has one attribute,
  one layer and x-y as dimensions 1-2 (default is `TRUE`).

## Value

A vector with cell values, ordered by rows, starting from the top left
corner (north-west) and to the right.

## Examples

``` r
data(dem)
v = layer_to_vector(dem)
v
#>   [1] 171 140 115  64  44  31  16   6   4   2   0   1   2 189 167 140  86  60
#>  [19]  43  27  14   4   5   0  -2   5 204 185 166 108  86  62  41  20   5   5
#>  [37]   4   5   6 208 199 183 141 115  91  64  34  15   7   5   7   6 208 207
#>  [55] 203 167 139 112  93  64  39   8   3   4   5 209 210 211 207 162 140 117
#>  [73]  91  69  27   2   1   5 207 206 208 211 185 167 141 112  87  63   6   1
#>  [91]   3 200 198 197 203 204 188 161 139 113  88  11   1   2 191 183 184 188
#> [109] 198 196 181 158 135 109  69  10   4 173 166 168 174 191 191 186 173 163
#> [127] 120  95  26   5 155 152 153 155 175 177 179 183 166 121 109  32  15
```
