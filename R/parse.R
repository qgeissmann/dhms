#' Parsing dhms values
#'
#' These functions convert character vectors to objects of the [dhms] class.
#' `NA` values are supported.
#'
#' `parse_dhms()` accepts values of the form `"Dd HH:MM:SS"`, with optional day,
#' fractional seconds and supports negative times.
#' @param x A character vector
#' @export
#' @noRd
#' @examples
#' time_str = c("12:34:56", "1d 12:34:56", "12:34:56.789", "1d 12:34:56.001",
#'              "-1d 12:34:56.001", "- 1d 12:34:56.001")
#' print(parse_dhms(time_str))

parse_dhms <- function(x){
  if(length(x) > 1){
    ret <- sapply(x, parse_dhms)
    names(ret) <- NULL
    return(ret)
    }

  if(x == "NA" | is.na(x))
    return(NA)
  pattern <- "^(-)?(\\s*)?((.+)d)?(\\s*)?(.+)?$"
  match = stringr::str_match(x, pattern)

  colnames(match) <- c("all", "minus", "sp1", "xd","days","sp2","hours")
  #print(match)
  neither_days_nor_hours <- x[is.na(match[,"days"]) & is.na(match[,"hours"])]
  if(length(neither_days_nor_hours) >0)
    stop("Wrong format. Neither days nor hours are provided",
         " e.g. either '1d 22:00:00' or '46:00:00' ", neither_days_nor_hours)
  n_seconds_hours <-parse_time_str(match[,"hours"])

  n_seconds_hours <-ifelse(is.na(n_seconds_hours),
                           0,
                           n_seconds_hours)


  n_seconds_days <- ifelse(is.na(match[,"days"]),
                           0,
                           86400 * as.numeric(match[,"days"]))
  invalid_day_format <- n_seconds_days[is.na(n_seconds_days)]
  if(length(invalid_day_format) > 0)
    stop("Invalid day format. ",
         "It should be'Nd HH:MM:SS' or 'Nd', where N is a number: ",x)
  overflow <- x[n_seconds_hours >= 86400 & n_seconds_days != 0]
  if(length(overflow) >0)
    stop("Overflow in number of hours. You cannot add more than 24h and use days!",
         "e.g. '1d 25:00:00' should be '2d 01:00:00': ",x)

  frac_day <- x[n_seconds_days %% 86400 !=0 & n_seconds_hours != 0]
  if(length(frac_day) >0)
    stop("You cannot use fractional days AND hours!",
         "e.g. '1.5d 11:20:12'  should be 1d 23:20:12: ",x)
  n_seconds <- n_seconds_hours + n_seconds_days
  # match the tailing `-`
  out <- ifelse(is.na(match[,2]),n_seconds, -n_seconds)
  names(out) <- NULL
  out
}

parse_time_str <- function(str){
  if(length(str) != 1)
    stop("parse_time_str only work on scalars")
  if(is.na(str))
    return(NA)
  pattern <- "^((\\d+):([0-9][0-9]))(:([0-9][0-9])(\\.\\d+)?)?$"
  match = stringr::str_match(str, pattern)
  colnames(match) <- c("all", "hm", "h", "m","all_sec","s","split_sec")

  if(is.na(match[,"hm"]))
   stop("Invalid format for time",
        "Valid formats are'HH:MM', 'HH:MM:SS' and 'HH:MM:SS.sssss':\n", str)
  hours <- as.numeric(match[,"h"])
  mins <- as.numeric(match[,"m"])
  secs <- ifelse(is.na(match[,"s"]),0,as.numeric(match[,"s"]))
  split_secs <- ifelse(is.na(match[,"split_sec"]),0,as.numeric(match[,"split_sec"]))
  secs <- secs+ split_secs

  if(mins>=60)
    stop("Overflow in number of minutes. You cannot add more than 60min!",
         "e.g. '00:61:00' should be '01:01:00':\n", str)

  if(secs>=60)
    stop("Overflow in number of seconds. You cannot add more than 60s!",
         "e.g. '00:00:61' should be '00:01:01' ", str)

  hours *3600 + mins * 60 + secs
  }
