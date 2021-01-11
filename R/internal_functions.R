#' Random seed generator
#' @description
#' #' Cool way to set a random seed in a c++ function using R as the base.
#' Obtained from:
#' https://www.r-bloggers.com/2018/09/using-rs-set-seed-to-set-seeds-for-use-in-c-c-including-rcpp/
get_seed <- function() {
  sample.int(.Machine$integer.max, 1)
}


