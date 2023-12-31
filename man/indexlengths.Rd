% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/allMethods.R
\docType{methods}
\name{indexlengths}
\alias{indexlengths}
\alias{indexlengths.bcl2fastqparams}
\alias{indexlengths,BCL2FastQparams-method,}
\alias{indexlengths,BCL2FastQparams-method}
\title{Index lengths}
\usage{
\S4method{indexlengths}{BCL2FastQparams}(object)

\S4method{indexlengths}{BCL2FastQparams}(object = "BCL2FastQparams")
}
\arguments{
\item{object}{A BCL2FastQparams object}
}
\value{
Index lengths as defined runParameters.xml.
}
\description{
Index lengths as defined by runParameters.xml
}
\examples{
fileLocations <- system.file("extdata",package="basecallQC")
runXML <- dir(fileLocations,pattern="runParameters.xml",full.names=TRUE)
config <- dir(fileLocations,pattern="config.ini",full.names=TRUE)
bcl2fastqparams <- BCL2FastQparams(runXML,config,runDir=getwd(),verbose=FALSE)
indexlength <- indexlengths(bcl2fastqparams)
}
\author{
Thomas Carroll
}
