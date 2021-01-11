#' @exportPattern "^[[:alpha:]]+"
#'
#' @importFrom Rcpp evalCpp
#' @importFrom parallel makeCluster
#' @importFrom parallel stopCluster
#' @importFrom doParallel registerDoParallel
#' @importFrom foreach `%dopar%`
#' @importFrom foreach foreach
#'
#' @useDynLib soildiv, .registration = TRUE
NULL
