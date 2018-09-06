\name{hpfilter}
\alias{hpfilter}

\title{
  Hodrick-Prescott filter of a time series
}

\description{
  This function implements the Hodrick-Prescott for estimating cyclical
  and trend component of a time series. The function computes cyclical
  and trend components of the time series using a frequency cut-off or
  smoothness parameter. 
}

\usage{
hpfilter(x,freq=NULL,type=c("lambda","frequency"),drift=FALSE)
}

\arguments{
  \item{x}{a regular time series.}
  
  \item{type}{character, indicating the filter type,
    \code{"lambda"}, for the filter that uses smoothness penalty
    parameter of the Hodrick-Prescott filter 
    (default),
    \code{"frequency"}, for the filter that uses a frequency cut-off
    type Hodrick-Prescott filter. These are related by
    \eqn{lambda = (2*sin(pi/frequency))^{-4}}.}

  \item{freq}{integer, if \code{type="lambda"} then \code{freq} is the
  smoothing parameter (lambda) of the Hodrick-Prescott filter, if
  \code{type="frequency"} then \code{freq} is the
  cut-off frequency of the Hodrick-Prescott filter.}

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

The Hodrick-Prescott filter obtains the filter weights \eqn{\hat{B}_j}
as a solution to 
\deqn{\hat{B}_{j}= \arg \min E \{ (y_t-\hat{y}_t)^2 \} = \arg \min
\left\{ \sum^{T}_{t=1}(y_t-\hat{y}_{t})^2 + \lambda\sum^{T-1}_{t=2}(\hat{y}_{t+1}-2\hat{y}_{t}+\hat{y}_{t-1})^2 \right\}}

The Hodrick-Prescott filter is a finite data approximation with
following moving average weights 
\deqn{\hat{B}_j=\frac{1}{2\pi}\int^{\pi}_{-\pi}
\frac{4\lambda(1-\cos(\omega))^2}{1+4\lambda(1-\cos(\omega))^2}e^{i \omega
j}  d \omega}

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
  \code{\link{mFilter}}, \code{\link{bwfilter}}, \code{\link{cffilter}},
  \code{\link{bkfilter}}, \code{\link{trfilter}}
}

\examples{
## library(mFilter)

data(unemp)

opar <- par(no.readonly=TRUE)

unemp.hp <- hpfilter(unemp)
plot(unemp.hp)
unemp.hp1 <- hpfilter(unemp, drift=TRUE)
unemp.hp2 <- hpfilter(unemp, freq=800, drift=TRUE)
unemp.hp3 <- hpfilter(unemp, freq=12,type="frequency",drift=TRUE)
unemp.hp4 <- hpfilter(unemp, freq=52,type="frequency",drift=TRUE)

par(mfrow=c(2,1),mar=c(3,3,2,1),cex=.8)
plot(unemp.hp1$x,  ylim=c(2,13),
main="Hodrick-Prescott filter of unemployment: Trend, drift=TRUE",
     col=1, ylab="")
lines(unemp.hp1$trend,col=2)
lines(unemp.hp2$trend,col=3)
lines(unemp.hp3$trend,col=4)
lines(unemp.hp4$trend,col=5)
legend("topleft",legend=c("series", "lambda=1600", "lambda=800", 
       "freq=12", "freq=52"), col=1:5, lty=rep(1,5), ncol=1)

plot(unemp.hp1$cycle,
main="Hodrick-Prescott filter of unemployment: Cycle,drift=TRUE", 
     col=2, ylab="", ylim=range(unemp.hp4$cycle,na.rm=TRUE))
lines(unemp.hp2$cycle,col=3)
lines(unemp.hp3$cycle,col=4)
lines(unemp.hp4$cycle,col=5)
## legend("topleft",legend=c("lambda=1600", "lambda=800",
## "freq=12", "freq=52"), col=1:5, lty=rep(1,5), ncol=1)

par(opar)
}

\keyword{ts}
\keyword{smooth}
\keyword{loess}
\keyword{nonparametric}
