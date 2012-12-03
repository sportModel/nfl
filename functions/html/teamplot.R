teamplot <- function(team,X,dec=TRUE,...)
  {
    n <- nrow(X)
    p <- ncol(X)
    if (dec) XR <- apply(-X,2,rank)
    else XR <- apply(X,2,rank)
    matplot(t(X),type="l",col="gray80",lty=1,xaxt="n",xlab="Week",...)
    lines(X[rownames(X)==team,],lwd=3,col="red")
    axis(1,at=1:p,labels=(1:p-1),cex.axis=.9)
    mtext(text=XR[rownames(XR)==team,],at=1:p,cex=.7)
  }
