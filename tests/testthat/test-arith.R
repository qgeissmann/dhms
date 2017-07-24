context("arith")

test_that("arithmetics work", {
  #addition/subtraction
  expect_equal(dhms(hours = 1) + 1, dhms(3600 +1))
  expect_equal(dhms(days = 1) - 1, dhms(24*3600 -1))
  #division/multiplication
  expect_equal(dhms(days = 1) *2 , dhms(24*3600 *2))
  expect_equal(dhms(days = 1) /2 , dhms(12*3600 ))
  # one day and one hour, modulo one day is one hour
  expect_equal(dhms(hours = 1, days =1) %%  (24 * 3600), dhms(3600 ))

})

test_that("arithmetics works with implicit string coercion", {
  #addition/subtraction
  expect_true(dhms(hours = 1) + 1 == "01:00:01")
  expect_true(dhms(days = 1) - 1 == "23:59:59")
  #division/multiplication
  expect_true(dhms(days = 1) *2 == "2d 00:00:00" )
  expect_true(dhms(days = 1) /2 == "12:00:00")
  # one day and one hour, modulo one day is one hour
  expect_true(dhms(hours = 1, days =1) %%  (24 * 3600) == "01:00:00")

})
