#' Downloads Spatial Data with the World Countries Polygons and Saves them as R
#' Objects.
#'
#' Downloads from Natural Earth two shapefiles - 10 m and 50 m precision - with
#' the world countries polygons and transforms them into two
#' SpatialPolygonsDataFrame that are saved in a folder called 'polys', inside
#' the user's working directory. The data that they contain is necessary for the
#' functions \code{\link{get_country}} and \code{\link{get_country_shoreline}}.
#'
#' @details
#' The two SpatialPolygonsDataFrame are saved in the working directory, inside
#' the 'polys' folder as .rda files and they are loaded from there when running
#' the functions \code{\link{get_country}} and
#' \code{\link{get_country_shoreline}}.
#'
#' \strong{Shapefiles:}
#' \itemize{
#' \item
#' \url{http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/ne_10m_admin_0_countries.zip}
#' \item
#' \url{http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/50m/cultural/ne_50m_admin_0_countries.zip}
#' }
#'
#' \strong{Shapefiles metadata:}
#' \itemize{
#' \item
#' \url{http://www.naturalearthdata.com/downloads/10m-cultural-vectors/10m-admin-0-countries/}
#' \item
#' \url{http://www.naturalearthdata.com/downloads/50m-cultural-vectors/50m-admin-0-countries-2/}
#' }
#'
#' @usage countries_polys()
#'
#' @references
#' Made with Natural Earth. Free vector and raster map data @@
#' naturalearthdata.com.
#'
#' @import sp
#' @import rgdal
#'
#' @export
#'
countries_polys <- function() {
  # Downloads the shapefiles with the countries polygons - 10m and 50m precision
  # - to a temporary directory which is empty when you quit the R session
  cat("\n")
  cat("Downloading the shapefiles from Natural Earth...\n")
  tmp10 <- tempfile(fileext = ".zip")
  download.file("http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/ne_10m_admin_0_countries.zip", tmp10)
  unzip(tmp10, exdir = tempdir())
  tmp50 <- tempfile(fileext = ".zip")
  download.file("http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/50m/cultural/ne_50m_admin_0_countries.zip", tmp50)
  unzip(tmp50, exdir = tempdir())
  rm(tmp10, tmp50)
  # list.files(tempdir())
  # Reads the data into a SpatialPolygonsDataFrame (R object from the "sp"
  # package)
  coun10_sp <- rgdal::readOGR(dsn = tempdir(),
    layer = "ne_10m_admin_0_countries", stringsAsFactors = FALSE,
    encoding = "UTF-8", use_iconv = TRUE)
  cat("\n")
  coun50_sp <- rgdal::readOGR(dsn = tempdir(),
    layer = "ne_50m_admin_0_countries", stringsAsFactors = FALSE,
    encoding = "UTF-8", use_iconv = TRUE)
  # View the field names in the shapefile attribute table
  # names(coun10_sp)
  # names(coun50_sp)
  # sum(names(coun10_sp) != names(coun50_sp))
  # Selects the necessary fields which allows to reduce a litle bit the object
  # size
  nec_fields <- c("SOVEREIGNT", "ADMIN", "ADM0_A3", "NAME", "ISO_A3",
    "CONTINENT", "SUBREGION", "NE_ID", "NAME_DE", "NAME_ES", "NAME_FR",
    "NAME_PT")
  countries_polys_10m <- coun10_sp[, nec_fields]
  countries_polys_50m <- coun50_sp[, nec_fields]
  # Saves the SpatialPolygonsDataFrames as .RData
  if (!file.exists("polys")) {
    dir.create("polys")
  }
  # Too big to be included in the package datasets
  # Has to be downloaded be the user
  # devtools::use_data(countries_polys_10m, overwrite = TRUE, compress = "xz")
  save(countries_polys_10m, file = "polys/countries_polys_10m.rda")
  cat("\n")
  cat("A spatial object with the countries polygons of 10 m precision as \n")
  cat("been created and saved in the 'polys' directory as \n")
  cat("'countries_polys_10m.rda'.\n")
  print(class(countries_polys_10m))
  cat("Extension of the object (longitude, latitude):\n")
  print(countries_polys_10m@bbox)
  # cat("\n Coordinate reference system:\n")
  # print(countries_polys_10m@proj4string)
  # devtools::use_data(countries_polys_50m, overwrite = TRUE, compress = "xz")
  save(countries_polys_50m, file = "polys/countries_polys_50m.rda")
  cat("\n")
  cat("A spatial object with the countries polygons of 50 m precision as \n")
  cat("been created and saved in the 'polys' directory as \n")
  cat("'countries_polys_50m.rda'.\n")
  print(class(countries_polys_50m))
  cat("Extension of the object (longitude, latitude):\n")
  print(countries_polys_50m@bbox)
  cat("\n")
  # cat("\n Coordinate reference system:\n")
  # print(countries_polys_50m@proj4string)
  # As sysdata.rda
  # devtools::use_data(countries_polys_10m, countries_polys_50m,
  # internal = TRUE)
  # Maps
  # plot(countries_polys_10m)
  # plot(countries_polys_50m)
}
