#' Simulate W_t
#' 
#' Function to simulate W_t: the noise component of X_t. Defaults to white noise. 
#' @param n The length of the output series 
#' @param p The AR order
#' @param q The MA order
#' @param var The variance of the stochastic process

simWt <- function(n = 1000, p = 0, q = 0, var = 1){
  
  if(!is.numeric(n)) stop("n must be a numeric quantity >=10.")
  if(!is.numeric(p)) stop("p must be a numeric quantity >=0.")
  if(!is.numeric(q)) stop("q must be a numeric quantity >=0.")
  if(!is.numeric(var)) stop("var must be a numeric quantity >0.")
    
    
  Wt_list <- list()
  stopifnot(p >= 0,q >= 0,n >= 10, n %% 1 == 0, var > 0)
  
  if(p > 0){
    repeat{
      ar<-numeric(p)
      for(i in 1:p){
        ar[i] <- c(sample(seq(-p,p,length.out=1000),1))
      }
      minroots <- min(Mod(polyroot(c(1, -ar))))
      if(minroots > 1){
        break
      }
    }
    
    if(q>0){
      ma <- c(sample(seq(0,1,length.out=1000),q))
      model <- list(order = c(p,0,q), ar = ar, ma = ma)
    }
    
    else if(q == 0){
      model <- list(order = c(p,0,q), ar = ar)
    }
  }
  
  else if(p == 0){
    if(q==0){
      model <- list(order = c(p,0,q))
    }
    
    else if(q > 0){
      ma <- c(sample(seq(0,1,length.out=1000),q))
      model <- list(order = c(p,0,q), ma = ma)
    }
  }
  
  Wt_list$value = arima.sim(model, n = n, sd = sqrt(var))
  Wt_list$p = p
  Wt_list$q = q
  return(Wt_list)
}
