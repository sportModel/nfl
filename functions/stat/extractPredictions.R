extractPredictions <- function() {
  last.week <- max(nfl$schedule$Week)
  results <- matrix(nfl$y, nrow=length(nfl$y)/2, ncol=2, byrow=TRUE)
  results <- data.frame(Week=nfl$schedule$Week[1:nrow(results)], Away=results[,1], Home=results[,2])
  X <- nfl$X
  n.g <- nrow(results)
  a <- apply(X[2*(1:n.g)-1,], 1, function(x) {a <- colnames(X)[which(x==1)]; a[grep("Off",a)]})
  h <- apply(X[2*(1:n.g),], 1, function(x) {a <- colnames(X)[which(x==1)]; a[grep("Off",a)]})
  Game <- gsub(".Off", "", paste(a, h, sep=" @ "), fixed=TRUE)
  df <- NULL
  for (i in 1:last.week) {
    load(paste("data/",nfl.par@year,"/pred",i-1,".RData",sep=""))
    ind <- which(results$Week==i)
    id1 <- paste("Week", i, names(prH), sep="")
    id2 <- paste("Week", results$Week, Game, sep="")
    res <- results[match(id1[ind], id2), ]
    Home <- splitright(names(prH), " @ ")[ind]
    Away <- splitleft(names(prH), " @ ")[ind]
    df.i <- data.frame(Week=i, Away=Away, Home=Home, prH=prH[ind], AwayPred=ms[ind,1], HomePred=ms[ind,2], AwayActual=res$Away, HomeActual=res$Home)
    rownames(df.i) <- names(prH[ind])
    df <- rbind(df, df.i)
  }
  df
}