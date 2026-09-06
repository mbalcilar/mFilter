### Beveridge Nelson Filter

bnfilter<-function(x,p=NULL,q=NULL,phi=NULL,theta=NULL,drift=NULL){
  
  x.name<-deparse(substitute(x))
  n<-length(x)
  d<-diff(x)
  
  if (is.null(p)) {p <- if (!is.null(phi)) length(phi) else 0}
  if (is.null(q)) {q <- if (!is.null(theta)) length(theta) else 0}
  if (p+q==0) stop("Either p or q must be different from 0")
  model<- paste("ARMA(",as.character(p),",",as.character(q),")")
  
  # Coercing phi and theta to correct lengths
  ar_part <- rep(NA, p)
  ma_part <- rep(NA, q)
  
  if (!is.null(phi)) {
    if (length(phi) >= p & p>0) {
      ar_part <- phi[1:p]
    } 
    else if (length(phi) < p) {
      ar_part <- c(phi, rep(NA, p - length(phi)))
    }
  } 
  
  if (!is.null(theta)) {
    if (length(theta) >= q & q>0) {
      ma_part <- theta[1:q]
    } else if (length(theta) < q) {
      ma_part <- c(theta, rep(NA, q - length(theta)))
    }
  } 
  
  # Defining ARIMA order, fixed vector and taking care of additional parameters
  order <- c(p, 0, q)
  fixed <- c(ar_part, ma_part, if (!is.null(drift)) drift else NA)
  trans<-FALSE
  if (all(is.na(fixed))) {
    fixed <- NULL
    trans <- TRUE
  }
  
  # Model in differences, so that I can  automatically demean with arima
  arima_model <- arima(d, order = order, include.mean = TRUE, 
                       fixed= fixed, method="CSS-ML",transform.pars = trans)
  drift<-coef(arima_model)["intercept"]
  residuals <- arima_model$residuals
  phi <- arima_model$model$phi
  theta <- arima_model$model$theta
  if ( p%%1!=0 || q%%1!=0) stop("p or q must be integers")
  if (p==0) phi<-0
  if (q==0) theta<-0
  psi1<-(1+sum(theta))/(1-sum(phi))
  p<-length(phi)
  q<-length(theta)
  
  phrase <- paste("with parameters Phi = (", paste(round(phi, 4), collapse = ", "),
                  "), ","Theta = (", paste(round(theta, 4), collapse = ", "), ")",
                  " and drift = ", round(drift, 4), sep = ""
                 )
  
  # Compute filter matrix
  F_m<-diag(p+q-1)
  F_m[p,p]<-0
  F_m<-cbind(F_m,numeric(p+q-1))
  F_m<-rbind(c(phi,theta),F_m)
  I<-diag(p+q)
  filter_matrix<-F_m%*%solve(I-F_m)
  
  # Compute trend using filter matrix
  Trend<-rep(NA,n)
  for (i in max(p,q):(n-1) ){
    d_star<-c(d[i:(i+1-p)]-drift,residuals[i:(i+1-q)])
    Trend[i+1]<- x[i+1]+(filter_matrix%*%d_star)[1]
  }

  Cycle<-x-Trend
  
  if(is.ts(x))
  {
    tsp.x<-tsp(x)
    Cycle<-ts(Cycle,start=tsp.x[1],frequency=tsp.x[3])
    Trend<-ts(Trend,start=tsp.x[1],frequency=tsp.x[3])
  }
  res<-list(cycle=Cycle,trend=Trend,fmatrix=filter_matrix,title = "Beveridge Nelson Filter",
            xname=x.name, call=as.call(match.call()),type=paste("Based on an",model,
                                                                "model for the differenced series",phrase),
            phi=phi,theta=theta,method="bnfilter",x=x)
  return(structure(res,class="mFilter"))
}