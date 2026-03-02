# scripts/update_hicp.R

suppressPackageStartupMessages({
  library(eurostat)
  library(dplyr)
  library(tidyr)
  library(readr)
  library(lubridate)
})

# --- Config ---
countries <- c("EA20","DE","FR","IT","ES")
outfile <- "hicp_inflation_yoy_monthly_EA20_DE_FR_IT_ES.csv"

# Eurostat dataset:
# prc_hicp_manr = HICP, Monthly data, rate of change compared to same month of previous year
data_raw <- get_eurostat("prc_hicp_manr", time_format = "date")

dw <- data_raw %>%
  filter(
    geo %in% countries,
    coicop == "CP00" # All-items HICP
  ) %>%
  transmute(
    date = as.Date(TIME_PERIOD),
    geo,
    value = as.numeric(values)
  ) %>%
  mutate(date = format(date, "%Y-%m")) %>%  # Datawrapper friendly
  pivot_wider(names_from = geo, values_from = value) %>%
  arrange(date) %>%
  rename(
    `Euro area (EA20)` = EA20,
    Germany = DE,
    France  = FR,
    Italy   = IT,
    Spain   = ES
  )

# (opcional) si quieres recortar a un periodo razonable:
# dw <- dw %>% filter(date >= "2000-01")

write_csv(dw, outfile, na = "")
cat("Wrote:", outfile, "rows:", nrow(dw), "\n")
