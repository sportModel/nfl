Wplot <- function(prW,w,N=10000)
  {
    n <- length(prW)
    X <- matrix(rbinom(N*n,1,prW),nrow=N,ncol=n,byrow=TRUE)
    p <- prop.table(table(apply(X,1,sum)))
    names(p) <- w+as.numeric(names(p))
    exW <- sum(p*as.numeric(names(p)))
    barplot(p,ylab="Probability",xlab="Wins",main=paste("Expected wins: ",round(exW,1)))
  }
