\name{mFilter}
\alias{mFilter}
\alias{mFilter.default}
\alias{mFilter.ts}
%\alias{print.mFilter}
%\alias{summary.mFilter}
%\alias{plot.mFilter}

\title{
  Decomposition of a time series into trend and cyclical components
  using various filters
}

\description{
  \code{mFilter} is a generic function for filtering
time series data.  The function invokes particular
\emph{filters} which depend on filter type specified via its argument
\code{filter}. The filters implemented in the package \code{mFilter}
package are useful for smoothing, and estimating tend and cyclical components.
Some of these filters are commonly used in economics and
finance for estimating cyclical component of time series. 

The \code{mFilter} currently applies only to time series
objects. However a default method is available and should work for any
\code{\link[base]{numeric}} or \code{\link[base]{vector}} object.
}

\details{
  The default behaviour is to apply the default filter to
  \code{\link[stats]{ts}} objects.
}

\usage{
  mFilter(x, \dots)
  \method{mFilter}{default}(x, \dots)
  \method{mFilter}{ts}(x, filter=c("HP","BK","CF","BW","TR"), \dots)
}

\arguments{
  \item{x}{a regular a time series.}
  
  \item{filter}{filter type, the filter types are \code{"HP"}
  (Hodrick-Prescott), \code{"BK"} (Baxter-King), \code{"CF"}
  (Christiano-Fitzgerald), \code{"BW"} (Butterworth), and \code{"TR"}
  (trigonometric regression).}

\item{...}{Additional arguments to pass to the relevant filter
  functions. These are passed to \code{hpfilter},  \code{bkfilter},
  \code{cffilter}, \code{bwfilter}, and \code{trfilter}, respectively for
  the \code{"HP"}, \code{"BK"}, \code{"CF"}, \code{"BW"}, and \code{"TR"} filters.}
}

\value{
  An object of class "\code{mFilter}".

The function \code{summary} is used to obtain and print a summary of the
results, while the function \code{plot} produces a plot of the original
series, the trend, and the cyclical components. The function \code{print} is also available
for displaying estimation results.

The generic accessor functions \code{fitted} and \code{residuals}
extract estimated trend and cylclical componets of an "\code{mFilter}"
object, respectively.

An object of class "\code{mFilter}" is a list containing at least the following elements:
\item{cycle}{Estimated cyclical (irregular) component of the series.}
\item{trend}{Estimated trend (smooth) component of the series.}
\item{fmatrix}{The filter matrix applied to original series.}
\item{method}{The method, if available, for the filter type applied.}
\item{type}{The filter type applied to the series.}
\item{call}{Call to the function.}
\item{title}{The title for displaying results.}
\item{xname}{Name of the series passed to \code{mFilter} for filtering.}
\item{x}{The original or drift adjusted, if \code{drift=TRUE}, time series passed to the \code{mFilter}.}

Following additional elements may exists depending on the type of filter
applied:
\item{nfix}{Length or order of the fixed length filters.}
\item{pl}{Minimum period of oscillation of desired component (2<=pl).}
\item{pu}{Maximum period of oscillation of desired component (2<=pl<pu<infinity).}
\item{lambda}{Lambda (smoothness) parameter of the HP filter.}
\item{root}{Whether time series has a unit root, TRUE or FALSE (default).}
\item{drift}{Whether time series has drift, TRUE or FALSE (default).}
\item{theta}{MA coefficients for time series model, used in \code{"CF"} filter.}
}

\seealso{
  Other functions which return objects of class \code{"mFilter"} are
  \code{\link{bkfilter}},
  \code{\link{bwfilter}},
  \code{\link{cffilter}},
  \code{\link{bkfilter}},
  \code{\link{trfilter}}.
    Following functions apply the relevant methods to an object of the
    \code{"mFilter"} class:
  \code{\link{print.mFilter}},
  \code{\link{summary.mFilter}},
  \code{\link{plot.mFilter}},
  \code{\link{fitted.mFilter}},
  \code{\link{residuals.mFilter}}.
}

\author{
  Mehmet Balcilar, \email{mbalcilar@yahoo.com}
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

unemp.bk <- mFilter(unemp,filter="BK")  # Baxter-King filter
unemp.cf <- mFilter(unemp,filter="CF")  # Christiano-Fitzgerald filter
unemp.bw <- mFilter(unemp,filter="BW")  # Butterworth filter
unemp.tr <- mFilter(unemp,filter="TR")  # Trigonometric regression filter

par(mfrow=c(2,1),mar=c(3,3,2,1),cex=.8)
plot(unemp,main="Unemployment Series & Estimated Trend", col=1, ylab="")
lines(unemp.hp$trend,col=2)
lines(unemp.bk$trend,col=3)
lines(unemp.cf$trend,col=4)
lines(unemp.bw$trend,col=5)
lines(unemp.tr$trend,col=6)

legend("topleft",legend=c("series", "HP","BK","CF","BW","TR"),
    col=1:6,lty=rep(1,6),ncol=2)

plot(unemp.hp$cycle,main="Estimated Cyclical Component",
     ylim=c(-2,2.5),col=2,ylab="")
lines(unemp.bk$cycle,col=3)
lines(unemp.cf$cycle,col=4)
lines(unemp.bw$cycle,col=5)
lines(unemp.tr$cycle,col=6)
## legend("topleft",legend=c("HP","BK","CF","BW","TR"),
## col=2:6,lty=rep(1,5),ncol=2)

unemp.cf1 <- mFilter(unemp,filter="CF", drift=TRUE, root=TRUE)
unemp.cf2 <- mFilter(unemp,filter="CF", pl=8,pu=40,drift=TRUE, root=TRUE)
unemp.cf3 <- mFilter(unemp,filter="CF", pl=2,pu=60,drift=TRUE, root=TRUE)
unemp.cf4 <- mFilter(unemp,filter="CF", pl=2,pu=40,drift=TRUE, 
             root=TRUE,theta=c(.1,.4))

plot(unemp,
main="Christiano-Fitzgerald filter of unemployment: Trend \n root=TRUE,drift=TRUE", 
      col=1, ylab="")
lines(unemp.cf1$trend,col=2)
lines(unemp.cf2$trend,col=3)
lines(unemp.cf3$trend,col=4)
lines(unemp.cf4$trend,col=5)
legend("topleft",legend=c("series", "pl=2, pu=32", "pl=8, pu=40", 
"pl=2, pu=60", "pl=2, pu=40, theta=.1,.4"), col=1:5, lty=rep(1,5), ncol=1)

plot(unemp.cf1$cycle,
main="Christiano-Fitzgerald filter of unemployment: Cycle \n root=TRUE,drift=TRUE", 
     col=2, ylab="", ylim=range(unemp.cf3$cycle))
lines(unemp.cf2$cycle,col=3)
lines(unemp.cf3$cycle,col=4)
lines(unemp.cf4$cycle,col=5)
## legend("topleft",legend=c("pl=2, pu=32", "pl=8, pu=40", "pl=2, pu=60",
## "pl=2, pu=40, theta=.1,.4"), col=2:5, lty=rep(1,4), ncol=2)

par(opar)
}

\keyword{ts}
\keyword{smooth}
\keyword{loess}
\keyword{nonparametric}

