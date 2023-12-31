% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/allClasses.R
\name{baseCallMetrics}
\alias{baseCallMetrics}
\title{Gather basecalling metrics from a Run (using Run's ConversionStats.xml file).}
\usage{
baseCallMetrics(bcl2fastqparams)
}
\arguments{
\item{bcl2fastqparams}{A BCL2FastQparams object as created by BCL2FastQparams() constructor.}
}
\value{
A list of length two containing the full basecalling metrics from a Run (using Run's ConversionStats.xml file). Contains an unsummarised data.frame and basecalling metrics summarised to Sample, Lane, Sample by lane, and Sample by Lane and Tile.
}
\description{
Gather basecalling metrics from a Run (using Run's ConversionStats.xml file).
}
\examples{
fileLocations <- system.file("extdata",package="basecallQC")
runXML <- dir(fileLocations,pattern="runParameters.xml",full.names=TRUE)
config <- dir(fileLocations,pattern="config.ini",full.names=TRUE)
sampleSheet <- dir(fileLocations,pattern="*\\\\.csv",full.names=TRUE)
outDir <- file.path(fileLocations,"Runs/161105_D00467_0205_AC9L0AANXX/C9L0AANXX/")
bcl2fastqparams <- BCL2FastQparams(runXML,config,runDir=getwd(),outDir,verbose=FALSE)
convMetrics <- baseCallMetrics(bcl2fastqparams)
}
