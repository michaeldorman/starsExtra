check_one_attribute = function(x) {
  if(length(x) > 1) warning("Only first attribute used.")
  return(x[1])
}
