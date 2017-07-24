context("parse")

test_that("as.dhms.character", {
  expect_equal(as.dhms("12:34:56"), dhms(56, 34, 12))
  # day component
  expect_equal(as.dhms("1d12:34:56"), dhms(56, 34, 12,1))
  # day component with spaces
  expect_equal(as.dhms("1d   12:34:56"), dhms(56, 34, 12,1))

  # >24h
  expect_equal(as.dhms("25:00:00"), dhms(days=1,hours=1))

  # day only
  expect_equal(as.dhms("1d"), dhms(days=1))

  # day fraction not supported
  #expect_equal(as.dhms("0.5d"), dhms(hours=12))

  # negative hours
  expect_equal(as.dhms("-12:34:56"), -dhms(56, 34, 12))

  # negative days
  expect_equal(as.dhms("-1d 12:34:56"), -dhms(56, 34, 12,1))

  # negative with space
  expect_equal(as.dhms("- 1d 12:34:56"), -dhms(56, 34, 12,1))

  # split seconds
  expect_equal(as.dhms("12:34:56.789"), dhms(56.789, 34, 12))
  # NAs handling
  #expect_equal(as.dhms(NA), dhms(NA))
  expect_equal(
               as.dhms(parse_dhms(c("12:34:56", NA))),
               as.dhms(c(dhms(56, 34, 12),(NA)))
               )
  expect_equal(
    as.dhms(parse_dhms(c("12:34:56", "NA"))),
    as.dhms(c(dhms(56, 34, 12),(NA)))
  )

  #============= missformating we wnt errors, not NAs
  #inconsistent time
  expect_error(as.dhms("1d   12:34:72"))
  #missformatings of the day part
  expect_error(as.dhms("a1d   12:34:12"))
  expect_error(as.dhms("1D 12:34:12"))
  expect_error(as.dhms("zd   12:34:12"))

  #
  expect_error(as.dhms("0.5d   12:34"))

  # missformating of the hour part
  expect_error(as.dhms("1d 12:69:12"))
  # three digits for minutes
  expect_error(as.dhms("1d 12:619:12"))

  # not a digit for seconds
  expect_error(parse_dhms("1d 12:10:ss"))
})



