\name{cffilter}
\alias{cffilter}

\title{
  Christiano-Fitzgerald filter of a time series
}

\description{
  This function implements the Christiano-Fitzgerald approximation to
  the ideal band pass filter for a time series. The function computes cyclical
  and trend components of the time series using several band-pass
  approximation strategies. 
}

\usage{
cffilter(x,pl=NULL,pu=NULL,root=FALSE,drift=FALSE,
         type=c("asymmetric","symmetric","fixed","baxter-king","trigonometric"),
	 nfix=NULL,theta=1)
}

\arguments{
  \item{x}{a regular time series.}

  \item{type}{the filter type,
    \code{"asymmetric"}, asymmetric Christiano-Fitzgerald filter
    (default),
    \code{"symmetric"}, symmetric Christiano-Fitzgerald filter
    \code{"fixed"}, fixed length Christiano-Fitzgerald filter,
    \code{"baxter-king"}, Baxter-King fixed length symmetric filter,
    \code{"trigonometric"}, trigonometric regression filter.}

  \item{pl}{minimum period of oscillation of desired component (pl<=2).}

  \item{pu}{maximum period of oscillation of desired component (2<=pl<pu<infinity).}

  \item{root}{logical, \code{FALSE} if no unit root in time series
    (default),  \code{TRUE} if unit root in time series. The
    \code{root} option has no effect if \code{type} is
    \code{"baxter-king"} or \code{"trigonometric"}.}

  \item{drift}{logical, \code{FALSE} if no drift in time series
    (default),  \code{TRUE} if drift in time series.}
  
  \item{nfix}{sets fixed lead/lag length or order of the filter with
    \code{"baxter-king"} and \code{"fixed"}. The \code{nfix} option sets
  the order of the filter by 2*nfix+1. The default is \code{nfix=1}.}

\item{theta}{moving average coefficients for time series model: x(t) =
  mu + root*x(t-1) + theta(1)*e(t) + theta(2)*e(t-1) + \dots, where e(t)
  is a white noise.}
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
The finite sample approximation to the ideal bandpass filter uses the
alternative filter
\deqn{y_t = \hat{B}(L)x_t=\sum^{n_2}_{j=-n_1}\hat{B}_{t,j} x_{t+j}}
Here the weights, \eqn{\hat{B}_{t,j}}, of the approximation is a
solution to
\deqn{\hat{B}_{t,j}= \arg \min E \{ (y_t-\hat{y}_t)^2 \}}
The Christiano-Fitzgerald filter is a finite data approximation to the
ideal bandpass filter and minimizes the mean squared error defined in the
above equation.

Several band-pass approximation strategies can be selected in the
function \code{cffilter}. The default setting of \code{cffilter} returns
the filtered data \eqn{\hat{y_t}} associated with the unrestricted optimal filter
assuming no unit root, no drift and an iid filter.

If \code{theta} is not equal to 1 the series is assumed to follow a
moving average process. The moving average weights are given by \code{theta}. The default is
\code{theta=1} (iid series). If \code{theta}\eqn{=(\theta_1, \theta_2, \dots)} then
the series is assumed to be
\deqn{x_t = \mu + 1_{root} x_{t-1} + \theta_1 e_t + \theta_2 e_{t-1} + \dots}
where \eqn{1_{root}=1} if the option \code{root=1} and \eqn{1_{root}=0}
if the option \code{root=0}, and \eqn{e_t} is a white noise.

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
  \code{\link{mFilter}}, \code{\link{bwfilter}}, \code{\link{bkfilter}},
  \code{\link{hpfilter}}, \code{\link{trfilter}}
}

\examples{
## library(mFilter)

data(unemp)

opar <- par(no.readonly=TRUE)

unemp.cf <- cffilter(unemp)
plot(unemp.cf)
unemp.cf1 <- cffilter(unemp, drift=TRUE, root=TRUE)
unemp.cf2 <- cffilter(unemp, pl=8,pu=40,drift=TRUE, root=TRUE)
unemp.cf3 <- cffilter(unemp, pl=2,pu=60,drift=TRUE, root=TRUE)
unemp.cf4 <- cffilter(unemp, pl=2,pu=40,drift=TRUE, root=TRUE,theta=c(.1,.4))

par(mfrow=c(2,1),mar=c(3,3,2,1),cex=.8)
plot(unemp.cf1$x,
main="Christiano-Fitzgerald filter of unemployment: Trend \n root=TRUE,drift=TRUE",
col=1, ylab="")
lines(unemp.cf1$trend,col=2)
lines(unemp.cf2$trend,col=3)
lines(unemp.cf3$trend,col=4)
lines(unemp.cf4$trend,col=5)
legend("topleft",legend=c("series", "pl=2, pu=32", "pl=8, pu=40", "pl=2, pu=60",
"pl=2, pu=40, theta=.1,.4"), col=1:5, lty=rep(1,5), ncol=1)

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
