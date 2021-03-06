% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/RcppExports.R
\name{CryptUnprotectData}
\alias{CryptUnprotectData}
\title{A wrapper for the Windows DPAPI function CryptUnprotectData()}
\usage{
CryptUnprotectData(pwd, salt)
}
\arguments{
\item{pwd}{The raw bytes of the encrypted password}

\item{salt}{The raw bytes of the salt used when the password was encrypted}
}
\description{
This function is intended to be an internal helper file for the package.
Both parameters are currently necessary, and bust be between 1 and 256 bytes
in length. The salt should be the one used to encrypt pwd in the first place
}
