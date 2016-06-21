import <- function(url) {
  require(XML)
  raw <- readHTMLTable(url, stringsAsFactors=FALSE)
  
  # PBP
  PBP <- raw$pbp_data
  names(PBP)[which(names(PBP)=='Win%')] <- 'Win'
  PBP <- PBP[!is.na(PBP$Win),]
  PBP <- PBP[PBP$Win != '',]
  PBP <- PBP[PBP$Win != 'Win%',]
  PBP$Win <- as.numeric(PBP$Win)
  PBP$EPA <- as.numeric(PBP$EPA)
  PBP$EPB <- as.numeric(PBP$EPB)
  
  # Team ID
  Away <- names(PBP)[7]
  Home <- names(PBP)[8]
  
  # Drives
  n <- length(raw)
  Drives <- raw[(n-2):(n-1)]
  names(Drives) <- c('Away', 'Home')
  
  # Return
  list(PBP=PBP, Away=Away, Home=Home, Drives=Drives)
}
