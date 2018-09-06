\name{trfilter}
\alias{trfilter}

\title{
  Trigonometric regression filter of a time series
}

\description{
  This function uses trigonometric regression filter for estimating cyclical
  and trend components of a time series. The function computes cyclical
  and trend components of the time series using a lower and upper cut-off
  frequency in the spirit of a band pass filter.
}

\usage{
trfilter(x,pl=NULL,pu=NULL,drift=FALSE)
}

\arguments{
  \item{x}{a regular time series.}

  \item{pl}{integer. minimum period of oscillation of desired component
  (pl<=2).}

  \item{pu}{integer. maximum period of oscillation of desired component
  (2<=pl<pu<infinity).}

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

Let \eqn{T} be even and define \eqn{n_1=T/p_u} and \eqn{n_2=T/p_l}. The
trigonometric regression filter is based on the following relation
\deqn{{y}_t=\sum^{n_1}_{j=n_2}\left\{ a_j \cos(\omega_j t) + b_j
    \sin(\omega_j t) \right\}}
where \eqn{a_j} and \eqn{b_j} are the coefficients obtained by
regressing \eqn{x_t} on the indicated sine and cosine
functions. Specifically,

\eqn{a_j=\frac{T}{2}\sum^{T}_{t=1}\cos(\omega_j t) x_t,\ \ \ }    for
\eqn{j=1,\dots,T/2-1}

\eqn{a_j=\frac{T}{2}\sum^{T}_{t=1}\cos(\pi t) x_t,\ \ \ }    for \eqn{j=T/2}

and

\eqn{b_j=\frac{T}{2}\sum^{T}_{t=1}\sin(\omega_j t) x_t,\ \ \ }    for
\eqn{j=1,\dots,T/2-1}

\eqn{b_j=\frac{T}{2}\sum^{T}_{t=1}\sin(\pi t) x_t,\ \ \ }    for \eqn{j=T/2}

Let \eqn{\hat{B}(L) x_t} be the trigonometric regression filter. It can
be showed that \eqn{\hat{B}(1)=0}, so that \eqn{\hat{B}(L)} has a unit
root for \eqn{t=1,2,\dots,T}. Also, when \eqn{\hat{B}(L)} is symmetric,
it has a second unit root in the middle of the data for
\eqn{t}. Therefore it is important to drift adjust data before it is
filtered with a trigonometric regression filter.

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
  \code{\link{bkfilter}}, \code{\link{bwfilter}}
}

\examples{
## library(mFilter)

data(unemp)

opar <- par(no.readonly=TRUE)

unemp.tr <- trfilter(unemp, drift=TRUE)
plot(unemp.tr)
unemp.tr1 <- trfilter(unemp, drift=TRUE)
unemp.tr2 <- trfilter(unemp, pl=8,pu=40,drift=TRUE)
unemp.tr3 <- trfilter(unemp, pl=2,pu=60,drift=TRUE)
unemp.tr4 <- trfilter(unemp, pl=2,pu=40,drift=TRUE)

par(mfrow=c(2,1),mar=c(3,3,2,1),cex=.8)
plot(unemp.tr1$x,
main="Trigonometric regression filter of unemployment: Trend, drift=TRUE",
     col=1, ylab="")
lines(unemp.tr1$trend,col=2)
lines(unemp.tr2$trend,col=3)
lines(unemp.tr3$trend,col=4)
lines(unemp.tr4$trend,col=5)
legend("topleft",legend=c("series", "pl=2, pu=32", "pl=8, pu=40", 
"pl=2, pu=60", "pl=2, pu=40"), col=1:5, lty=rep(1,5), ncol=1)

plot(unemp.tr1$cycle,
main="Trigonometric regression filter of unemployment: Cycle,drift=TRUE", 
     col=2, ylab="", ylim=range(unemp.tr3$cycle,na.rm=TRUE))
lines(unemp.tr2$cycle,col=3)
lines(unemp.tr3$cycle,col=4)
lines(unemp.tr4$cycle,col=5)
## legend("topleft",legend=c("pl=2, pu=32", "pl=8, pu=40", "pl=2, pu=60",
## "pl=2, pu=40"), col=1:5, lty=rep(1,5), ncol=1)

par(opar)
}

\keyword{ts}
\keyword{smooth}
\keyword{loess}
\keyword{nonparametric}
