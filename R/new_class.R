#' Function to reclassify pixel counts given a pixel matching file.
#'
#' @param df A dataframe of pixel counts with pixel counts provided in the
#'   columns with a lone id variable. Similar to:
#'   https://www.nass.usda.gov/Research_and_Science/Cropland/docs/County_Pixel_Count.zip
#' @param rcl A dataframe of pixel reclassications. The original crop
#'   classification column. If NULL, the function simply renames the
#'   column names to eliminate any leading zeros in the pixel numbers
#'   (which is critical for the div_mask function).
#' @param GEOID The (unquoted) name of the ID column in df.
#' @param Crop The (unquoted) name for the original crop types in rcl.
#' @param Count The (unquoted) desired variable name describing the pixel counts.
#' @param New_Crop The (unquoted) variable name for new crop classifications as
#'   specified in rcl.
#'
#' @return A dataframe of new pixel counts given the provided rcl dataframe.
#'
#'
#' @export
new_class <- function(df, rcl, GEOID, Crop, Count, New_Crop){
  # Steps of the function:
  # 1 - Recast the crop counts into long format.
  # 2 - Recast the original column names as integer values
  # 3 - Join the newly cast crop data with the reclassification table
  #     (Assumes that rcl has the same column name for the crop data)
  # 4 - Ensure any unspecified values in the reclass file get
  #     carried over in the join.
  # 5 - Filter out any zero-valued classifications (i.e. no data)
  # 6 - Reassign the New Crop indicators using the original variable name
  # 7 - Re-sum the pixel counts using the new classifications.
  # 8 - Rename the categories and pivot back to original form.
  df <- df %>%
    tidyr::pivot_longer(!{{GEOID}},  deparse(substitute(Crop)),
                        values_to =  deparse(substitute(Count))) %>% # 1
    dplyr::mutate({{Crop}} := as.integer(gsub("Category_", replacement = "",
                                              {{Crop}}))) # 2

  # If no reclassification is supplied, simply rename the column names to get
  # rid of leading zeros (helps in the div_wrapper function)
  if(is.null(rcl)){
    df <- df %>%
      dplyr::select({{GEOID}}, {{Crop}}, {{Count}}) %>%
      dplyr::mutate({{Crop}} := paste0("Category_", {{Crop}})) %>% # 8
      tidyr::pivot_wider(id_cols = {{GEOID}}, names_from = {{Crop}},
                         values_from = {{Count}})

    return(df)
  }

  df <- df %>%
    dplyr::left_join(rcl %>% dplyr::select({{Crop}}, {{New_Crop}}),
                     deparse(substitute(Crop))) %>% # 3
    dplyr::mutate({{New_Crop}} := dplyr::if_else(is.na({{New_Crop}}),
                                                 {{Crop}}, {{New_Crop}})) %>% # 4
    dplyr::filter({{New_Crop}} > 0) %>% # 5
    dplyr::select({{GEOID}}, {{Crop}} := {{New_Crop}}, {{Count}}) %>% # 6
    dplyr::arrange({{Crop}}) %>%
    dplyr::group_by({{GEOID}}, {{Crop}}) %>%
    dplyr::summarise({{Count}} := sum({{Count}})) %>% # 7
    dplyr::ungroup() %>%
    dplyr::mutate({{Crop}} := paste0("Category_", {{Crop}})) %>% # 8
    tidyr::pivot_wider(id_cols = {{GEOID}}, names_from = {{Crop}},
                       values_from = {{Count}})

  return(df)
}
#=============================================================================
