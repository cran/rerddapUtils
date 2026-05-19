## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup--------------------------------------------------------------------
library(arrow)
library(dplyr)
library(duckdb)
library(duckplyr)
library(lubridate)
library(ncdf4)
library(rerddap)
library(rerddapUtils)

## ----test_season_time---------------------------------------------------------
year <- '2023'
season <- c('02-01', '06-01')
# test that "season" is defined properly
test_time <- paste0(year, '-', season)
lubridate::as_datetime(test_time)

## ----wind_extract, eval=FALSE-------------------------------------------------
# wind_info <- rerddap::info('erdQMekm14day')
# extract <- rerddap::griddap(wind_info,
#                             time = c('2015-01-01','2019-01-01'),
#                             latitude = c(20, 40),
#                             longitude = c(220, 240),
#                             fields = 'mod_current'
# )

## ----wind_season, eval = FALSE------------------------------------------------
# wcnURL <- "https://coastwatch.pfeg.noaa.gov/erddap/"
# wind_info <- rerddap::info('erdQMekm14day', url = wcnURL)
# season <- c('03-01', '05-01')
# season_extract <- griddap_season(wind_info,
#  time = c('2015-01-01','2019-01-01'),
#  latitude = c(20, 40),
#  longitude = c(220, 240),
#  fields = 'mod_current',
#  season = season
# )
# 

## ----season_months, eval = FALSE----------------------------------------------
# extract_times  <- lubridate::as_datetime(season_extract$data$time)
# extract_months <- lubridate::month(extract_times)
# unique(extract_months)

## ----request_split------------------------------------------------------------
request_split <- list(time = 5, altitude = 1, latitude = 2, longitude = 2)

## ----request_split_fail, eval = FALSE-----------------------------------------
# request_split <- list(time = 5, latitude = 2, longitude = 2)

## ----wind_extract_redux, eval=FALSE-------------------------------------------
# wind_info <- rerddap::info('erdQMekm14day')
# extract <- rerddap::griddap(wind_info,
#                             time = c('2015-01-01','2016-01-01'),
#                             latitude = c(20, 40),
#                             longitude = c(220, 240),
#                             fields = 'mod_current'
# )

## ----wind_extract_size, eval = FALSE------------------------------------------
# sz <- estimate_griddap_size(wind_info,
#                             time = c('2015-01-01','2016-01-01'),
#                             latitude = c(20, 40),
#                             longitude = c(220, 240),
#                             fields = 'mod_current',
# )
# 
# 

## ----wind_extract_split_size, eval = FALSE------------------------------------
# estimate_griddap_split_size(sz,
#  splits = request_split
#  )
# 

## ----wind_split_memory, eval = FALSE------------------------------------------
# wcnURL <- "https://coastwatch.pfeg.noaa.gov/erddap/"
# wind_info <- rerddap::info('erdQMekm14day', url = wcnURL)
# request_split <- list(time = 5, altitude = 1, latitude = 2, longitude = 2)
# split_extract <- griddap_split(wind_info,
#  time = c('2015-01-01','2016-01-01'),
#  latitude = c(20, 40),
#  longitude = c(220, 240),
#  fields = 'mod_current',
#  request_split = request_split,
#  fmt = "memory"
# )
# str(split_extract)

## ----wind_split_nc, eval = FALSE----------------------------------------------
# wcnURL <- "https://coastwatch.pfeg.noaa.gov/erddap/"
# wind_info <- rerddap::info('erdQMekm14day', url = wcnURL)
# request_split <- list(time = 5, altitude = 1, latitude = 2, longitude = 2)
# split_extract <- griddap_split(wind_info,
#  time = c('2015-01-01','2016-01-01'),
#  latitude = c(20, 40),
#  longitude = c(220, 240),
#  fields = 'mod_current',
#  request_split = request_split,
#  fmt = "nc"
# )
# 

## ----wind_split_nc_named, eval=FALSE------------------------------------------
# 
# wind_info <- rerddap::info('erdQMekm14day')
# request_split <- list(time = 5, altitude = 1, latitude = 2, longitude = 2)
# split_extract <- griddap_split(wind_info,
#  time = c('2015-01-01','2016-01-01'),
#  latitude = c(20, 40),
#  longitude = c(220, 240),
#  fields = 'mod_current',
#  request_split = request_split,
#  fmt = "nc",
#  aggregate_file = 'wind_extract.nc'
# )
# 

## ----wind_split_read_nc, eval = FALSE-----------------------------------------
# wind_file <- ncdf4::nc_open(split_extract )
# wind_file
# ncdf4::nc_close(wind_file)
# 

## ----wind_split_duckdb, eval = FALSE------------------------------------------
# 
# wind_info <- rerddap::info('erdQMekm14day')
# request_split <- list(time = 5, altitude = 1, latitude = 2, longitude = 2)
# split_extract <- griddap_split(wind_info,
#  time = c('2015-01-01','2016-01-01'),
#  latitude = c(20, 40),
#  longitude = c(220, 240),
#  fields = 'mod_current',
#  request_split = request_split,
#  fmt = "duckdb",
#  aggregate_file = 'wind_extract.duckdb'
# )
# 

## ----wind_split_read, eval = FALSE--------------------------------------------
# con_db <- dbConnect(duckdb::duckdb(), "wind_extract.duckdb")
# tbl(con_db, "extract") |>
#      head(5) |>
#      collect()
# dbDisconnect(con_db, shutdown=TRUE)

## ----wind_split_parquet, eval = FALSE-----------------------------------------
# con_db <- dbConnect(duckdb::duckdb(), "wind_extract.duckdb")
# # Use DuckDB's COPY command to write directly to Parquet file without loading into R
# query <- sprintf("COPY extract TO '%s' (FORMAT 'parquet')", "wind_extract.parquet")
# DBI::dbExecute(con_db, query)
# dbDisconnect(con_db, shutdown=TRUE)

## ----proj_strings, eval = FALSE-----------------------------------------------
#    proj_strings <- c('proj4text', 'projection', 'proj4string', 'grid_mapping_epsg_code',
#                     'WKT',  'proj_crs_code',
#                     'grid_mapping_epsg_code', 'grid_mapping_proj4',
#                     'grid_mapping_proj4_params', 'grid_mapping_proj4text')
# 

## ----bounding_box-------------------------------------------------------------
latitude <- c( 80., 85.)
longitude <- c(-170., -165)


## ----latlon_to_xy, eval = FALSE-----------------------------------------------
# myURL <- 'https://coastwatch.noaa.gov/erddap/'
# myInfo <- rerddap::info('noaacwVIIRSn20icethickNP06Daily', url = myURL)
# coords <- latlon_to_xy(myInfo,  longitude, latitude)
# coords

## ----xy_to_latlon, eval = FALSE-----------------------------------------------
# rows <- c( -889533.8, -469356.9)
# cols <- c(622858.3, 270983.4)
# myURL <- 'https://coastwatch.noaa.gov/erddap/'
# myInfo <- rerddap::info('noaacwVIIRSn20icethickNP06Daily', url = myURL)
# proj_extract <- rerddap::griddap(myInfo,
#                                   time = c('2023-01-30T00:00:00Z', '2023-01-30T00:00:00Z'),
#                                   rows = rows,
#                                   cols = cols,
#                                   fields = 'IceThickness',
#                                   url = myURL
#   )
# test <- xy_to_latlon(proj_extract)
# head(test)
# 

