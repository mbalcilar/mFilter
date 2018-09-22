\name{mFilter-methods}
\alias{mFilter-methods}
\alias{residuals.mFilter}
\alias{fitted.mFilter}
\alias{print.mFilter}
\alias{plot.mFilter}
\alias{summary.mFilter}

\title{Methods for mFilter objects}

\description{
  Common methods for all \code{mFilter} objects usually created by the
  \code{mFilter} function.
}

\usage{
\method{residuals}{mFilter}(object, \dots)
\method{fitted}{mFilter}(object, \dots)
\method{print}{mFilter}(x, digits = max(3, getOption("digits") - 3), \dots)
\method{plot}{mFilter}(x, reference.grid = TRUE, col = "steelblue", ask=interactive(), \dots)
\method{summary}{mFilter}(object, digits = max(3, getOption("digits") - 3), \dots)
}

\arguments{
  \item{object, x}{an object of class \code{"mFilter"}; usually, a result
    of a call to \code{\link{mFilter}}.}
  \item{digits}{number of digits used for printing (see \code{\link{print}}).}
  \item{col}{color of the graph (see \code{\link{plot}}).}
  \item{ask}{logical. if \code{TRUE} the user is asked for input before a new
    graph drawn in an interactive session (see \code{\link{interactive}}).}
  \item{reference.grid}{logical. if true grid lines are drawn.}
  \item{\dots}{further arguments passed to or from other methods.}
}

\value{
  for \code{residuals} and \code{fitted} a univariate time series;
  for \code{plot}, \code{print}, and \code{summary} the   "\code{mFilter}"
  object.
}

\author{
  Mehmet Balcilar, \email{mehmet@mbalcilar.net}
}

\seealso{
  \code{\link{mFilter}} for the function that returns an objects of class \code{"mFilter"}.
  Other functions which return objects of class \code{"mFilter"} are
  \code{\link{bkfilter}},
  \code{\link{bwfilter}},
  \code{\link{cffilter}},
  \code{\link{bkfilter}},
  \code{\link{trfilter}}.
}

\examples{
## library(mFilter)

data(unemp)

opar <- par(no.readonly=TRUE)

unemp.hp <- mFilter(unemp,filter="HP")  # Hodrick-Prescott filter
print(unemp.hp)
summary(unemp.hp)
residuals(unemp.hp)
fitted(unemp.hp)
plot(unemp.hp)

par(opar)
}

\keyword{ts}
\keyword{smooth}
\keyword{loess}
\keyword{nonparametric}


