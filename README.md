
dhms
====

<!-- [![Travis-CI Build Status](https://travis-ci.org/tidyverse/hms.svg?branch=master)](https://travis-ci.org/tidyverse/hms) [![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/tidyverse/hms?branch=master&svg=true)](https://ci.appveyor.com/project/tidyverse/hms) [![Coverage Status](https://img.shields.io/codecov/c/github/tidyverse/hms/master.svg)](https://codecov.io/github/tidyverse/hms?branch=master) [![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/hms)](https://cran.r-project.org/package=hms) -->
A simple class for storing durations values and displaying them in the `Dd HH:MM:SS` format. The implementation is exhaustively based on the very neat [hms class](https://github.com/tidyverse/hms). Intended to facilitate representation and manipulations of duration in the context of ethological experiments (that typically last several days).

The values are simply stored as a numeric vector a number of seconds. Implicitly, either since the onset of the experiment or since [ZT0](https://en.wikipedia.org/wiki/Zeitgeber) on the reference day.

``` r
library(devtools)
install_github("qgeissmann/dhms")
library(dhms)
```

Differences with `hms`
======================

``` r
library(dhms)
library(hms)
```

Display
-------

In `dhms`, we express number of days to reduce cognitive burden after 72h. This is convenient for circadian experiments:

``` r
seconds <- seq(from =1, to =10 * 24 * 3600, by=27*3600)
df <- data.frame(hms=hms(seconds), dhms=dhms(seconds))
print(df)
#>         hms        dhms
#> 1  00:00:01 0d 00:00:01
#> 2  27:00:01 1d 03:00:01
#> 3  54:00:01 2d 06:00:01
#> 4  81:00:01 3d 09:00:01
#> 5 108:00:01 4d 12:00:01
#> 6 135:00:01 5d 15:00:01
#> 7 162:00:01 6d 18:00:01
#> 8 189:00:01 7d 21:00:01
#> 9 216:00:01 9d 00:00:01
```

Parsing
-------

Parsing optional **number of days** and **negative values**:

``` r
time_str <- c("12:34:56",         # regular format
              "12:34:56.789",     # decimal points
              "20:12",             # HH:MM (no seconds)
              "-12:34:56.001",    # negative values without days
              "1d 12:34:56",      # number of days (integer)
              "1d 12:34:56.001",  # decimal points and days
              "-1d 12:34:56.001", # negative values
              "-1d 12:34:56.001", # negative values and space
              "0.5d"             # day only
              
              )
df <- data.frame(time_str=time_str, hms=as.hms(time_str), dhms=as.dhms(time_str))
print(df)
#>           time_str      hms             dhms
#> 1         12:34:56 12:34:56  0d 12:34:56.000
#> 2     12:34:56.789 12:34:56  0d 12:34:56.789
#> 3            20:12       NA  0d 20:12:00.000
#> 4    -12:34:56.001       NA -0d 12:34:56.001
#> 5      1d 12:34:56       NA  1d 12:34:56.000
#> 6  1d 12:34:56.001       NA  1d 12:34:56.001
#> 7 -1d 12:34:56.001       NA -1d 12:34:56.001
#> 8 -1d 12:34:56.001       NA -1d 12:34:56.001
#> 9             0.5d       NA  0d 12:00:00.000
```

Arithmetics
-----------

In `hms`, arithmetic operation return `difftime` object

``` r
a <- hms(123) # 123 seconds
b <- hms(125)
print(a - b) # this returns a `difftime`
#> Time difference of -2 secs
class(a - b)
#> [1] "difftime"
print(a - 1) # this too
#> Time difference of 122 secs
class(a - 1)
#> [1] "difftime"
```

With `dhms`, we want to add or subtract constant to our time, but **keep expressing the result as a pretty duration**. Typically, you want to change the origin of your time, so you just subtract a number of seconds.

``` r
a <- dhms(123)
b <- dhms(125)
print(a - b) # This returns another dhms, which expresses a duration
#> -0d 00:00:02
print(class(a - b))
#> [1] "dhms"
#> attr(,"package")
#> [1] "dhms"
print(a - 1) # Same here
#> 0d 00:02:02
print(class(a - 1))
#> [1] "dhms"
#> attr(,"package")
#> [1] "dhms"
```

Operations with time strings
----------------------------

In `hms`, we can't compare strings directly to time. One would have to use `as.hms()` on strings before comparison, which explicitly converts them to `hms` objects. It is quite convenient to compare formatted strings directly to objects. This is what happends in R for things like `POSIXct` objects:

``` r
date = as.POSIXct("2017-12-12") 
print(date)
#> [1] "2017-12-12 GMT"
print(date  == "2017-12-12")
#> [1] TRUE
print(date  > "2015-06-12" )
#> [1] TRUE
```

Likewise, in `dhms`, operations with strings implicitly converts them string to a duration representation.

``` r
time_str <- "00:02:10"
a_hms <- as.hms(time_str)
b_hms <- as.hms("00:02:02") 

a_dhms <- as.dhms(time_str)
b_dhms <- as.dhms("00:02:02") 

dt <- data.frame(operation = c("a == 00:02:10", "b > a", "b > 00:02:10", "a + 00:02:10"),
           hms=c(a_hms == time_str, b_hms > a_hms, b_hms > time_str, "FAILS"),
           dhms=c(a_dhms == time_str, b_dhms > a_dhms, b_dhms > time_str, as.character(a_dhms + time_str))
           )
print(dt)
#>       operation   hms        dhms
#> 1 a == 00:02:10 FALSE        TRUE
#> 2         b > a FALSE       FALSE
#> 3  b > 00:02:10  TRUE       FALSE
#> 4  a + 00:02:10 FAILS 0d 00:04:20
```
