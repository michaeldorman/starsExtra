expect_equal(mode_value(c(NA,NA,1,2,2,20,20,20)), 20)
expect_equal(mode_value(c(NA,NA,1,2,2,20,20)), 2)
expect_equal(mode_value(c(NA,NA,NA)), NA)
expect_equal(mode_value(c(-1,NA,-1,2)), -1)
