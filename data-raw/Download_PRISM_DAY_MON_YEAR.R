sp_res = "4km"
var = "ppt" # ppt, tmin, tmax, tmean, tdmean, vpdmin, or vpdmax
year = 2012
t_res = "monthly"

for(year in c(2003)){
  for(var in c("ppt", "tmin", "tmax", "tmean", "tdmean", "vpdmin", "vpdmax")){
    # Create all the days of the year if requested.
    if(t_res == "daily"){
      tdate <- seq(as.Date(paste0(year, "-01-01")),
                   as.Date(paste0(year, "-12-31")),
                   by = "day")
      tdate <- gsub("-", "", tdate)
    }else if(t_res == "monthly"){
      tdate <- paste0(year, c("10", "11", "12"))
    }else{
      tdate <- year
    }

    tsource = paste("http://services.nacse.org/prism/data/public", sp_res, var, tdate, sep = "/")
    destination = paste("data-raw/prism", year, var, t_res, sep = "/")
    tagname <- paste("PRISM", var, sp_res, tdate, sep = "_")
    final_location <- paste0(destination, "/", tagname, ".zip")

    # Create directory if it doesn't exist.
    # - https://stackoverflow.com/questions/4216753/check-existence-of-directory-and-create-if-doesnt-exist
    if (!dir.exists(destination)){
      dir.create(destination, recursive = TRUE)
    }

    for(i in 1:length(tsource)){
      print(paste("Downloading day", i, "of", length(tsource)))
      try(utils::download.file(tsource[i], final_location[i], mode = "wb"))
      try(utils::unzip(final_location[i],
                       exdir = destination))
      try(file.remove(final_location[i]))
      Sys.sleep(1)
    }
  }
}







