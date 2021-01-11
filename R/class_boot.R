#' Bootstrap simulation function.
#'
#' @description The function is a wrapper to the cpp_boot function that
#'   eliminates the need for the user to generate random nunber seeds
#'   in c++. Note that the random seed generator get_seed() is an
#'   internal function in this package that is not available to
#'   the user but is described at:
#'   - https://www.r-bloggers.com/2018/09/using-rs-set-seed-to-set-seeds-for-use-in-c-c-including-rcpp/
#'
#' @param x An integer vector of length q representing crop pixel counts.
#' @param n The desired number of boostrap simulations.
#'
#' @return A n by q matrix of simulated pixel counts where the sum of
#'   pixel counts in each row is identical.
#'
#' @export
resamp <- function(x, n){

  # Tbl rows get handled weird sometimes. Recast as an integer vector.
  x <- as.integer(x)

  if(sum(x > 0) < 2){
    return(matrix(x, ncol = length(x), nrow = n, byrow = TRUE))
  }else{
    # Note that get_seed() is an internal function to this package. Details
    # of the implementation are found in cpp_boot.cpp.
    return(resamp_cpp(x, n, get_seed()))
  }
}


#' Parallel wrapper to bootstrap function.
#'
#'
#' @param df A dataframe containing only pixel counts (no ID variable).
#' @param n The desired number of bootstrap simulations.
#' @param cores The desired number of cores. Anything greater than one
#'   requires parallel processing capability using the doParallel package.
#'   It is the users responsbility to know how many cores they have available
#'   for the computations.
#'
#' @return A list of matrices, one matrix per row of df, with bootstrap
#'   pixel counts.
#'
#' @export
resamp_wrapper <- function(df, n, cores = 1){
  iter = nrow(df)

  # Determine whether or not to use parallel processing.
  if(cores <= 1){
    final <- vector("list", iter)
    for(i in 1:iter){
      final[[i]] <- resamp(df[i, ], n)
    }
  }else{
    `%dopar%` <- foreach::`%dopar%`
    cl <- parallel::makeCluster(cores)
    doParallel::registerDoParallel(cl)

    # If this function fails, we need to make sure to close the parallel connection.
    final <- try({foreach::foreach(i = 1:iter, .export = c("resamp")) %dopar%
        resamp(df[i, ], n)})

    if(inherits(final, "try-error")){
      parallel::stopCluster(cl) # Close the parallel connection.
      stop("Parallel excecution failed.")
    }

    parallel::stopCluster(cl)
  }

  return(final)
}

