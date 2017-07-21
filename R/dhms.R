setClass("dhms", contains = "numeric")

#' A simple class for storing time-of-day values
#'
#' The values are stored as a [numeric] vector with a custom class,
#' and always with "seconds" as unit for robust coercion to numeric.
#' Supports construction from time values, coercion to and from
#' various data types, and formatting.  Can be used as a regular column in a
#' data frame.
#'
#' @name dhms
#' @examples
#' dhms(56, 34, 12)
#' dhms(56, 34, 12,1)
#' as.dhms(3600 * 2 + 60* 23+ 59 )
#' as.dhms("-1d 12:34:56")[1]
#' as.dhms(Sys.time())
#' dhms(102031) - "20:00:00"
#' dhms(20) == "00:00:20"
#' dhms(21) > "00:00:20"
#' dhms(19) < "00:00:20"
#' print(dhms(56, 34, 12,1))
#' print(-dhms(56, 34, 12,1))
NULL

#' @rdname dhms
#' @details For `dhms`, all arguments must have the same length or be
#'   `NULL`.  Odd combinations (e.g., passing only `seconds` and
#'   `hours` but not `minutes`) are rejected.
#' @param seconds,minutes,hours,days Time since ZT0. No bounds checking is
#'   performed.
#' @export
dhms <- function(seconds = NULL, minutes = NULL, hours = NULL, days = NULL) {
  args <- list(seconds = seconds, minutes = minutes, hours = hours, days = days)
  hms:::check_args(args)
  arg_secs <- mapply(`*`, args, c(1, 60, 3600, 86400))
  secs <- Reduce(`+`, arg_secs[vapply(arg_secs, length, integer(1L)) > 0L])

  new("dhms",secs)
}


#' @rdname dhms
#' @param x An object.
#' @param ... Arguments passed on to further methods.
#' @export
as.dhms <- function(x, ...) UseMethod("as.dhms", x)

#' @rdname dhms
#' @export
as.dhms.default <- function(x, ...) {
  as.dhms(as.numeric(hms::as.hms(x)))
}

#' @rdname dhms
#' @export
as.dhms.difftime <- function(x, ...) {
  units(x) <- "secs"
  as.dhms(as.numeric(x))
}

#' @rdname dhms
#' @export
as.dhms.numeric <- function(x, ...) dhms(x)

#' @rdname dhms
#' @export
as.dhms.character <- function(x, ...) dhms(parse_dhms(x))


#' @rdname dhms
#' @export
as.character.dhms <- function(x, ...) {
  ifelse(is.na(x), "NA", paste0(
    ifelse(x < 0, "-", ""),
    abs(hms:::days(x)), "d ",
    hms:::format_two_digits(abs(hms:::hour_of_day(x))), ":",
    hms:::format_two_digits(hms:::minute_of_hour(x)), ":",
    hms:::format_two_digits(hms:::second_of_minute(x)),
    hms:::format_split_seconds(x)))
}


#' @export
`Ops.dhms` <- function(e1, e2=NULL) {
  if (nargs() == 1)
    NextMethod(.Generic)
  if(is.character(e2))
    e2 <- parse_dhms(e2)

  if(is.character(e1))
    e1 <- parse_dhms(e1)
  NextMethod(.Generic)

}



# Output ------------------------------------------------------------------


#' @rdname dhms
#' @export
format.dhms <- function(x, ...) {
  format(as.character(x), justify = "right")
}

#' @rdname dhms
#' @export
print.dhms <- function(x, ...) {
  cat(format(x), sep = "\n")
  invisible(x)
}
