\name{bkfilter}
\alias{bkfilter}

\title{
  Baxter-King filter of a time series
}

\description{
  This function implements the Baxter-King approximation to
  the band pass filter for a time series. The function computes cyclical
  and trend components of the time series using band-pass
  approximation for fixed and variable length filters.
}

\usage{
bkfilter(x,pl=NULL,pu=NULL,nfix=NULL,type=c("fixed","variable"),drift=FALSE)
}

\arguments{
  \item{x}{a regular time series}

  \item{type}{character, indicating the filter type,
    \code{"fixed"}, for the fixed length Baxter-King filter
    (default),
    \code{"variable"}, for the variable length Baxter-King filter.}

  \item{pl}{integer. minimum period of oscillation of desired component (pl<=2).}

  \item{pu}{integer. maximum period of oscillation of desired component (2<=pl<pu<infinity).}

  \item{drift}{logical, \code{FALSE} if no drift in time series
    (default),  \code{TRUE} if drift in time series.}

  \item{nfix}{sets fixed lead/lag length or order of the filter. The
  \code{nfix} option sets the order of the filter by 2*nfix+1. The
  default is \code{frequency(x)*3}.}
}

\details{
  Almost all filters in this package can be put into the
following framework. Given a time series \eqn{\{x_t\}^T_{t=1}} we are
interested in isolating component of \eqn{x_t}, denoted \eqn{y_t} with
period of oscillations between \eqn{p_l} and \eqn{p_u}, where \eqn{2
  \le p_l < p_u < \infty}.

Consider the following decomposition of the time series
\deqn{x_t = y_t + \bar{x}_t}
The component \eqn{y_t} is assumed to have power only in the frequencies
in the interval \eqn{\{(a,b) \cup (-a,-b)\} \in (-\pi, \pi)}. \eqn{a}
and \eqn{b} are related to \eqn{p_l} and \eqn{p_u} by
\deqn{a=\frac{2 \pi}{p_u}\ \ \ \ \ {b=\frac{2 \pi}{p_l}}}

If infinite amount of data is available, then we can use the ideal
bandpass filter
\deqn{y_t = B(L)x_t}
where the filter, \eqn{B(L)}, is given in terms of the lag operator
\eqn{L} and defined as
\deqn{B(L) = \sum^\infty_{j=-\infty} B_j L^j, \ \ \ L^k x_t = x_{t-k}}
The ideal bandpass filter weights are given by
\deqn{B_j = \frac{\sin(jb)-\sin(ja)}{\pi j}}
\deqn{B_0=\frac{b-a}{\pi}}

The Baxter-King filter is a finite data approximation to the
ideal bandpass filter with following moving average weights
\deqn{y_t = \hat{B}(L)x_t=\sum^{n}_{j=-n}\hat{B}_{j} x_{t+j}=\hat{B}_0
  x_t + \sum^{n}_{j=1} \hat{B}_j (x_{t-j}+x_{t+j})}
where
\deqn{\hat{B}_j=B_j-\frac{1}{2n+1}\sum^{n}_{j=-n}B_{j}}

If \code{drift=TRUE} the drift adjusted series is obtained
\deqn{\tilde{x}_{t}=x_t-t\left(\frac{x_{T}-x_{1}}{T-1}\right), \ \ t=0,1,\dots,T-1}
where \eqn{\tilde{x}_{t}} is the undrifted series.
}

\value{
  A "\code{mFilter}" object (see \code{\link{mFilter}}).
}

\references{
M. Baxter and R.G. King. Measuring business cycles: Approximate bandpass
filters. The Review of Economics and Statistics, 81(4):575-93, 1999.

L. Christiano and T.J. Fitzgerald. The bandpass filter. International Economic
Review, 44(2):435-65, 2003.

J. D. Hamilton. \emph{Time series analysis.} Princeton, 1994.

R.J. Hodrick and E.C. Prescott. Postwar US business cycles: an empirical
investigation. Journal of Money, Credit, and Banking, 29(1):1-16, 1997.

R.G. King and S.T. Rebelo. Low frequency filtering and real business cycles.
Journal of Economic Dynamics and Control, 17(1-2):207-31, 1993.

D.S.G. Pollock. Trend estimation and de-trending via rational square-wave
filters. Journal of Econometrics, 99:317-334, 2000.
}

\author{
  Mehmet Balcilar, \email{mehmet@mbalcilar.net}
}

\seealso{
  \code{\link{mFilter}}, \code{\link{bwfilter}}, \code{\link{cffilter}},
  \code{\link{hpfilter}}, \code{\link{trfilter}}
}

\examples{
## library(mFilter)

data(unemp)

opar <- par(no.readonly=TRUE)

unemp.bk <- bkfilter(unemp)
plot(unemp.bk)
unemp.bk1 <- bkfilter(unemp, drift=TRUE)
unemp.bk2 <- bkfilter(unemp, pl=8,pu=40,drift=TRUE)
unemp.bk3 <- bkfilter(unemp, pl=2,pu=60,drift=TRUE)
unemp.bk4 <- bkfilter(unemp, pl=2,pu=40,drift=TRUE)

par(mfrow=c(2,1),mar=c(3,3,2,1),cex=.8)
plot(unemp.bk1$x,
    main="Baxter-King filter of unemployment: Trend, drift=TRUE",
    col=1, ylab="")
lines(unemp.bk1$trend,col=2)
lines(unemp.bk2$trend,col=3)
lines(unemp.bk3$trend,col=4)
lines(unemp.bk4$trend,col=5)
legend("topleft",legend=c("series", "pl=2, pu=32", "pl=8, pu=40",
      "pl=2, pu=60", "pl=2, pu=40"), col=1:5, lty=rep(1,5), ncol=1)

plot(unemp.bk1$cycle,
main="Baxter-King filter of unemployment: Cycle,drift=TRUE",
      col=2, ylab="", ylim=range(unemp.bk3$cycle,na.rm=TRUE))
lines(unemp.bk2$cycle,col=3)
lines(unemp.bk3$cycle,col=4)
lines(unemp.bk4$cycle,col=5)
## legend("topleft",legend=c("pl=2, pu=32", "pl=8, pu=40", "pl=2, pu=60",
## "pl=2, pu=40"), col=1:5, lty=rep(1,5), ncol=1)

par(opar)
}

\keyword{ts}
\keyword{smooth}
\keyword{loess}
\keyword{nonparametric}
