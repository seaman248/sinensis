makeURLs <- function(baseURL, scafs, starts, ends){
  return(
    paste0(baseURL, scafs, ':', starts, '-', ends)
  )
}