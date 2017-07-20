#' Round or truncate to a multiple of seconds
#'
#' Convenience functions to round or truncate to a multiple of seconds.
#' @param x A vector of class [dhms]
#' @param secs Multiple of seconds, a positive numeric. Values less than one
#'   are supported
#' @return The input, rounded or truncated to the nearest multiple of `secs`
#' @export
#' @examples
#' round_dhms(as.dhms("12:34:56"), 5)
#' round_dhms(as.dhms("12:34:56"), 60)
#' round_dhms(as.dhms("1d 12:34:56"), 60)
#' round_dhms(as.dhms("-1d 12:34:56"), 60)
round_dhms <- function(x, secs) {
  as.dhms(round(as.numeric(x) / secs) * secs)
}

#' @rdname round_hms
#' @export
#' @examples
#' trunc_hms(as.dhms("2d 12:34:56"), 60)
trunc_dhms <- function(x, secs) {
  as.dhms(trunc(as.numeric(x) / secs) * secs)
}
