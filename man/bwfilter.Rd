\name{bwfilter}
\alias{bwfilter}

\title{
  Butterworth filter of a time series
}

\description{
  Filters a time series using the Butterworth square-wave
highpass filter described in Pollock (2000). 
}

\usage{
bwfilter(x,freq=NULL,nfix=NULL,drift=FALSE)
}

\arguments{
  \item{x}{a regular time series}

  \item{nfix}{sets the order of the filter. The default is
  \code{nfix=2}, when \code{nfix=NULL}.}
  
  \item{freq}{integer, the cut-off frequency of the Butterworth
  filter. The default is \code{trunc(2.5*frequency(x))}.}

  \item{drift}{logical, \code{FALSE} if no drift in time series
    (default),  \code{TRUE} if drift in time series.}
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

The digital version of the Butterworth highpass filter is described by the
rational polynomial expression (the filter's z-transform)
\deqn{\frac{\lambda(1-z)^n(1-z^{-1})^n}{(1+z)^n(1+z^{-1})^n+\lambda(1-z)^n(1-z^{-1})^n}}
The time domain version can be obtained by substituting \eqn{z} for the
lag operator \eqn{L}.

Pollock derives a specialized finite-sample version of the Butterworth
filter on the basis of signal extraction theory. Let \eqn{s_t} be the
trend and \eqn{c_t} cyclical component of \eqn{y_t}, then these
components are extracted as
\deqn{y_t=s_t+c_t=\frac{(1+L)^n}{(1-L)^d}\nu_t+(1-L)^{n-d}\varepsilon_t}
where \eqn{\nu_t \sim N(0,\sigma_\nu^2)} and \eqn{\varepsilon_t \sim N(0,\sigma_\varepsilon^2)}.

If \code{drift=TRUE} the drift adjusted series is obtained as
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
  Mehmet Balcilar, \email{mbalcilar@yahoo.com}
}

\seealso{
  \code{\link{mFilter}}, \code{\link{hpfilter}}, \code{\link{cffilter}},
  \code{\link{bkfilter}}, \code{\link{trfilter}}
}

\examples{
## library(mFilter)

data(unemp)

opar <- par(no.readonly=TRUE)

unemp.bw <- bwfilter(unemp)
plot(unemp.bw)
unemp.bw1 <- bwfilter(unemp, drift=TRUE)
unemp.bw2 <- bwfilter(unemp, freq=8,drift=TRUE)
unemp.bw3 <- bwfilter(unemp, freq=10, nfix=3, drift=TRUE)
unemp.bw4 <- bwfilter(unemp, freq=10, nfix=4, drift=TRUE)

par(mfrow=c(2,1),mar=c(3,3,2,1),cex=.8)
plot(unemp.bw1$x,
     main="Butterworth filter of unemployment: Trend, 
     drift=TRUE",col=1, ylab="")
lines(unemp.bw1$trend,col=2)
lines(unemp.bw2$trend,col=3)
lines(unemp.bw3$trend,col=4)
lines(unemp.bw4$trend,col=5)
legend("topleft",legend=c("series", "freq=10, nfix=2", 
       "freq=8, nfix=2", "freq=10, nfix=3", "freq=10, nfix=4"), 
       col=1:5, lty=rep(1,5), ncol=1)

plot(unemp.bw1$cycle,
     main="Butterworth filter of unemployment: Cycle,drift=TRUE", 
     col=2, ylab="", ylim=range(unemp.bw3$cycle,na.rm=TRUE))
lines(unemp.bw2$cycle,col=3)
lines(unemp.bw3$cycle,col=4)
lines(unemp.bw4$cycle,col=5)
## legend("topleft",legend=c("series", "freq=10, nfix=2", "freq=8,
## nfix=2", "freq## =10, nfix=3", "freq=10, nfix=4"), col=1:5, 
## lty=rep(1,5), ncol=1)

par(opar)
}

\keyword{ts}
\keyword{smooth}
\keyword{loess}
\keyword{nonparametric}
