\name{unemp}
\alias{unemp}
\title{US Quarterly Unemployment Series}

\usage{
data(unemp)
}

\description{
  Quarterly US unemployment series for 1959.1 to 2000.4.

  \emph{number of observations} :  168

  \emph{observation} :  country

  \emph{country} :  United States
}

\format{A time series containing :
  \describe{
    \item{unemp}{unemployment rate (average of months in quarter)       }
  }
}

\source{
  Bureau of Labor Statistics, OECD, Federal Reserve.
}

\references{
  Stock, James H.  and  Mark W.  Watson (2003) \emph{Introduction to
  Econometrics}, Addison-Wesley Educational Publishers, chapter 12 and 14.
}

\author{
  Mehmet Balcilar, \email{mehmet@mbalcilar.net}
}

\examples{
## library(mFilter)

data(unemp)

unemp.hp <- mFilter(unemp,filter="HP")  # Hodrick-Prescott filter
unemp.bk <- mFilter(unemp,filter="BK")  # Baxter-King filter
unemp.cf <- mFilter(unemp,filter="CF")  # Christiano-Fitzgerald filter

opar <- par(no.readonly=TRUE)
par(mfrow=c(2,1),mar=c(3,3,2,1))
plot(unemp,main="Unemployment Series & Estimated Trend",col=1,ylab="")
lines(unemp.hp$trend,col=2)
lines(unemp.bk$trend,col=3)
lines(unemp.cf$trend,col=4)
legend("topleft",legend=c("series", "HP","BK","CF"),col=1:4,
       lty=rep(1,4),ncol=2)

plot(unemp.hp$cycle,main="Estimated Cyclical Component",col=2,
     ylim=c(-2,2),ylab="")
lines(unemp.bk$cycle,col=3)
lines(unemp.cf$cycle,col=4)
legend("topleft",legend=c("HP","BK","CF"),col=2:4,lty=rep(1,3),ncol=2)
par(opar)
}

\keyword{datasets}
