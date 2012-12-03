gibbs <- function(X,y,prior=NULL,N=100000,w1=nfl.par@w1,w2=nfl.par@w2)
  {
    p <- dim(X)[2]
    if (is.null(prior)) prior <- list(beta=c(20,numeric(p-1)),H=diag(p),s2=500,v=5)
    if (length(y)==0)
      {
        beta <- rmvnorm(N,prior$beta,w1*ginv(prior$H),method="svd")
        h <- rchisq(N,prior$v/w2)/(prior$s2/w2)
        val <- cbind(beta,h)
        colnames(val) <- c(colnames(X),"h")
        return(val)
      }
    Off <- grep("Off",colnames(X))
    Def <- grep("Def",colnames(X))
    beta.curr <- rep(0,p)
    h.curr <- 1
    chisq.draws <- rchisq(N,prior$v/w2+length(y))
    val <- matrix(NA,ncol=p+1,nrow=N)
    colnames(val) <- c(colnames(X),"h")
    XtX <- crossprod(X)
    Xty <- crossprod(X,y)
    for(i in 1:N)
      {
        H <- prior$H/w1 + h.curr*XtX
        H.inv <- ginv(H)
        mean <- H.inv%*%(prior$H%*%prior$beta/w1 + h.curr*Xty)
        beta.curr <- t(rmvnorm(1,mean,H.inv,method="svd"))
        ## Enforce sum-to-zero constraint
        beta.curr[1] <- beta.curr[1] + mean(beta.curr[Off]) + mean(beta.curr[Def])
        beta.curr[Off] <- beta.curr[Off] - mean(beta.curr[Off])
        beta.curr[Def] <- beta.curr[Def] - mean(beta.curr[Def])
        s2 <- as.numeric(prior$s2/w2 + crossprod(y-X%*%beta.curr))
        h.curr <- chisq.draws[i]/s2
        val[i,] <- c(beta.curr,h.curr)
        displayProgressBar(i,N)
      }
    val
  }
