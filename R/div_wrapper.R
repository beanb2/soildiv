#' Function to calculate diversity indices.
#'
#' @description The function is a wrapper to \code{\link[vegan]{diversity}}
#'   that is specifically adapted to handle the output of
#'   \code{\link[soildiv]{new_class}}.
#'
#' @param df The input dataframe obtained from \code{\link[soildiv]{new_class}}.
#' @param mask An integer vector of pixel types that should be ignored in the
#'   diversity estimates.
#' @param id_var The name of the lone ID varable (the rest should be
#'   pixel counts), should be in quotations.
#' @param index A value of "simpson", "shannon", "richness" or "count"
#' (i.e. pixel count).
#' @param ... Additional arguments to \code{\link[vegan]{diversity}} (only
#'   relevant if index = "simpson" or "shannon")
#'
#' @export
div_wrapper <- function(df, mask, id_var, index = "shannon", ...){

  # Only consider pixel counts not in the mask.
  check_sub <- div_mask(df, mask, {{id_var}})

  # If richness is desired, bypass the vegan::diversity function
  # Same thing if a simple pixel count is desired.
  if(index == "richness"){
    div <- apply(check_sub, 1, function(x) sum(x > 0))
  }else if(index == "count"){
    div <- apply(check_sub, 1, sum)
  }else{
    div <- vegan::diversity(check_sub, index = index, ...)
  }

  return(div)
}
