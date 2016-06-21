bigplays <- function(Data, type='p', plot=TRUE) {
  PBP <- Data$PBP
  Diff <- diff(c(56.6, PBP$Win))
  if (type=='p') {
    pDiff <- PBP$EPA-PBP$EPB
    Diff <- abs(pDiff) * sign(Diff)
    ind1 <- which(Diff < -3)
    ind2 <- which(Diff > 3)
    X <- cbind(PBP[,c(1:6, 9:11)], Diff)
  } else {
    ind1 <- which(Diff < -10)
    ind2 <- which(Diff > 10)
    X <- cbind(PBP[,c(1:6, 9:11)], Diff)
  }
  X1 <- X[ind1,]
  X1 <- X1[order(X1$Diff),]
  X2 <- X[ind2,]
  X2 <- X2[order(X2$Diff, decreasing=TRUE),]
  cat("Big plays for", Data$Away, "\n")
  print(X1)
  cat("Big plays for", Data$Home, "\n")
  print(X2)
  if (plot) {
    d1 <- sort(abs(Diff[Diff < 0]), decreasing=TRUE)
    d2 <- sort(abs(Diff[Diff > 0]), decreasing=TRUE)
    n <- max(length(d1), length(d2))
    x1 <- 1:length(d1) - 0.1
    x2 <- 1:length(d2) + 0.1
    plot(x1, d1, col=pal(2)[1], type='h', lwd=2, xlim=c(1,n), bty='n', las=1,
         xlab='Play', ylab='Diff')
    lines(x2, d2, col=pal(2)[2], type='h', lwd=2)
    toplegend(legend=c(Data$Away, Data$Home), col=pal(2), lwd=2)
  }
}
