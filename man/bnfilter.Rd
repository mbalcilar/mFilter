\name{bnfilter}
\alias{bnfilter}
\alias{BNfilter}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Beveridge-Nelson filter of a time series
}
\description{
  This function implements the Beveridge-Nelson filter for decomposing an integrated
  time series into a stochastic trend and a cycle. The decomposition is based on the parameters of
  an ARIMA(p,1,q) model for x
}
\usage{
bnfilter(x,p=NULL,q=NULL,phi=NULL,theta=NULL,drift=NULL)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{x}{ A time series or a vector}
  \item{p}{ Integer, the order of the AR part in the ARIMA specification for x. Note that it prevails over
  the length of the phi argument, if the two are different phi will be coerced to have the same length as p,
  either by cutting entries in phi excess of p or by estimating further parameters}
  \item{q}{ Integer, he order of the MA part in the ARIMA specification for x. Note that it prevails over
  the length of the theta argument, if the two are different, theta will be coerced to have the same length as p,
  either by cutting entries in theta in excess of q or by estimating further parameters}
  \item{phi}{ A vector of parameters to be used for the Auto Regressive part of the ARIMA model
  that defines the filter. The parameters should be in reverse time order \eqn{(\phi_1, ... ,\phi_p)}.
  If an entry has value NA, that parameter is left to be estimated}
  \item{theta}{ A vector of parameters to be used for the Moving Average part of the ARIMA model
  that defines the filter. The parameters should be in reverse time order \eqn{(\theta_1, ... ,\theta_p)}.
  If an entry has value NA, that parameter is left to be estimated}
  \item{drift}{ The drift (intercept) of the ARIMA model fitted to the differenced series. If left NULL the drift will be estimated. Set to \eqn{0} to estimate without a drift term.}
}
\details{
Differently from most filters in this package, the Beveridge Nelson filter decomposes an \eqn{I(1)}
time series by splitting it into a permanent component, the trend, that is a random walk with drift,
and a cyclical component that fluctuates around the trend and is an ARMA(p,max\{p,q\}) process.

This function can be used in the simplest way by specifying \code{bnfilter(x,p,q)}, which first estimates
the parameters of an ARMA model for \code{diff(x)} with the \code{\link{arima}} function and then computes
the associated BN decomposition. Otherwise by passing \code{bnfilter(x,phi,theta,drift)} one can compute 
the BN decomposition for the exact set of parameters passed, without any new estimation. The two methods
be combined (e.g. passing \code{bnfilter(x,p,theta)} to set the MA parameters but estimate the AR ones)
}
\value{
  A "\code{mFilter}" object (see \code{\link{mFilter}}).
}
\references{
Beveridge, S. and Nelson, C., R. (1981). A new approach to decomposition of economic time series into permanent and transitory components
with particular attention to measurement of the ‘business cycle’. \emph{Journal of Monetary Economics},
7(2), 151-174.

Morley, J. C. (2002). A state–space approach to calculating the Beveridge–Nelson decomposition.
\emph{Economics Letters}, 75, 123-127
}
\author{
Matteo Poli
}
%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
\code{\link{mFilter}}, \code{\link{bwfilter}}, \code{\link{cffilter}},
  \code{\link{bkfilter}}, \code{\link{trfilter}}
}
\examples{
## library(mFilter)

data(unemp)

## example usage
unemp.bn<-bnfilter(unemp,2,2)
summary(unemp.bn)
plot(unemp.bn)

## custom parameters
unemp.bn1<-bnfilter(unemp,phi=0.47,theta=0.15)
summary(unemp.bn1)
plot(unemp.bn1)

## A mix of fixed and estimated parameters
## Here phi_2 will be estimated
unemp.bn2<-bnfilter(unemp,p=2,q=1,phi=0.78,drift=0)
summary(unemp.bn2)
plot(unemp.bn2)
{
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory (show via RShowDoc("KEYWORDS")):
% \keyword{ ~kwd1 }
% \keyword{ ~kwd2 }
% Use only one keyword per line.
% For non-standard keywords, use \concept instead of \keyword:
% \concept{ ~cpt1 }
% \concept{ ~cpt2 }
% Use only one concept per line.
