check_one_layer = function(x) {
  d = length(dim(x))
  if(d > 3) stop("Objects with >3 dimensions are not supported.")
  if(d == 3) {
    warning("Only first layer used!")
    return(x[,,1])
  }
  if(d == 2) return(x)
}
