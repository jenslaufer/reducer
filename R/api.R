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

reduce <- function(df, time.interval, time.unit, date_field) {
  super.unit <- .get.super.unit(time.unit)
  unit.pl <- "lubridate::{time.unit}s" %>% glue::glue()
  unit <- "lubridate::{time.unit}" %>% glue::glue()
  
  df %>%
    dplyr::mutate(
      interval = lubridate::floor_date(!!as.name(date_field), unit = super.unit) + eval(parse(text = unit.pl))(ceiling(
        eval(parse(text = time.unit))(!!as.name(date_field)) / time.interval
      ) * time.interval)
    ) %>%
    dplyr::group_by(interval) %>%
    dplyr::summarise_all(~ mean(.)) %>%
    dplyr::ungroup() %>%
    dplyr::select(-date) %>%
    dplyr::rename(date = interval)
}
