\name{mFilter-package}
\alias{mFilter-package}
%\alias{mFilter}

\title{
  Getting started with the mFilter package
}

\description{
  Getting started with the mFilter package
}

\details{
This package provides some tools for decomposing time series into
trend (smooth) and cyclical (irregular) components. The package implements come commonly used
filters such as the Hodrick-Prescott, Baxter-King and Christiano-Fitzgerald
filter.

For loading the package, type:

\code{library(mFilter)}

A good place to start learning the package usage is to examine examples for
the \code{mFilter} function. At the R prompt, write:

\code{example("mFilter")}

For a full list of functions exported by the package, type:

\code{ls("package:mFilter")}

Each exported function has a corresponding man page (some man pages are
common to more functions). Display it by typing

\code{help(functionName)}.

Almost all filters in this package can be put into the following
framework. Given a time series \eqn{\{x_t\}^T_{t=1}} we are interested
in isolating component of \eqn{x_t}, denoted \eqn{y_t} with period of
oscillations between \eqn{p_l} and \eqn{p_u}, where \eqn{2
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

The Baxter-King filter is a finite data approximation to the
ideal bandpass filter with following moving average weights
\deqn{y_t = \hat{B}(L)x_t=\sum^{n}_{j=-n}\hat{B}_{j} x_{t+j}=\hat{B}_0
  x_t + \sum^{n}_{j=1} \hat{B}_j (x_{t-j}+x_{t+j})}
where
\deqn{\hat{B}_j=B_j-\frac{1}{2n+1}\sum^{n}_{j=-n} B_{j}}

The Hodrick-Prescott filter obtains the filter weights \eqn{\hat{B}_j}
as a solution to
\deqn{\hat{B}_{j}= \arg \min E \{ (y_t-\hat{y}_t)^2 \} = \arg \min
\left\{ \sum^{T}_{t=1}(y_t-\hat{y}_{t})^2 + \lambda\sum^{T-1}_{t=2}(\hat{y}_{t+1}-2\hat{y}_{t}+\hat{y}_{t-1})^2 \right\}}

The Hodrick-Prescott filter is a finite data approximation with
following moving average weights
\deqn{\hat{B}_j=\frac{1}{2\pi}\int^{\pi}_{-\pi}
\frac{4\lambda(1-\cos(\omega))^2}{1+4\lambda(1-\cos(\omega))^2}e^{i \omega
j}  d \omega}

The digital version of the Butterworth highpass filter is described by the
rational polynomial expression (the filter's z-transform)
\deqn{\frac{\lambda(1-z)^n(1-z^{-1})^n}{(1+z)^n(1+z^{-1})^n+\lambda(1-z)^n(1-z^{-1})^n}}
The time domain version can be obtained by substituting \eqn{z} for the
lag operator \eqn{L}.

Pollock (2000) derives a specialized finite-sample version of the Butterworth
filter on the basis of signal extraction theory. Let \eqn{s_t} be the
trend and \eqn{c_t} cyclical component of \eqn{y_t}, then these
components are extracted as
\deqn{y_t=s_t+c_t=\frac{(1+L)^n}{(1-L)^d}\nu_t+(1-L)^{n-d}\varepsilon_t}
where \eqn{\nu_t \sim N(0,\sigma_\nu^2)} and \eqn{\varepsilon_t \sim
  N(0,\sigma_\varepsilon^2)}.

Let \eqn{T} be even and define \eqn{n_1=T/p_u} and \eqn{n_2=T/p_l}. The
trigonometric regression filter is based on the following relation
\deqn{{y}_t=\sum^{n_1}_{j=n_2}\left\{ a_j \cos(\omega_j t) + b_j
    \sin(\omega_j t) \right\}}
where \eqn{a_j} and \eqn{b_j} are the coefficients obtained by
regressing \eqn{x_t} on the indicated sine and cosine
functions. Specifically,

\eqn{a_j=\frac{T}{2}\sum^{T}_{t=1}\cos(\omega_j t) x_t,\ \ \ }   for
\eqn{j=1,\dots,T/2-1}

\eqn{a_j=\frac{T}{2}\sum^{T}_{t=1}\cos(\pi t) x_t,\ \ \ }    for \eqn{j=T/2}

and

\eqn{b_j=\frac{T}{2}\sum^{T}_{t=1}\sin(\omega_j t) x_t,\ \ \ }    for
\eqn{j=1,\dots,T/2-1}

\eqn{b_j=\frac{T}{2}\sum^{T}_{t=1}\sin(\pi t) x_t,\ \ \ }   for \eqn{j=T/2}

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
\code{\link{mFilter-methods}} for listing all currently
available \code{mFilter} methods. For help on common interface function
"\code{mFilter}", \code{\link{mFilter}}. For individual filter function
usage, \code{\link{bwfilter}}, \code{\link{bkfilter}},
\code{\link{cffilter}}, \code{\link{hpfilter}}, \code{\link{trfilter}}.
}

\keyword{ts}
\keyword{smooth}
\keyword{loess}
\keyword{nonparametric}

