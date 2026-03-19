options(timeout = 600)

suppressPackageStartupMessages({
  library(eurostat)
  library(dplyr)
})

data_raw <- tryCatch(
  get_eurostat("namq_10_gdp", time_format = "date"),
  error = function(e) {
    message("Error al descargar GDP desde Eurostat: ", e$message)
    stop(e)
  }
)

message("Descarga completada.")
message("Columnas disponibles:")
print(names(data_raw))
