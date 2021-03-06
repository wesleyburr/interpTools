% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/simXt.R
\name{simXt}
\alias{simXt}
\title{Simulate X_t}
\usage{
simXt(D, n = 1000, vary = "all", numTrend = 0,
  trendType = "polynomial", numFreq = 20, bandwidth = NULL, p = 0,
  q = 0, fix, snr = 1.5)
}
\arguments{
\item{D}{The number of datasets to generate.}

\item{n}{The desired length of each complete time series.}

\item{vary}{"Mt", "Tt", "Wt". A character string specifying which component of Xt to vary. Other components are held constant.}

\item{numTrend}{If 'vary != Mt', this is the number of terms to include. Value represents the maximum degree of the mean component; all lower order terms included.}

\item{trendType}{If 'vary != Mt', this is the type of trends to include in the mean component.}

\item{numFreq}{If 'vary != Tt', this is the number of sinusoids to generate in the trend component.}

\item{bandwidth}{If 'vary != Tt', this value is plugged into a negative exponent (base 10) and defines some interval in which to sample frequencies for the trend component. If specified, 'bandwidth' must be at least -log10(1/numFreq). If unspecified, frequencies are distributed ~Uniform(a=0,b=1).}

\item{p}{If 'fix != p', this is the AR order of the noise component.}

\item{q}{If 'fix != q', this is the MA order of the noise component.}

\item{fix}{Which order variable in ARMA(p,q) to fix if 'vary = Wt' (must be either "p" or "q").}

\item{snr}{Specify the signal-to-noise ratio.}
}
\description{
Function to simulate X_t. The component that is selected to vary will hold all required variables constant: \cr\cr
For vary = "Mt", only 'numTrend' is subject to vary. \cr
For vary = "Tt", only 'numFreq' is subject to vary. \cr
For vary = "Wt", order variables 'p' or 'q' are subject to vary depending on the value of 'fix', which must also be specified.
}
\examples{
# Initializing basic parameters
D = 5
n=1000
t=0:(n-1)

# Vary Mt
simData <- simXt(D=D, n=n, vary = "Mt", bandwidth = 3, numFreq = 30, 
                 trendType = "polynomial", snr = 1.5)

# Vary Tt
simData <- simXt(D=D, n=n, vary = "Tt", bandwidth = 3, numTrend = 0, 
                 trendType = "polynomial", snr = 1.5)

# Vary Wt, p fixed
simData <- simXt(D=D, n=n, vary = "Wt", bandwidth = 3, numFreq = 20, 
                 numTrend = 0, trendType = "polynomial", p = 0, fix = "p", snr = 1.5)

# Vary Wt, q fixed
simData <- simXt(D=D, n=n, vary = "Wt", bandwidth = 3, numFreq = 20, 
                 numTrend = 10, trendType = "polynomial", q = 0, fix = "q", snr = 1.5)

# Creating list object for one of the above variations
sets <- numeric(D)
for(d in 1:(D-1)){
 sets[d] <- paste("D",d,"=simData$Xt[[",d,"]],",sep="")
}
sets[D] <- paste("D",D,"=simData$Xt[[",D,"]]",sep="")
list_call <- paste("list(",paste(sets,collapse=""),")")

OriginalData = eval(parse(text=list_call))

}
