#' Parsing dhms values
#'
#' These functions convert character vectors to objects of the [dhms] class.
#' `NA` values are supported.
#'
#' `parse_dhms()` accepts values of the form `"Dd HH:MM:SS"`, with optional day,
#' fractional seconds and supports negative times.
#' @param x A character vector
#' @export
#' @examples
#' time_str = c("12:34:56", "1d 12:34:56", "12:34:56.789", "1d 12:34:56.001",
#'              "-1d 12:34:56.001", "- 1d 12:34:56.001")
#' print(parse_dhms(time_str))

parse_dhms <- function(x) {
  pattern <- "^(-\\s*)?(?:(\\d+)d\\s*)?([0-9]{2}:[0-9]{2}:[0-9]{2}).?(\\d+)?$"
  match = stringr::str_match(x, pattern)
  n_seconds <- as.numeric(
    as.difftime(as.character(match[,4]), format = "%H:%M:%OS", units = "secs")
    )
  n_seconds <- n_seconds + ifelse(is.na(match[,3]),
                                  0,
                                  86400 * as.numeric(match[,3]))
  # decimal seconds
  n_seconds <- n_seconds + ifelse(is.na(match[,5]),0,as.numeric(match[,5]))
  # match the tailing `-`
  dhms(ifelse(is.na(match[,2]),n_seconds, -n_seconds))

}


