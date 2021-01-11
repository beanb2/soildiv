#' Function to mask pixel count dataframe to exclude certain pixel types.
#'
#' @param df A dataframe of pixel counts, must be obtained from
#'   \code{\link[soildiv]{new_class}}.
#' @param mask An integer vector of pixel numbers that should be ignored in
#'   the dataframe.
#' @param id_var The (unquoted) name of the lone id variable in df. If NULL,
#'   then the ID variable is not removed from the returned dataframe.
#'
#' @return A dataframe including only pixel counts for pixel types not
#'   included in the mask.
#'
#' @details Note that the selection criteria assumes that column names have
#'   the form "Category_<integer>". This is why it is essential to use
#'   the \code{\link[soildiv]{new_class}} prior to masking to avoid the
#'   mischaracterization of column names with leading zeros
#'   (i.e. Category_001, Category_002 etc.).
#'
#' @export
div_mask <- function(df, mask, id_var = NULL){

  # Setting id_var to null makes retains the ID variable.
  check_sub <- df %>%
    dplyr::select(-tidyselect::num_range("Category_", mask),
                  -{{id_var}})

  return(check_sub)
}
