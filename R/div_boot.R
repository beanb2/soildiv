#' Function to summarize the bootstrapped diversity indices.
#'
#' @description The function is a wrapper to \code{\link[vegan]{diversity}}
#'   that is specifically adapted to handle the output of
#'   \code{\link[soildiv]{resamp_wrapper}}.
#'
#' @param dfl A list of pixel_boot matrices obtained from
#'   \code{\link[soildiv]{resamp_wrapper}}.
#' @param index A value of "simpson", "shannon", "richness" or "count"
#' (i.e. pixel count).
#' @param ... Additional arguments to \code{\link[vegan]{diversity}} (only
#'   relevant if index = "simpson" or "shannon")
#'
#' @export
div_boot <- function(dfl, index = "shannon", progress = TRUE, ...){

  # Determine the number of matrices in the list.
  n <- length(dfl)

  if(progress){
    pb <- txtProgressBar(min = 0, max = n, style = 3)
  }

  # Loop through each list object and obtain the mean and standard deviation
  # of the desired list object.
  div_mat <- matrix(0, nrow = n, ncol = 2)

  # If richness is desired, bypass the vegan::diversity function
  # Same thing if a simple pixel count is desired.
  for(i in 1:n){
    if(progress){
      setTxtProgressBar(pb, i)
    }

    if(index == "richness"){
      div <- apply(dfl[[i]], 1, function(x) sum(x > 0))
    }else if(index == "count"){
      div <- apply(dfl[[i]], 1, sum)
    }else{
      div <- vegan::diversity(dfl[[i]], index = index, ...)
    }
    div_mat[i, ] <- c(mean(div), sd(div))
  }

  return(div_mat)
}
