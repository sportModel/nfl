# Reads raw html file and returns:
##   X (Design matrix, past games)
##   y (Score, past games)
##   XX (Design matrix, future games)
##   schedule (the entire schedule for all weeks)
formatData <- function() {
  filename <- paste("data/",nfl.par@year,"/nfl.html",sep="")
  require(XML)
  raw <- readHTMLTable(filename)

  ## Format past games
  A <- raw[[1]]
  A <- subset(A, Week != "Week")
  A <- subset(A, Week != "")
  A <- A[, names(A) != ""]
  at <- A[".1"]=="@"
  n <- nrow(A)
  Away <- character(n)
  Away[!at] <- A$Loser[!at]
  Away[at] <- A$Winner[at]
  Home <- character(n)
  Home[at] <- A$Loser[at]
  Home[!at] <- A$Winner[!at]
  sched1 <- data.frame(Week = A$Week, Away = Away, Home = Home)
  y <- as.numeric(apply(A[, c(".1", "PtsW", "PtsL")], 1, function(x) if (x[1]=="@") x[2:3] else x[3:2]))

  ## Format future games
  sched2 <- NULL
  if (length(raw) > 1) {
    B <- raw[[2]]
    B <- subset(B, Week != "Week")
    sched2 <- data.frame(Week=B$Week, Away= B$VisTm, Home=B$HomeTm)
  }

  ## Reconcile
  allX <- makeX(rbind(sched1, sched2))
  n <- sum(!is.na(y))
  y <- y[1:n]
  X <- allX[1:n,]
  XX <- allX[-(1:n),]

  ## Return
  schedule <- rbind(sched1, sched2)
  schedule$Week[schedule$Week=="WildCard"] <- max(suppressWarnings(as.numeric(schedule$Week)), na.rm=TRUE) + 1
  schedule$Week[schedule$Week=="Division"] <- max(suppressWarnings(as.numeric(schedule$Week)), na.rm=TRUE) + 1
  schedule$Week[schedule$Week=="ConfChamp"] <- max(suppressWarnings(as.numeric(schedule$Week)), na.rm=TRUE) + 1
  schedule$Week[schedule$Week=="SuperBowl"] <- max(suppressWarnings(as.numeric(schedule$Week)), na.rm=TRUE) + 1
  schedule$Week <- as.numeric(schedule$Week)
  list(X=X, y=y, XX=XX, schedule=schedule)
}
