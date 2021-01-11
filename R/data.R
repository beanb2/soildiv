#' Pixel counts by United State's County
#'
#' A dataset of pixel counts of land uses as provided by:
#'   https://www.nass.usda.gov/Research_and_Science/Cropland/docs/County_Pixel_Count.zip
#'
#' @format A data frame with 37,366 rows and 130 columns.
#'
#'   \describe{
#'   \item{GEOID}{The unique county FIPS identifier.}
#'   \item{YEAR}{The year of crops for which classifications are made 2007-2019.}
#'   \item{Category_x}{The number of pixels in each county/year associated with
#'     crop type x.}
#'   }
"soil_counts"

#' Pixel Reclassification Attempt 1.
#'
#' These pixel reclassifications treat double cropping systems as their own
#'   crop type.
#'
#' @format A data frame with 134 rows and 4 columns.
#'
#'   \describe{
#'   \item{Crop}{The original integer crop identification numbers.}
#'   \item{Description}{The description associated with the identification
#'     number.}
#'   \item{New_Crop}{The proposed reclassification.}
#'   \item{New_Description}{The new description of the reclassified crop.}
#'   }
"reclass"

#' Pixel Reclassification Attempt 2.
#'
#' These pixel reclassifications double count pixels associated with double
#'   cropping systems: one count in each of the individual cropping systems.
#'
#' @format A data frame with 151 rows and 4 columns (extra rows for
#'   double counts).
#'
#'   \describe{
#'   \item{Crop}{The original integer crop identification numbers.}
#'   \item{Description}{The description associated with the identification
#'     number.}
#'   \item{New_Crop}{The proposed reclassification.}
#'   \item{New_Description}{The new description of the reclassified crop.}
#'   }
"reclass2"
