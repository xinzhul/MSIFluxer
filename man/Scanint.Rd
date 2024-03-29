% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/Scanint.R
\name{Scanint}
\alias{Scanint}
\title{Selection of ions with sufficient imaging signals}
\usage{
Scanint(df, Intensity = 100, num = 2)
}
\arguments{
\item{df}{The table generated by the first step.}

\item{Intensity}{The minimum counts required for ions to be imaged.}

\item{num}{The number of samples reaching the set imaging counts threshold.}
}
\value{
An updated table.
}
\description{
If the intensity of the 12C-metabolite ion is found to be less
    than the set minimum count in a specific number of samples, this ion and
    its corresponding isotopologue group will be removed.
}
\examples{
Scanint(Target,Intensity=100, num=2)
}
