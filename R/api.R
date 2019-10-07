.get.super.unit <- function(unit) {
  switch(
    unit,
    "second" = "minute",
    "minute" = "hour",
    "hour" = "day",
    "day" = "month",
    "month" = "year"
  )
}

reduce <- function(df, time.interval, unit, date_field) {
  super.unit <- .get.super.unit(unit)
  unit.pl <- "lubridate::{unit}s" %>% glue::glue()
  unit <- "lubridate::{unit}" %>% glue::glue()
  
  df %>%
    dplyr::mutate(
      interval = lubridate::floor_date(!!as.name(date_field), unit = super.unit) + eval(parse(text = unit.pl))(ceiling(
        eval(parse(text = unit))(!!as.name(date_field)) / time.interval
      ) * time.interval)
    ) %>%
    dplyr::group_by(interval) %>%
    dplyr::summarise_all(~ mean(.)) %>%
    dplyr::ungroup() %>%
    dplyr::select(-date) %>%
    dplyr::rename(date = interval)
}
