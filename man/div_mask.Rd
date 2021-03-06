% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/div_mask.R
\name{div_mask}
\alias{div_mask}
\title{Function to mask pixel count dataframe to exclude certain pixel types.}
\usage{
div_mask(df, mask, id_var = NULL)
}
\arguments{
\item{df}{A dataframe of pixel counts, must be obtained from
\code{\link[soildiv]{new_class}}.}

\item{mask}{An integer vector of pixel numbers that should be ignored in
the dataframe.}

\item{id_var}{The (unquoted) name of the lone id variable in df. If NULL,
then the ID variable is not removed from the returned dataframe.}
}
\value{
A dataframe including only pixel counts for pixel types not
  included in the mask.
}
\description{
Function to mask pixel count dataframe to exclude certain pixel types.
}
\details{
Note that the selection criteria assumes that column names have
  the form "Category_<integer>". This is why it is essential to use
  the \code{\link[soildiv]{new_class}} prior to masking to avoid the
  mischaracterization of column names with leading zeros
  (i.e. Category_001, Category_002 etc.).
}
