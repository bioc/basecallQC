% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plots.R
\docType{methods}
\name{demuxBarplot}
\alias{demuxBarplot}
\alias{demuxBarplot.basecallQC}
\alias{demuxBarplot,baseCallQC-method}
\alias{demuxBarplot,basecallQC-method}
\alias{demuxBarplot,list-method}
\title{Barplot of Illumina demultiplexing statistics.}
\usage{
\S4method{demuxBarplot}{baseCallQC}(object,groupBy)

\S4method{demuxBarplot}{basecallQC}(object = "basecallQC",
  groupBy = c("Lane"))

\S4method{demuxBarplot}{list}(object = "basecallQC", groupBy = c("Lane"))
}
\arguments{
\item{object}{A  basecallQC object or list from call to demultiplexMetrics()}

\item{groupBy}{Character vector of how data is grouped for plotting. Should be either "Project","Sample" or "Lane".}
}
\value{
A ggplot2 object.
}
\description{
Produces a barplot of demultiplexing statistics of reads with perfect/mismatched barcode.
}
\examples{
fileLocations <- system.file("extdata",package="basecallQC")
runXML <- dir(fileLocations,pattern="runParameters.xml",full.names=TRUE)
config <- dir(fileLocations,pattern="config.ini",full.names=TRUE)
sampleSheet <- dir(fileLocations,pattern="*\\\\.csv",full.names=TRUE)
outDir <- file.path(fileLocations,"Runs/161105_D00467_0205_AC9L0AANXX/C9L0AANXX/")
bcl2fastqparams <- BCL2FastQparams(runXML,config,runDir=getwd(),outDir,verbose=FALSE)
bclQC <- basecallQC(bcl2fastqparams,RunMetaData=NULL,sampleSheet)
plot <- demuxBarplot(bclQC)
}
\author{
Thomas Carroll and Marian Dore
}
