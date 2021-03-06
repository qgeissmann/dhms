% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/dhms.R
\name{dhms}
\alias{dhms}
\alias{dhms}
\alias{as.dhms}
\alias{as.dhms.default}
\alias{as.dhms.difftime}
\alias{as.dhms.numeric}
\alias{as.dhms.character}
\alias{as.character.dhms}
\alias{format.dhms}
\alias{print.dhms}
\title{A simple class for storing, printing and calculating on time durations.}
\usage{
dhms(seconds = NULL, minutes = NULL, hours = NULL, days = NULL)

as.dhms(x, ...)

\method{as.dhms}{default}(x, ...)

\method{as.dhms}{difftime}(x, ...)

\method{as.dhms}{numeric}(x, ...)

\method{as.dhms}{character}(x, ...)

\method{as.character}{dhms}(x, ...)

\method{format}{dhms}(x, ...)

\method{print}{dhms}(x, ...)
}
\arguments{
\item{seconds, minutes, hours, days}{Time since ZT0. No bounds checking is
performed.}

\item{x}{An object.}

\item{...}{Arguments passed on to further methods.}
}
\description{
It derives from \link{numeric} and internally represents time in "seconds".
Conceptually very close to \link[hms:hms]{hms::hms}, but with day values and arithmetics operations.
Supports construction from formatted string, coercion to and from
various data types.
Can be used as a regular column in a data frame.
}
\details{
For \code{dhms}, all arguments must have the same length or be
\code{NULL}.  Odd combinations (e.g., passing only \code{seconds} and
\code{hours} but not \code{minutes}) are rejected.
}
\examples{
print(c(dhms(56, 34, 12),dhms(56, 34, 12)))
dhms(56, 34, 12,1)
as.dhms(3600 * 2 + 60* 23+ 59 )
as.dhms("-1d 12:34:56")[1]
as.dhms(Sys.time())
dhms(102031) - "20:00:00"
dhms(20) == "00:00:20"
dhms(21) > "00:00:20"
dhms(19) < "00:00:20"
print(as.dhms("0.5d"))
print(-dhms(56, 34, 12,1))
\dontrun{
# we expect ERRORS in the folowing cases
as.dhms("0.5d 21:00:00") # decimal days and hours
as.dhms("1d 64:00:00") # more than 24h, and days
}
}
