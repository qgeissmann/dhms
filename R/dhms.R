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
#' \dontrun{
#' #' hms(56, 34, 12)
#' as.hms(1)
#' as.hms("12:34:56")
#' as.hms(Sys.time())
#' as.POSIXct(hms(1))
#'   # Will raise an error
#'   data.frame(a = hms(1))
#' d <- data.frame(hours = 1:3)
#' d$hours <- hms(hours = d$hours)
#' d
#' }

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
  #hms:::check_args(args)
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
  stop("Can't convert object of class ", paste(class(x), collapse = ", "),
       " to dhms.", call. = FALSE)
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
as.dhms.charcter <- function(x, ...) parse_dhms(x)


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
