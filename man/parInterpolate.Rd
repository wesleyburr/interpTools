% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/parInterpolate.R
\name{parInterpolate}
\alias{parInterpolate}
\title{Parallel Interpolation}
\usage{
parInterpolate(GappyList, methods = NULL, FUN_CALL = NULL,
  numCores = detectCores(), parallel = "k")
}
\arguments{
\item{GappyList}{A list of dimension P x G x K containing gappy time series.}

\item{methods}{vector of IDs for selected interpolation methods, where m = 1,...,M}

\item{FUN_CALL}{User specified interpolation function(s) to be applied to GappyList. Must be a character string in the form: `function_name(args = ..., x = `.}

\item{numCores}{How many CPU cores to use. The default is to use the total number of available cores, as determined by `detectCores()`.}

\item{parallel}{Over which index to parallelize. Possible choices: "p","g","k"}
}
\description{
Function to perform interpolation on gappy series in parallel using user-specified and/or user-defined interpolation methods. Parallelization occurs over the K level. \cr\cr
}
\details{
Below is a list of the built-in interpolators:\cr
\enumerate{
\item \code{NN}; Nearest Neighbor
\item \code{LI}; Linear Interpolation
\item \code{NCS}; Natural Cubic Spline
\item \code{FMM}; Cubic Spline
\item \code{HCS}; Hermite Cubic Spline
\item \code{SI}; Stineman Interpolation
\item \code{KAF}; Kalman ARIMA
\item \code{KSF}; Kalman StructTS
\item \code{LOCF}; Last Observation Carried Forward
\item \code{NOCB}; Next Observation Carried Backward
\item \code{SMA}; Simple Moving Average
\item \code{LWMA}; Linear Weighted Moving Average
\item \code{EWMA}; Exponential Weighted Moving Average
\item \code{RMEA}; Replace with Mean
\item \code{RMED}; Replace with Median
\item \code{RMOD}; Replace with Mode
\item \code{RRND}; Replace with Random
\item \code{HWI}; Hybrid Wiener Interpolato
}
}
\examples{
# Built-in interpolators
methods <- c(17,5) # Replace with Random, Hermite Cubic Spline

# User-defined functions to pass to FUN_CALL
## Toy function 1: Convert each value of x to its index position
plus <- function(x){
vec <- numeric(length(x))
for(i in 1:length(vec)){
 vec[i] <- i
}
return(vec)
}

## Toy function 2: Convert each value of x to its negative index position
minus <- function(x){
 vec <- numeric(length(x))
 for(i in 1:length(vec)){
   vec[i] <- -i
 }
 return(vec)
}

FUN_CALL <- c("plus(","minus(")

IntData <- list()

for(d in 1:length(OriginalData)){
 IntData[[d]] <- parInterpolate(GappyList = GappyData[[d]], methods = methods, FUN_CALL = FUN_CALL)
}
names(IntData) <- names(OriginalData)
}
