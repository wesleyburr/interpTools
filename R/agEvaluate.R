#' Aggregate the Performance Matrices of Multiple Interpolations
#' 
#' Function to aggregate the set of performance matrices, by criterion, using sample statistics of the sampling distribution across K. Resulting object is of class \code{'agEvaluate'}.
#'  
#' @param pmats \code{list}; A nested list of dimension D x M x P x G x K (result of \code{performance.R}), where the terminal node is a performance matrix.
#' 
#' @details The statistics provided in the output are as follows:
#' \itemize{
#' \item \code{(mean)}; mean
#' \item \code{(sd)}; standard deviation 
#' \item \code{(q0)}; minimum (0\% quantile)
#' \item \code{(q2.5)}; 2.5\% quantile
#' \item \code{(q25)}; 25\% quantile
#' \item \code{(median)}; median (50\% quantile)
#' \item \code{(q75)}; 75\% quantile
#' \item \code{(q97.5)}; 97.5\% quantile
#' \item \code{(q100)}; maximum (100\% quantile)
#' \item \code{(iqr)}; IQR (75\% quantile - 25\% quantile)
#' \item \code{(skewness)}; skewness
#' \item \code{(dip)}; p-value of dip test for unimodality (see \code{?dip} for details)
#' }

agEvaluate <- function(pmats){
  
  if(class(pmats) != "pmat") stop("'pmats' object must be of class 'pmat'. Use performance() to generate such objects.")

    skew <- function(x, na.rm = TRUE){
    stopifnot(is.numeric(x))
    
    if(na.rm){
      x <- x[!is.na(x)]
    sk <- (sum((x-mean(x))^3)/(length(x)*sd(x)^3))
    }
    
    else if(!na.rm){
    sk <- (sum((x-mean(x))^3)/(length(x)*sd(x)^3))
    }
    
    return(sk)
  }

  D <- length(pmats)
  M <- length(pmats[[1]])
  P <- length(pmats[[1]][[1]])
  G <- length(pmats[[1]][[1]][[1]])
  K <- length(pmats[[1]][[1]][[1]][[1]])
  C <- length(pmats[[1]][[1]][[1]][[1]][[1]])
  
  dataset <- 1:D
  
  # Initializing nested list object
  
  Evaluation <- lapply(Evaluation <- vector(mode = 'list', D),function(x)
    lapply(Evaluation <- vector(mode = 'list', P),function(x) 
      lapply(Evaluation <- vector(mode = 'list', G),function(x) 
        x<-vector(mode='list',M))))
  
  prop_vec_names <- numeric(P)
  gap_vec_names <- numeric(G)
  method_names <- character(M)
  
  prop_vec <- as.numeric(gsub("p","",names(pmats[[1]][[1]])))
  gap_vec <- as.numeric(gsub("g","",names(pmats[[1]][[1]][[1]])))
  
  
  for(d in 1:D){
    for(p in 1:P){
      prop_vec_names[p] <- c(paste("p", prop_vec[p],sep="")) # vector of names
      for(g in 1:G){
        gap_vec_names[g] <- c(paste("g", gap_vec[g],sep="")) # vector of names
        for(m in 1:M){
          method_names[m] <- names(pmats[[1]])[m]
          
            # compute the mean and distribution of the performance criteria in each (d,m,p,g) specification across all k pairs of (x,X) and 
            # store results in a list of data frames
          
            quantiles <- apply(sapply(pmats[[d]][[m]][[p]][[g]],unlist),1, 
                               FUN=function(x) quantile(x, probs = c(0, 0.025, 0.25, 0.75, 0.975, 1.0), na.rm = TRUE))
            
            Evaluation[[d]][[p]][[g]][[m]] <- data.frame(
              
              mean = rowMeans(sapply(pmats[[d]][[m]][[p]][[g]],unlist), na.rm = TRUE),
              
              sd = apply(sapply(pmats[[d]][[m]][[p]][[g]],unlist),1,sd, na.rm = TRUE),
              
              #q0 = apply(sapply(pmats[[d]][[m]][[p]][[g]],unlist),1,quantile, na.rm = TRUE)["0%",],
              q0 = quantiles["0%",],
              
              #q2.5 = apply(sapply(pmats[[d]][[m]][[p]][[g]],unlist),1, 
                           #FUN=function(x) quantile(x, probs = c(0.025,0.975), na.rm = TRUE))["2.5%",],
              q2.5 = quantiles["2.5%",],
              
              #q25 = apply(sapply(pmats[[d]][[m]][[p]][[g]],unlist),1,quantile, na.rm = TRUE)["25%",],
              q25 = quantiles["25%",],
              
              median = apply(sapply(pmats[[d]][[m]][[p]][[g]],unlist),1,median, na.rm = TRUE),
              
              #q75 = apply(sapply(pmats[[d]][[m]][[p]][[g]],unlist),1,quantile, na.rm = TRUE)["75%",],
              q75 = quantiles["75%",],
              
              #q97.5 = apply(sapply(pmats[[d]][[m]][[p]][[g]],unlist),1, 
                            #FUN=function(x) quantile(x, probs = c(0.025,0.975), na.rm = TRUE))["97.5%",],
              q97.5 = quantiles["97.5%",],
              
              #q100 = apply(sapply(pmats[[d]][[m]][[p]][[g]],unlist),1,quantile, na.rm = TRUE)["100%",],
              q100 = quantiles["100%",],
              
              iqr = quantiles["75%",] - quantiles["25%",],
              
              skewness = apply(sapply(pmats[[d]][[m]][[p]][[g]],unlist),1,skew), 
              
              dip = apply(sapply(pmats[[d]][[m]][[p]][[g]],unlist),1,
                          FUN = function(x){dip.test(x,simulate.p.value = TRUE)$p.value
                            
              }),
              
              gap_width = c(rep(gap_vec[g], C)),
              prop_missing = c(rep(prop_vec[p],C)),
              dataset = c(rep(dataset[d],C)), 
              method = rep(method_names[m],C) 
            )  
          
            
        }
        names(Evaluation[[d]][[p]][[g]]) <- method_names 
      }
      names(Evaluation[[d]][[p]]) <- gap_vec_names 
    }
    names(Evaluation[[d]]) <- prop_vec_names 
  }
  names(Evaluation) <- names(pmats)
  
  class(Evaluation) <- "agEvaluate"
    return(Evaluation)

} 
